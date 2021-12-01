import Foundation

public final class DepthIncrease {
    private let fileReader: FileReader

    public init(measurementsFile: FileResource = .depthMeasurements) {
        self.fileReader = FileReader(fileResource: measurementsFile)
    }

    public func depthIncreaseCount() -> Int {
        var totalCount = Int.zero
        var previousValue: Int?

        try? fileReader.lines().lazy.forEach { value in
            guard let currentValue = Int(value) else { return } // ignore error for now

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
