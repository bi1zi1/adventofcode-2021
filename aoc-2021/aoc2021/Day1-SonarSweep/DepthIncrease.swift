import Foundation

public final class DepthIncrease {
    private let fileReader: FileReader

    public init(measurementsFile: FileResource = .depthMeasurements) {
        self.fileReader = FileReader(fileResource: measurementsFile)
    }

    public func depthIncreaseCount() -> Int {
        depthIncreaseCount(with: 1)
    }

    public func depthIncreaseCount(with slidingWindowSize: Int = 3) -> Int {
        let slidingWindowList = slidingWindowList(with: slidingWindowSize)
        return depthIncreaseCount(with: slidingWindowList)
    }

    private func slidingWindowList(with slidingWindowSize: Int) -> [Int] {
        var slidingWindow = SlidingWindow(size: slidingWindowSize)
        var result: [Int] = []

        try? fileReader.lines().lazy.forEach { value in
            guard let currentValue = Int(value) else { return } // ignore error for now

            slidingWindow.push(currentValue)
            if slidingWindow.full {
                result.append(slidingWindow.sum())
            }
        }

        return result
    }

    private func depthIncreaseCount(with list: [Int]) -> Int {
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
}
