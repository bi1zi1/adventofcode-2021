import Foundation


/// Converts the input matrix into a 5x5 of the original size
class Extended5x5Matrix2DInt {
    private(set) var mx: Matrix2DInt

    var rowCount: Int {
        mx.rowCount * 5
    }

    var columnCount: Int {
        mx.columnCount * 5
    }

    init(mx: Matrix2DInt) {
        self.mx = mx
    }

    subscript(_ x: Int, _ y: Int) -> Int {
        let mxRowCount = mx.rowCount
        let mxColumnCount = mx.columnCount

        let incrementValue =
        x / mxRowCount +
        y / mxColumnCount

        let translatedPoint = Point(
            x: x % mxRowCount,
            y: y % mxColumnCount
        )

        return mx[translatedPoint]
            .incrementedDigit(with: incrementValue)
    }

    subscript(_ point: Point) -> Int {
        self[point.x, point.y]
    }
}

extension Int {
    func incrementedDigit(with value: Int) -> Int {
        (self + value) % 10 + (self + value) / 10
    }
}

extension Extended5x5Matrix2DInt {
    func coordsToPoints() -> [Point] {
        var points: [Point] = []
        (0...rowCount - 1).forEach { x in
            (0...columnCount - 1).forEach { y in
                points.append(Point(x: x, y: y))
            }
        }
        return points
    }
}
