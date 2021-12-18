import Foundation

struct Point: Hashable {
    let x: Int
    let y: Int
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

    init(point: (Int, Int)) {
        x = point.0
        y = point.1
    }
}

extension Point {
    func pathDistance(to point: Point) -> Int {
        abs(x - point.x) + abs(y - point.y)
    }
}
