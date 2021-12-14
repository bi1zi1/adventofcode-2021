import Foundation

struct Fold {
    enum Axis: String {
        case x
        case y
    }

    let axis: Axis
    let value: Int
}

extension Fold {
    init?(string: String) {
        let items = string.components(separatedBy: "=")
        
        guard
            let first = items.first,
            let second = items.last,
            let axis = Axis(rawValue: first),
            let value = Int(second)
        else {
            return nil
        }

        self.axis = axis
        self.value = value
    }
}

class Paper {
    private(set) var mx: [[Bool]]
    private(set) var minX: Int
    private(set) var maxX: Int
    private(set) var minY: Int
    private(set) var maxY: Int

    private var countX: Int {
        maxX - minX + 1
    }

    private var countY: Int {
        maxY - minY + 1
    }

    var dotsCount: Int {
        (0..<countX).reduce(.zero) { partial, x in
            partial + (0..<countY).reduce(.zero) { $0 + (mx[$1][x] ? 1 : 0) }
        }
//        mx.reduce(.zero) { partialResult, line in
//            partialResult + line.reduce(.zero, { $0 + ($1 ? 1 : 0) })
//        }
    }

    init(points: [Point]) {
        (minX, maxX, minY, maxY) = points
            .reduce(into: (Int.max, Int.min, Int.max, Int.min)) { partialResult, point in
                partialResult.0 = min(partialResult.0, point.x)
                partialResult.1 = max(partialResult.1, point.x)
                partialResult.2 = min(partialResult.2, point.y)
                partialResult.3 = max(partialResult.3, point.y)
            }

        let countX = maxX - minX + 1
        let countY = maxY - minY + 1

        mx = Array(
            repeating: Array(repeating: false, count: countX),
            count: countY
        )

        points.forEach { point in
            mx[point.y - minY][point.x - minX] = true
        }
    }

    func fold(_ fold: Fold) {
        clearFoldLine(fold)
        switch fold.axis {
        case .x:
            foldX(fold.value)
        case .y:
            foldY(fold.value)
        }
    }

    private func foldX(_ x: Int) {
        var prevX = x - minX - 1
        var nextX = x - minX + 1

        while prevX >= .zero, nextX < countX {
            (0..<countY).forEach { y in
                let newValue = mx[y][prevX] || mx[y][nextX]
                mx[y][prevX] = newValue
                mx[y][nextX] = newValue
            }

            prevX = prevX - 1
            nextX = nextX + 1
        }

        if (maxX - x) >= (x - minX) {
            minX = x + 1
        } else {
            maxX = x - 1
        }
    }

    private func foldY(_ y: Int) {
        var prevY = y - minY - 1
        var nextY = y - minY + 1

        while prevY >= .zero, nextY < countY {
            (0..<countX).forEach { x in
                let newValue = mx[prevY][x] || mx[nextY][x]
                mx[prevY][x] = newValue
                mx[nextY][x] = newValue
            }

            prevY = prevY - 1
            nextY = nextY + 1
        }

        if (maxY - y) >= (y - minY) {
            minY = y + 1
        } else {
            maxY = y - 1
        }
    }

    private func clearFoldLine(_ fold: Fold) {
        switch fold.axis {
        case .x:
            (0..<countY).forEach { y in
                mx[y][fold.value] = false
            }
        case .y:
            (0..<countX).forEach { x in
                mx[fold.value][x] = false
            }
        }
    }
}

extension Paper {

}
