import Foundation

public final class Snailfish {
    static let digits = [
        "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"
    ]
    private let fileReader: FileReader
    public init(measurementsFile: FileResource = .snailfishNumberData) {
        fileReader = FileReader(fileResource: measurementsFile)
    }

    public func finalSumMagnitude() -> Int {
        guard let data = try? fileReader.lines().filter({ !$0.isEmpty }) else {
            assertionFailure("data missing")
            return .zero
        }

        let numbers: [BinaryTreeInt] = data.map { line in
            var startIndex = line.startIndex
            return parseNumber(
                line: line,
                level: .zero,
                readIndex: &startIndex,
                parsingLeftNode: true
            )
        }

        let sumNumber: BinaryTreeInt? = numbers.reduce(into: nil) { partialResult, number in

            guard let partialResultValue = partialResult else {
                partialResult = number
                return
            }

//            print("=== SUM OF START ===")
//            partialResultValue.displaySnailfishNumber()
//            print("+")
//            number.displaySnailfishNumber()
//            print("")
//            print("=== SUM OF END ===")
            partialResult = normalize(
                number: BinaryTreeInt(
                    node: .path(partialResultValue, number),
                    level: .zero,
                    parent: nil,
                    designation: ""
                )
            )
        }

        sumNumber?.displaySnailfishNumber()
        print("")

        return sumNumber?.magnitudeValue() ?? .zero
    }

    public func largestSumMagnitudeOfTwo() -> Int {
        guard let data = try? fileReader.lines().filter({ !$0.isEmpty }) else {
            assertionFailure("data missing")
            return .zero
        }

        var maxSum = Int.zero
        data.enumerated().forEach { itemLineOne in
            data.enumerated().forEach { itemLineTwo in
                if itemLineOne.offset == itemLineTwo.offset {
                    return
                }

                var itemOneStartIndex = itemLineOne.element.startIndex
                let itemOne = parseNumber(
                    line: itemLineOne.element,
                    level: .zero,
                    readIndex: &itemOneStartIndex,
                    parsingLeftNode: true
                )

                var itemTwoStartIndex = itemLineTwo.element.startIndex
                let itemTwo = parseNumber(
                    line: itemLineTwo.element,
                    level: .zero,
                    readIndex: &itemTwoStartIndex,
                    parsingLeftNode: true
                )

                let sumNumberOneTwo = normalize(
                    number: BinaryTreeInt(
                        node: .path(itemOne, itemTwo),
                        level: .zero,
                        parent: nil,
                        designation: ""
                    )
                )

                maxSum = max(maxSum, sumNumberOneTwo.magnitudeValue())
            }
        }

        return maxSum
    }

    func parseNumbers() -> [BinaryTreeInt] {
        guard let data = try? fileReader.lines().filter({ !$0.isEmpty }) else {
            assertionFailure("data missing")
            return []
        }

        let numbers: [BinaryTreeInt] = data.map { line in
            var startIndex = line.startIndex
            return parseNumber(
                line: line,
                level: .zero,
                readIndex: &startIndex,
                parsingLeftNode: true
            )
        }

        return numbers
    }

    private func normalize(number: BinaryTreeInt) -> BinaryTreeInt {
        print("----------------------------------------")
        number.displaySnailfishNumber()
        let normalizedNumber = number

        normalizedNumber.reSyncLevels(with: .zero)
        var hasErroneousLevels = normalizedNumber.findErroneousLevels()
        var hasErroneousValues = normalizedNumber.findErroneousValues()

        while
            hasErroneousLevels != nil ||
            hasErroneousValues != nil
        {
            if let erroneousLevels = hasErroneousLevels {
                erroneousLevels.explode()
            } else if let erroneousValues = hasErroneousValues {
                erroneousValues.split()
            }

//                print("----------------------------------------")
//                partialResult?.displaySnailfishNumber()
//                print("")
//                print("----------------------------------------")

            normalizedNumber.reSyncLevels(with: .zero)
            hasErroneousLevels = normalizedNumber.findErroneousLevels()
            hasErroneousValues = normalizedNumber.findErroneousValues()
        }

        print("")
        normalizedNumber.displaySnailfishNumber()
        print(" | magnitude: \(normalizedNumber.magnitudeValue())")
        print("----------------------------------------")

        return normalizedNumber
    }

    func parseNumber(
        line: String,
        level: Int,
        readIndex: inout String.Index,
        parsingLeftNode: Bool
    ) -> BinaryTreeInt {
        let nextReadIndex = line.index(after: readIndex)
        let currentChar = String(line[readIndex])
        assert(currentChar.count == 1)

        if Self.digits.contains(currentChar) {
            let nextChar = String(
                line[nextReadIndex]
            )

            let endIndex: String.Index
            if Self.digits.contains(nextChar) {
                endIndex = line.index(after: nextReadIndex)
            } else {
                endIndex = nextReadIndex
            }

            let intValString = String(
                line[readIndex..<endIndex]
            )
            let intVal = Int(intValString)!
            readIndex = endIndex

            return BinaryTreeInt(
                node: .value(intVal),
                level: level,
                parent: nil, // for now
                designation: parsingLeftNode ? "L" : "R"
            )
        }

        var leftNode: BinaryTreeInt?
        var rightNode: BinaryTreeInt?
        var parsingNumberDone = false

        while !parsingNumberDone {
            let firstChar = line[readIndex]

            switch String(firstChar) {
            case "[":
                readIndex = line.index(after: readIndex)
                leftNode = parseNumber(
                    line: line,
                    level: level + 1,
                    readIndex: &readIndex,
                    parsingLeftNode: true
                )
                break
            case "]":
                readIndex = line.index(after: readIndex)
                parsingNumberDone = true
                break
            case ",":
                readIndex = line.index(after: readIndex)
                rightNode = parseNumber(
                    line: line,
                    level: level + 1,
                    readIndex: &readIndex,
                    parsingLeftNode: false
                )
                break
            case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
                assertionFailure()
                break
            default:
                assertionFailure()
                break
            }
        }

        let returnNode = BinaryTreeInt(
            node: .path(leftNode!, rightNode!),
            level: level,
            parent: nil,
            designation: parsingLeftNode ? "L" : "R"
        )
        leftNode?.parent = returnNode
        rightNode?.parent = returnNode

        return returnNode
    }
}
