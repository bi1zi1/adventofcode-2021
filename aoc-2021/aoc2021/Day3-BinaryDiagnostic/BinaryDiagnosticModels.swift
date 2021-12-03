import Foundation

enum BinaryDigit: Int {
    case zero = 0
    case one = 1
}

struct BinaryNumber {
    let digits: [Int: BinaryDigit]
}

extension BinaryDigit {
    init?(char: Character) {
        switch char {
        case "0":
            self = .zero
        case "1":
            self = .one
        default:
            assertionFailure("There was a 2!")
            return nil
        }
    }

    var flipped: BinaryDigit {
        switch self {
        case .zero:
            return .one
        case .one:
            return .zero
        }
    }
}

extension BinaryNumber {
    var intValue: Int {
        digits.reduce(.zero) { $0 + Int(pow(2, Double($1.key)) * Double($1.value.rawValue)) }
    }

    var length: Int {
        digits.reduce(into: Int.zero) { partialResult, element in
            partialResult = max(partialResult, element.key)
        }
    }

    var inverse: BinaryNumber {
        var inverseDigits: [Int: BinaryDigit] = [:]
        
        (0...length).forEach { radix in
            inverseDigits[radix] = (digits[radix] ?? .zero).flipped
        }

        return BinaryNumber(digits: inverseDigits)
    }

    init(string: String) {
        digits = string.reversed().enumerated().reduce(into: [:]) { partialResult, element in
            let (key, value) = element
            partialResult[key] = BinaryDigit(char: value)
        }
    }

    init(number: Int) {
        self.init(string: String(number, radix: 2))
    }
}
