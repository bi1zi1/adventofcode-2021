import Foundation

public final class PacketDecoder {
    private let fileReader: FileReader
    public init(measurementsFile: FileResource = .hexPacketData) {
        fileReader = FileReader(fileResource: measurementsFile)
    }

    public func versionSummary() -> [Int] {
        guard let data = try? fileReader.lines().filter({ !$0.isEmpty }) else {
            assertionFailure("data missing")
            return []
        }

        return data.reduce(into: []) { result, line in
            let stateMachine = PacketDecoderStateMachine(
                binaryBuffer: BinaryBuffer(data: line)
            )
            stateMachine.run()

            result.append(
                stateMachine.packetBuilder.build()?.versionSum() ?? -1
            )
        }
    }

    public func packetValue() -> [Int] {
        guard let data = try? fileReader.lines().filter({ !$0.isEmpty }) else {
            assertionFailure("data missing")
            return []
        }

        return data.reduce(into: []) { result, line in
            let stateMachine = PacketDecoderStateMachine(
                binaryBuffer: BinaryBuffer(data: line)
            )
            stateMachine.run()

//            if let packet = stateMachine.packetBuilder.build() {
//                packet.display()
//            }

            result.append(
                stateMachine.packetBuilder.build()?.value() ?? -1
            )
        }
    }
}

extension Packet {
    func display(_ indent: String = "\t") {
        print(indent, terminator: "")
        packetHeader.type.display()
        payload.display()
        print("\n", terminator: "")
        packets.forEach { $0.display(indent + "\t") }
    }
}

extension PacketHeader.TypeId {
    func display() {
        switch self {
        case .literalValue:
            print(4, "[val]", terminator: "")
        case .operators(let id):
            id.display()
        }
    }
}

extension PacketHeader.OperatorId {
    func display() {
        switch self {
        case .sum:
            print(self.rawValue, "[+]", terminator: "")
        case .product:
            print(self.rawValue, "[*]", terminator: "")
        case .min:
            print(self.rawValue, "[min]", terminator: "")
        case .max:
            print(self.rawValue, "[max]", terminator: "")
        case .greater:
            print(self.rawValue, "[>]", terminator: "")
        case .less:
            print(self.rawValue, "[<]", terminator: "")
        case .equal:
            print(self.rawValue, "[==]", terminator: "")
        }
    }
}

extension Packet.Payload {
    func display() {
        switch self {
        case .literal(let value):
            let lVal = LiteralValueData(
                type: .literalValue,
                segments: value.segments
            )
            print(value.segments, lVal.value, terminator: "")
        case .operators:
            print("[op]", terminator: "")
        }
    }
}
