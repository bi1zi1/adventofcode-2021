import Foundation

/*
 [3] - version
 [3] - type
 ===
 [5] on a loop (ignore any trailing '0's after reading is done)
 Literal - no fixed length / count
 Read [5] and continue until leading bit is '1'. If '0', then it's the last part.
 ===
 Operator
 [1]
    - if '0' then read next 15 bits for length
    - if '1' then read next 11 bits for package count
 [15 / 11]
 */

struct PacketHeader {
    enum TypeId {
        case literalValue // 0b100 / 4
        case operators(OperatorId) // This stands for any other value, like a `default`
    }

    enum OperatorId: Int {
        case sum = 0
        case product = 1
        case min = 2
        case max = 3
        // 4 is literal
        case greater = 5
        case less = 6
        case equal = 7
    }

    let version: Int // 3 bits
    let type: TypeId // 3 bits
}

struct LiteralValueData {
    let type: PacketHeader.TypeId // 3 bits (can only be literalValue)
    let segments: [Int] // 5 bits - 1bit info + 4bits payload
}

struct OperatorData {
    enum Mode {
        case lengthInBits(Int) // 1 bit - value '0' (read next 15 bits)
        case numberOfSubPackets(Int) // 1 bit - value '1' (read next 11 bits)
    }

    let type: PacketHeader.TypeId // 3 bits (cannot be literalValue)
    let mode: Mode // 1 + 15 (for length) or 1 + 11 (for sub-packets)
}

struct Packet {
    enum Payload {
        case literal(LiteralValueData)
        case operators(OperatorData)
    }

    let packetHeader: PacketHeader
    let payload: Payload
    private(set) var packets: [Packet] = []
}

extension Packet {
    func versionSum() -> Int {
        packets.reduce(
            packetHeader.version,
            { $0 + $1.versionSum() }
        )
    }
}

extension LiteralValueData {
    var value: Int {
        return segments.reduce(.zero) {
            $0 * 0b10000 + $1
        }
    }
}

extension Packet {
    func value() -> Int {
        switch payload {
        case .literal(let literalValueData):
            return literalValueData.value
        case .operators(let operatorData):
            guard let operation = operatorData.operation() else {
                assertionFailure()
                return -1
            }

//            operatorData.type.display()
            let values = packets.map { $0.value() }

//            operatorData.type.display()

            let calculatedValue =  callWithVariadic(items: values, method: operation)
            return calculatedValue
        }
    }
}

extension OperatorData {
    func operation() -> ((Int ...) -> Int)? {
        guard case .operators(let operatorId) = type else {
            return nil
        }

        switch operatorId {
        case .sum:
            return sum(items:)
        case .product:
            return product(items:)
        case .min:
            return min(items:)
        case .max:
            return max(items:)
        case .greater:
            return greater(items:)
        case .less:
            return less(items:)
        case .equal:
            return equal(items:)
        }
    }

    func sum(items: Int ...) -> Int {
        items.reduce(.zero, +)
    }

    func product(items: Int ...) -> Int {
        items.reduce(1, *)
    }

    func min(items: Int ...) -> Int {
        return items.reduce(.max, Swift.min)
    }

    func max(items: Int ...) -> Int {
        return items.reduce(.min, Swift.max)
    }

    func greater(items: Int ...) -> Int {
        assert(items.count == 2)
        return items.first! > items.last! ? 1 : 0
    }

    func less(items: Int ...) -> Int {
        assert(items.count == 2)
        return items.first! < items.last! ? 1 : 0
    }

    func equal(items: Int ...) -> Int {
        assert(items.count == 2)
        return items.first! == items.last! ? 1 : 0
    }
}
