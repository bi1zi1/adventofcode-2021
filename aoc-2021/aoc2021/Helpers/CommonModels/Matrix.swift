import Foundation

class Matrix2D<Element> {
    private(set) var mx: [[Element]]

    var rowCount: Int {
        mx.count
    }

    var columnCount: Int {
        mx.first?.count ?? .zero
    }

    init(mx: [[Element]]) {
        Self.validate(mx: mx)

        self.mx = mx
    }

    private static func validate(mx: [[Element]]) {
        mx.enumerated().forEach { enItem in
            let prevOffset = enItem.offset - 1
            guard prevOffset >= .zero else {
                return
            }

            assert(mx[prevOffset].count == enItem.element.count)
        }
    }

    subscript(_ point: Point) -> Element {
        mx[point.x][point.y]
    }

    func safeGetElement(at point: Point) -> Element? {
        guard
            point.x >= .zero,
            point.y >= .zero,
            point.x < rowCount,
            point.y < columnCount
        else {
            return nil
        }

        return mx[point.x][point.y]
    }
}
