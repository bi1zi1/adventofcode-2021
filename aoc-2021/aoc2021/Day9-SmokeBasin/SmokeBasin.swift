import Foundation

public final class SmokeBasin {
    private let fileReader: FileReader
    public init(measurementsFile: FileResource = .areaPointsData) {
        fileReader = FileReader(fileResource: measurementsFile)
    }

    public func lowPointsRiskLevelSum() -> Int {
        guard let data = try? fileReader.lines() else {
            assertionFailure("data missing")
            return .zero
        }

        let area = Area(lines: data)
        let horizontalDips = area.rows.map { $0.indexOfDips() }
        let verticalDips = area.columns.map { $0.indexOfDips() }

        let dipsCoordinates: [(Int, Int)] = horizontalDips.enumerated().reduce([]) { partialResult, item in
            let lineNo = item.offset
            let dips = item.element

            return partialResult
            + dips.reduce([]) { partialResult, hIndex in
                verticalDips[hIndex].contains(lineNo)
                ? partialResult + [(lineNo, hIndex)]
                : partialResult
            }
        }

        return dipsCoordinates.reduce(Int.zero) { partialResult, coord in
            partialResult + area.rows[coord.0][coord.1] + 1
        }
    }


}

extension Array where Element == Int {
    func indexOfDips() -> [Int] {
        enumerated().reduce([]) { partialResult, item in
            let index = item.offset
            let value = item.element

            let previousIndex = index - 1
            let nextIndex = index + 1

            if previousIndex >= .zero {
                if self[previousIndex] <= value { return partialResult }
            }

            if nextIndex < count {
                if self[nextIndex] <= value { return partialResult }
            }

            return partialResult + [index]
        }
    }
}
