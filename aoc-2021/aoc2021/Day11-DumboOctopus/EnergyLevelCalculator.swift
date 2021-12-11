import Foundation

public final class EnergyLevelCalculator {
    private let valueMax = 9
    private let fileReader: FileReader
    public init(measurementsFile: FileResource = .energyLevelsData) {
        fileReader = FileReader(fileResource: measurementsFile)
    }

    public func totalFlashes100steps() -> Int {
        guard let data = try? fileReader.lines().filter({ !$0.isEmpty }) else {
            assertionFailure("data missing")
            return .zero
        }

        let energyLevels = EnergyLevels(lines: data)
        return (1...100).reduce(.zero) {
            $0 + step(energyLevels: energyLevels, id: $1)
        }
    }

    func step(energyLevels: EnergyLevels, id: Int) -> Int {
        // ignore id
        var reprocessPoints: Set<Point> = []
        energyLevels.energyFormation.forEach { row in
            row.forEach { item in
                item.increaseValue()

                if item.value > valueMax {
                    item.affectedCoordinates.forEach { point in
                        energyLevels.energyFormation[point.x][point.y].increaseValue()
                    }

                    item.preAffectedCoordinates.forEach { point in
                        if energyLevels.energyFormation[point.x][point.y].value == valueMax + 1 {
                            reprocessPoints.insert(point)
                        }
                    }
                }
            }
        }

        while !reprocessPoints.isEmpty {
            let runReprocessPoints = reprocessPoints
            var processedPoints: [Point] = []
            reprocessPoints = []
            for point in runReprocessPoints {
                processedPoints.append(point)
                let item = energyLevels.energyFormation[point.x][point.y]

                if item.value > valueMax {
                    item.affectedCoordinates.forEach { point in
                        let affectedPoint = energyLevels.energyFormation[point.x][point.y]
                        affectedPoint.increaseValue()

                        if affectedPoint.value == valueMax + 1 {
                            reprocessPoints.insert(point)
                        }
                    }
                }
            }
        }

        for x in (0..<EnergyLevels.rowLength) {
            for y in (0..<EnergyLevels.columnLength) {
                let item = energyLevels.energyFormation[x][y]
                if item.value > valueMax {
                    item.resetValue()
                }
            }
        }

        return energyLevels.energyFormation.reduce(.zero) { partialResult, lineItem in
            partialResult + lineItem.reduce(.zero) {
                $0 + ($1.value > .zero ? .zero : 1)
            }
        }
    }
}
