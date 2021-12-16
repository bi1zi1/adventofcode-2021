import Foundation

extension ChitonPathCalculator {
    func minPath(
        start: Point,
        end: Point,
        pathMatrix: [[Int]],
        subpathValueMap: inout [Point: Int]
    ) -> Int {
        if start == end {
            return .zero
        }

        let nextSteps = start.nextAvailable2(
            mx: pathMatrix
        )

        let lowestRiskPath = nextSteps.reduce(into: Int.max / 2) { partialResult, point in
            let pointValue = pathMatrix[point.x][point.y]
            let nextPointPathValue = subpathValueMap[point]
            ?? minPath(
                start: point,
                end: end,
                pathMatrix: pathMatrix,
                subpathValueMap: &subpathValueMap
            )
            let pathValue = pointValue + nextPointPathValue

            partialResult = min(
                partialResult,
                pathValue
            )
        }

        subpathValueMap[start] = min(
            subpathValueMap[start, default: Int.max],
            lowestRiskPath
        )

        return lowestRiskPath
    }
}
