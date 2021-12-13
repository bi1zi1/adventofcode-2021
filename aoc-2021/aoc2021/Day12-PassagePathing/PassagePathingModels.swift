import Foundation

class Cave {
    enum Size: Equatable, Hashable {
        case small
        case big
    }

    let name: String
    let size: Size
    private(set) var caves: [Cave]

    init(name: String) {
        self.name = name
        self.size = name.first?.isUppercase == true ? .big : .small
        self.caves = []
    }

    func assignCaves(caves: [Cave]) {
        self.caves = caves
    }
}

extension Cave: Equatable {
    static func == (lhs: Cave, rhs: Cave) -> Bool {
        lhs.name == rhs.name
    }
}

extension Cave: CustomDebugStringConvertible {
//    var debugDescription: String {
//        "[CAVE]-[\(name)]-[\(caves.map({$0.name}))]"
//    }

    var debugDescription: String {
        "|\(name)|"
    }
}

extension Cave: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
