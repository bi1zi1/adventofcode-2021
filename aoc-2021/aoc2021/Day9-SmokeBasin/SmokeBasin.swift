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
        let dipsCoordinates = dipsCoordinates(for: area)

        return dipsCoordinates.reduce(Int.zero) { partialResult, coord in
            partialResult + area.rows[coord.0][coord.1] + 1
        }
    }

    public func basinTop3Multiply() -> Int {
        guard let data = try? fileReader.lines() else {
            assertionFailure("data missing")
            return .zero
        }

        let area = Area(lines: data)
        var set = Set<Point>()
        let basins = dipsCoordinates(for: area).map {
            basin(for: area, point: Point(point: $0), processed: &set)
        }

        let compactBasin = basins
            .map(Set.init)
            .sorted { $0.count > $1.count }

        return compactBasin[0].count * compactBasin[1].count * compactBasin[2].count
    }

    func dipsCoordinates(for area: Area) -> [(Int, Int)] {
        let horizontalDips = area.rows.map { $0.indexOfDips() }
        let verticalDips = area.columns.map { $0.indexOfDips() }

        return horizontalDips.enumerated().reduce([]) { partialResult, item in
            let lineNo = item.offset
            let dips = item.element

            return partialResult
            + dips.reduce([]) { partialResult, hIndex in
                verticalDips[hIndex].contains(lineNo)
                ? partialResult + [(lineNo, hIndex)]
                : partialResult
            }
        }
    }

    func basin(for area: Area, point: Point, processed: inout Set<Point>) -> [Point] {
        guard !processed.contains(point) else {
            return []
        }

        let rowIx = point.x
        let colIx = point.y

        guard rowIx >= .zero, rowIx < area.rows.count else {
            return []
        }

        guard colIx >= .zero, colIx < area.rows[rowIx].count else {
            return []
        }

        guard area.rows[rowIx][colIx] < 9 else {
            return []
        }

        let nextPoints = [
            Point(x: rowIx - 1, y: colIx),
            Point(x: rowIx + 1, y: colIx),
            Point(x: rowIx, y: colIx - 1),
            Point(x: rowIx, y: colIx + 1),
        ]

        processed.insert(point)

        return nextPoints.reduce([point]) { partialResult, nextPoint in
            partialResult + basin(for: area, point: nextPoint, processed: &processed)
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
