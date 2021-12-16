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
}
