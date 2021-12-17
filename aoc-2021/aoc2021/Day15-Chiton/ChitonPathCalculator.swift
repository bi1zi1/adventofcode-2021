import Foundation

public final class ChitonPathCalculator {
    private let fileReader: FileReader
    public init(measurementsFile: FileResource = .chitonRiskLevelData) {
        fileReader = FileReader(fileResource: measurementsFile)
    }

    public func lowestRiskPath() -> Int {
        guard let data = try? fileReader.lines().filter({ !$0.isEmpty }) else {
            assertionFailure("data missing")
            return .zero
        }

        let riskMatrix = data.compactMap { line in
            line.compactMap { Int(String($0)) }
        }

        return calculateLowestRisk(mx: riskMatrix)
    }

    public func lowestRiskPath5x5() -> Int {
        guard let data = try? fileReader.lines().filter({ !$0.isEmpty }) else {
            assertionFailure("data missing")
            return .zero
        }

        let riskMatrix = Matrix2DInt(data: data)
        let extendedMatrix = Extended5x5Matrix2DInt(mx: riskMatrix)

        return calculateLowestRisk(exMX: extendedMatrix)
    }

    func calculateLowestRisk(exMX: Extended5x5Matrix2DInt) -> Int {
        let start = Point(x: 0, y: 0)
        let end = Point(x: exMX.rowCount - 1, y: exMX.columnCount - 1)

//        (start.x...end.x).forEach { x in
//            print("row: \(x)")
//            (start.y...end.y).forEach { y in
//                print(exMX[x,y], terminator: "")
//            }
//            print("")
//        }

        var subpathValueMap: [Point: Int] = [:]
        return minPath(
            start: start,
            end: end,
            pathMatrix: exMX,
            visitedPoints: Set([start]),
            subpathValueMap: &subpathValueMap
        )
    }

    func calculateLowestRisk(mx: [[Int]]) -> Int {
        let start = Point(x: 0, y: 0)
        let end = Point(x: mx.count - 1, y: mx.last!.count - 1)

//        (start.x...end.x).forEach { x in
//            print("row: \(x)")
//            (start.y...end.y).forEach { y in
//                print(mx[x][y], terminator: " ")
//            }
//            print("")
//        }

        var subpathValueMap: [Point: Int] = [:]
        return minPath(
            start: start,
            end: end,
            pathMatrix: mx,
            subpathValueMap: &subpathValueMap
        )
    }
}

extension Point {
    func nextAvailable(mx: [[Int]], visited: [Point]) -> [Point] {
        [
            Point(x: x - 1, y: y),
            Point(x: x + 1, y: y),
            Point(x: x, y: y - 1),
            Point(x: x, y: y + 1),
        ].filter { point in
            !visited.contains(point)
            && point.x >= .zero
            && point.y >= .zero
            && point.x < mx.count
            && point.y < mx[x].count
        }
    }

    func nextAvailable2(mx: [[Int]]) -> [Point] {
        [
            Point(x: x + 1, y: y),
            Point(x: x, y: y + 1),
        ].filter { point in
            point.x >= .zero
            && point.y >= .zero
            && point.x < mx.count
            && point.y < mx[x].count
        }
    }

    func nextAvailable2(exMX: Extended5x5Matrix2DInt) -> [Point] {
        [
            Point(x: x + 1, y: y),
            Point(x: x, y: y + 1),
        ].filter { point in
            point.x >= .zero
            && point.y >= .zero
            && point.x < exMX.rowCount
            && point.y < exMX.columnCount
        }
    }

    func nextAvailable4(
        exMX: Extended5x5Matrix2DInt,
        visitedPoints: Set<Point>
    ) -> [Point] {
        [
            Point(x: x - 1, y: y),
            Point(x: x + 1, y: y),
            Point(x: x, y: y - 1),
            Point(x: x, y: y + 1),
        ].filter { point in
            !visitedPoints.contains(point)
            && point.x >= .zero
            && point.y >= .zero
            && point.x < exMX.rowCount
            && point.y < exMX.columnCount
        }.sorted { lhs, rhs in
            exMX[lhs] < exMX[rhs]
        }
    }
}
