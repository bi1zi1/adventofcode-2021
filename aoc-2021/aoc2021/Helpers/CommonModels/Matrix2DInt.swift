import Foundation

typealias Matrix2DInt = Matrix2D<Int>

extension Matrix2DInt {
    convenience init(data: [String]) {
        let mx = data
            .filter { !$0.isEmpty }
            .map { $0.compactMap(Int.init) }
        self.init(mx: mx)
    }
}

extension Int {
    init?(_ value: Character) {
        self.init(String(value))
    }
}
