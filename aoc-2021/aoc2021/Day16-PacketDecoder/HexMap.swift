import Foundation

enum HexMap: Character {
    case h0 = "0"
    case h1 = "1"
    case h2 = "2"
    case h3 = "3"
    case h4 = "4"
    case h5 = "5"
    case h6 = "6"
    case h7 = "7"
    case h8 = "8"
    case h9 = "9"
    case hA = "A"
    case hB = "B"
    case hC = "C"
    case hD = "D"
    case hE = "E"
    case hF = "F"
}

extension HexMap {
    var intValue: Int {
        Int(String(self.rawValue), radix: 16)!
    }

    var binaryString: String {
        let valueString = String(intValue, radix: 2)
        let prependZeroes = String(repeating: "0", count: 4 - valueString.count)
        return prependZeroes + valueString
    }
}

extension Character {
    var binaryString: String? {
        HexMap(rawValue: self)?.binaryString
    }
}

class BinaryBuffer {
    let data: String
    private lazy var iterator = data.makeIterator()
    private(set) var binaryBuffer: [Character] = []

    init(data: String) {
        self.data = data
        _ = peek(1)
    }

    func hasData() -> Bool {
        !binaryBuffer.isEmpty
    }

    func clearLastRemainingCharBits() -> Int {
        let bitsToRemoveCount = binaryBuffer.count % 4

        if bitsToRemoveCount > .zero {
            binaryBuffer.removeFirst(bitsToRemoveCount)
        }

        return bitsToRemoveCount
    }

    func read(_ noOfBits: Int) -> Int? {
        read(noOfBits, clearRead: true)
    }

    func peek(_ noOfBits: Int) -> Int? {
        read(noOfBits, clearRead: false)
    }

    private func read(_ noOfBits: Int, clearRead: Bool) -> Int? {
        while binaryBuffer.count < noOfBits {
            readNext(failOnEmpty: true)
        }

        let bitsString = String(binaryBuffer[0..<noOfBits])
        if clearRead { binaryBuffer.removeFirst(noOfBits) }
        readNext()

        return Int(bitsString, radix: 2)
    }

    private func readNext(failOnEmpty: Bool = false) {
        let nextChar = iterator.next()
        guard let binaryString = nextChar?.binaryString else {
            if failOnEmpty { assertionFailure("Not HEX char") }
            return
        }

        binaryBuffer.append(contentsOf: binaryString)
    }
}
