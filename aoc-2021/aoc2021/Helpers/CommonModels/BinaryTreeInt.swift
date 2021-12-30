import Foundation

class BinaryTreeInt {
    enum Node: Equatable, Hashable {
        case value(Int)
        case path(_ left: BinaryTreeInt, _ right: BinaryTreeInt)
    }

    var node: Node
    var level: Int
    var parent: BinaryTreeInt?
    var designation: String

    var isHead: Bool {
        parent == nil
    }

    var isLeaf: Bool {
        switch node {
        case .value:
            return true
        case .path:
            return false
        }
    }

    init(
        node: Node,
        level: Int,
        parent: BinaryTreeInt?,
        designation: String
    ) {
        self.node = node
        self.level = level
        self.parent = parent
        self.designation = designation

        nodes?.0.parent = self
        nodes?.0.designation = "L"
        nodes?.1.parent = self
        nodes?.1.designation = "R"
    }
}

extension BinaryTreeInt: Equatable {
    static func == (lhs: BinaryTreeInt, rhs: BinaryTreeInt) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
}

extension BinaryTreeInt: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self).hashValue)
    }
}

extension BinaryTreeInt.Node {
    func display() {
        switch self {
        case .value(let intVal):
            print("<\(intVal)>", terminator: "")
        case .path(let left, let right):
            print("<path>", terminator: "")
            left.display()
            right.display()
        }
    }
}

extension BinaryTreeInt {
    func display() {
        print("==================")
        print(level, "-", designation, ":", terminator: "")
        node.display()
        print("==================")
    }

    func displaySnailfishNumber() {
        switch node {
        case .value(let intVal):
            print(intVal, terminator: "")
        case .path(let left, let right):
            print("[", terminator: "")
            left.displaySnailfishNumber()
            print(",", terminator: "")
            right.displaySnailfishNumber()
            print("]", terminator: "")
        }
    }
}
