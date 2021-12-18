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

    func minPath(
        start: Point,
        end: Point,
        pathMatrix: Extended5x5Matrix2DInt,
        visitedPoints: Set<Point>,
        subpathValueMap: inout [Point: Int]
    ) -> Int {
        if start == end {
            return .zero
        }

        let nextSteps = start.nextAvailable4(
            exMX: pathMatrix, visitedPoints: visitedPoints
        )

        let lowestRiskPath = nextSteps.reduce(into: Int.max / 2) { partialResult, point in
            let pointValue = pathMatrix[point]
            let nextPointPathValue = subpathValueMap[point]
            ?? minPath(
                start: point,
                end: end,
                pathMatrix: pathMatrix,
                visitedPoints: visitedPoints.union([start]),
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

        return subpathValueMap[start]!
    }
}

extension ChitonPathCalculator {
    func weightMx(
        start: Point,
        end: Point,
        pathMatrix: Extended5x5Matrix2DInt
    ) -> [Point: Int] {
        var visitedPoints: Set<Point> = []
        var pointsLeft = Set(pathMatrix.coordsToPoints())
        var subpathValueMap = [
            start: Int.zero
        ]

        var filteredSubpathValueMap = [
            start: Int.zero
        ]

//        let startTime = Date()
//        var lastProcessedTime = Date()

        while !pointsLeft.isEmpty {
            guard let current = filteredSubpathValueMap.keys
                    .min(by: { lhs, rhs in
                        subpathValueMap[lhs]! < subpathValueMap[rhs]!
                    })
            else {
                assertionFailure("Boom")
                return [:]
            }

            pointsLeft.remove(current)
            visitedPoints.insert(current)
            filteredSubpathValueMap.removeValue(forKey: current)

//            let pointsCount = visitedPoints.count
//            if pointsCount % 1000 == 0 {
//                let lastTimeDiff = Date().timeIntervalSince(lastProcessedTime)
//                let lastSpeed = 1000.0 / lastTimeDiff
//
//                lastProcessedTime = Date()
//                let timeDiff = lastProcessedTime.timeIntervalSince(startTime)
//                let speed = Double(pointsCount) / timeDiff
//
//                print("speed = \(speed) points/sec [\(lastSpeed)] [\(pointsCount)] [\(Date())]")
//            }

            current.nextAvailable4(
                exMX: pathMatrix,
                visitedPoints: visitedPoints
            ).forEach { nextPoint in
                let calcVal = subpathValueMap[current]! + pathMatrix[nextPoint]
                if calcVal < subpathValueMap[nextPoint, default: Int.max] {
                    subpathValueMap[nextPoint] = calcVal

                    if !visitedPoints.contains(nextPoint) {
                        filteredSubpathValueMap[nextPoint] = calcVal
                    }
                }
            }
        }

        return subpathValueMap
    }
}
