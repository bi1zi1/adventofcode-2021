import Foundation

class EnergyItem {
    private(set) var value: Int
    private let point: Point
    var affectedCoordinates: [Point] {
        preAffectedCoordinates + postAffectedCoordinates
    }
    let preAffectedCoordinates: [Point]
    let postAffectedCoordinates: [Point]

    required init(value: Int, point: Point, maxX: Int, maxY: Int) {
        self.value = value
        self.point = point

        preAffectedCoordinates = [
            Point(x: point.x - 1, y: point.y - 1),
            Point(x: point.x - 1, y: point.y),
            Point(x: point.x - 1, y: point.y + 1),
            Point(x: point.x, y: point.y - 1),
        ].filter { $0.x >= .zero && $0.x < maxX && $0.y >= .zero && $0.y < maxY }

        postAffectedCoordinates = [
            Point(x: point.x + 1, y: point.y + 1),
            Point(x: point.x + 1, y: point.y),
            Point(x: point.x + 1, y: point.y - 1),
            Point(x: point.x, y: point.y + 1),
        ].filter { $0.x >= .zero && $0.x < maxX && $0.y >= .zero && $0.y < maxY }
    }

    static var empty: Self {
        .init(
            value: .zero,
            point: Point(x: .zero, y: .zero),
            maxX: .zero,
            maxY: .zero
        )
    }

    func increaseValue() {
        value += 1
    }

    func resetValue() {
        value = .zero
    }
}

class EnergyLevels {
    static let rowLength = 10
    static let columnLength = 10
    private(set) var energyFormation = Array(
        repeating: Array(repeating: EnergyItem.empty, count: EnergyLevels.rowLength),
        count: EnergyLevels.columnLength
    )

    init(lines: [String]) {
        assert(lines.count == Self.columnLength)

        lines.enumerated().forEach { lineItem in
            assert(lineItem.element.count == Self.rowLength)
            let rowIndex = lineItem.offset

            lineItem.element.enumerated().forEach { item in
                let columnIndex = item.offset
                let value = Int(String(item.element))
                let point = Point(x: rowIndex, y: columnIndex)

                assert(value != nil)
                energyFormation[rowIndex][columnIndex] = EnergyItem(
                    value: value ?? .zero,
                    point: point,
                    maxX: Self.rowLength,
                    maxY: Self.columnLength
                )
            }
        }
    }
}
