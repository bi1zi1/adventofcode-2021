import Foundation

typealias Positions = [Int]

public final class PositionAlign {
    private let fileReader: FileReader
    private static let fuelPerMove = 1

    public init(measurementsFile: FileResource = .horizontalPositionData) {
        fileReader = FileReader(fileResource: measurementsFile)
    }

    public func minFuel() -> Int {
        guard let data = try? fileReader.lines().first else {
            assertionFailure("data missing")
            return .zero
        }

        let positions = data.split(separator: ",").compactMap { Int($0) }

        return calculateMinFuel(for: positions)
    }

    public func minFuelDynamicSpend() -> Int {
        guard let data = try? fileReader.lines().first else {
            assertionFailure("data missing")
            return .zero
        }

        let positions = data.split(separator: ",").compactMap { Int($0) }

        return calculateMinFuelDynamicSpend(for: positions)
    }

    func calculateMinFuel(for positions: Positions) -> Int {
        let startPosition = positions.min() ?? .zero
        let endPosition = positions.max() ?? .zero

        let fuelSpend = (startPosition...endPosition).map { position in
            positions.reduce(Int.zero, { $0 + abs($1 - position) * PositionAlign.fuelPerMove })
        }

        return fuelSpend.min() ?? .zero
    }

    func calculateMinFuelDynamicSpend(for positions: Positions) -> Int {
        let startPosition = positions.min() ?? .zero
        let endPosition = positions.max() ?? .zero

        let fuelSpend = (startPosition...endPosition).map { position in
            positions.reduce(Int.zero, { $0 + fuelCost(for: abs($1 - position)) })
        }

        return fuelSpend.min() ?? .zero
    }

    func fuelCost(for numberOfMoves: Int) -> Int {
        numberOfMoves * (numberOfMoves + 1) / 2
    }
}
