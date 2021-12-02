import Foundation

public final class DepthIncrease {
    private let formattedFileReader: FormattedFileReader

    public init(measurementsFile: FileResource = .depthMeasurements) {
        self.formattedFileReader = FormattedFileReader(fileResource: measurementsFile)
    }

    public func depthIncreaseCount() -> Int {
        depthIncreaseCount(with: 1)
    }

    public func depthIncreaseCount(with slidingWindowSize: Int = 3) -> Int {
        let slidingWindowList = slidingWindowList(with: slidingWindowSize)
        return depthIncreaseCount(for: slidingWindowList)
    }

    private func slidingWindowList(with slidingWindowSize: Int) -> [Int] {
        var slidingWindow = SlidingWindow(size: slidingWindowSize)
        var result: [Int] = []

        let data = extractDepthValues(from: formattedFileReader.dataRows())

        data.lazy.forEach { value in
            slidingWindow.push(value)
            if slidingWindow.full {
                result.append(slidingWindow.sum())
            }
        }

        return result
    }

    private func depthIncreaseCount(for list: [Int]) -> Int {
        var totalCount = Int.zero
        var previousValue: Int?

        list.lazy.forEach { currentValue in
            defer {
                previousValue = currentValue
            }

            guard let previousValue = previousValue else {
                return
            }

            if currentValue > previousValue {
                totalCount += 1
            }
        }

        return totalCount
    }

    private func extractDepthValues(from rows: [Row]) -> [Int] {
        rows.compactMap {
            let type = $0.columns[0].type
            let rawValue = $0.columns[0].rawValue
            return type.value(from: rawValue)
        }
    }
}
