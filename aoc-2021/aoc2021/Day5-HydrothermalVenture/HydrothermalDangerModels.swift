import Foundation

struct Point: Hashable {
    let x: Int
    let y: Int
}

struct VentLine {
    let startPoint: Point
    let endPoint: Point
}

extension VentLine {
    var isVertical: Bool {
        startPoint.x == endPoint.x
    }

    var isHorizontal: Bool {
        startPoint.y == endPoint.y
    }

    var lineItems: [Point] {
        if isVertical {
            let x = startPoint.x
            let rangeStart = min(startPoint.y, endPoint.y)
            let rangeEnd = max(startPoint.y, endPoint.y)
            return (rangeStart...rangeEnd).map { Point(x: x, y: $0) }
        }

        if isHorizontal {
            let y = startPoint.y
            let rangeStart = min(startPoint.x, endPoint.x)
            let rangeEnd = max(startPoint.x, endPoint.x)
            return (rangeStart...rangeEnd).map { Point(x: $0, y: y) }
        }

        return []
    }
}

extension VentLine {
    init?(string: String) {
        guard !string.isEmpty else { return nil }

        let items = string
            .components(separatedBy: CharacterSet.whitespaces)
            .compactMap({ String($0) })

        assert(items.count == 3)

        guard
            let startPointString = items.first,
            let endPointString = items.last,
            let startPoint = Point(string: startPointString),
            let endPoint = Point(string: endPointString)
        else {
            return nil
        }

        self.init(startPoint: startPoint, endPoint: endPoint)
    }
}

extension Point {
    init?(string: String) {
        let coordinates = string
            .components(separatedBy: ",")
            .compactMap({ Int($0) })

        assert(coordinates.count == 2)

        guard
            let x = coordinates.first,
            let y = coordinates.last
        else {
            return nil
        }

        self.init(x: x, y: y)
    }
}
