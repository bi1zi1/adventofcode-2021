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
        case operators(Int) // This stands for any other value, like a `default`
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
