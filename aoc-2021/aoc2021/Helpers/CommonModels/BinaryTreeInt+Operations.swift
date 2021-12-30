import Foundation

extension BinaryTreeInt {
    func reSyncLevels(with level: Int) {
        switch node {
        case .value:
            self.level = level
        case .path(let left, let right):
            left.reSyncLevels(with: level + 1)
            right.reSyncLevels(with: level + 1)
        }
    }

    func findErroneousValues() -> BinaryTreeInt? {
        switch node {
        case .value(let intVal):
            if intVal > 9 { return self }
            else { return nil }
        case .path(let left, let right):
            if let found = left.findErroneousValues() {
                return found
            }
            return right.findErroneousValues()
        }
    }

    func findErroneousLevels() -> BinaryTreeInt? {
        switch node {
        case .value:
            if level > 4 { return self.parent }
            else { return nil }
        case .path(let left, let right):
            if let found = left.findErroneousLevels() {
                return found
            }
            return right.findErroneousLevels()
        }
    }
}

extension BinaryTreeInt {
    var nodes: (BinaryTreeInt, BinaryTreeInt)? {
        switch node {
        case .value:
            return nil
        case .path(let left, let right):
            return (left, right)
        }
    }

    var value: Int? {
        switch node {
        case .value(let intVal):
            return intVal
        case .path:
            return nil
        }
    }

    func leftNeighbour() -> BinaryTreeInt? {
        guard
            var firstParent = parent,
            var secondParent = firstParent.parent
        else {
            return nil
        }

        while secondParent.nodes!.0 == firstParent {
            if secondParent.parent == nil {
                return nil
            }

            firstParent = secondParent
            secondParent = secondParent.parent!
        }

        switch secondParent.node {
        case .value:
            assertionFailure()
            return secondParent
        case .path(var leftNode, _):
           while !leftNode.isLeaf {
                leftNode = leftNode.nodes!.1
            }
            return leftNode
        }
    }

    func rightNeighbour() -> BinaryTreeInt? {
        guard
            var firstParent = parent,
            var secondParent = firstParent.parent
        else {
            return nil
        }

        while secondParent.nodes!.1 == firstParent {
            if secondParent.parent == nil {
                return nil
            }

            firstParent = secondParent
            secondParent = secondParent.parent!
        }

        switch secondParent.node {
        case .value:
            assertionFailure()
            return secondParent
        case .path(_, var rightNode):
           while !rightNode.isLeaf {
               rightNode = rightNode.nodes!.0
            }
            return rightNode
        }
    }

    func explode() {
        assert(!isLeaf)
        assert(parent != nil)

        let (left, right) = nodes!
        assert(left.isLeaf)
        assert(right.isLeaf)
        assert(left.level > 4)
        assert(right.level > 4)

        let leftVal = left.value!
        let rightVal = right.value!

        let leftNeighbour = left.leftNeighbour()
        let rightNeighbour = right.rightNeighbour()

        let newValueLeft = leftVal + (leftNeighbour?.value ?? .zero)
        let newValueRight = rightVal + (rightNeighbour?.value ?? .zero)

        leftNeighbour?.node = .value(newValueLeft)
        rightNeighbour?.node = .value(newValueRight)
        node = .value(0)
    }

    func split() {
        assert(isLeaf)
        assert(parent != nil)

        guard let value = value else {
            assertionFailure()
            return
        }

        let firstValue = value / 2
        let secondValue = value - firstValue

        let leftNode = BinaryTreeInt(
            node: .value(firstValue),
            level: level + 1,
            parent: self,
            designation: "L")

        let rightNode = BinaryTreeInt(
            node: .value(secondValue),
            level: level + 1,
            parent: self,
            designation: "R")

        node = .path(leftNode, rightNode)
    }
}

extension BinaryTreeInt {
    func magnitudeValue() -> Int {
        switch node {
        case .value(let intVal):
            return intVal
        case .path(let left, let right):
            return 3 * left.magnitudeValue() + 2 * right.magnitudeValue()
        }
    }
}
