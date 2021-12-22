import Foundation

class PacketBuilder {
    var version: Int?
    var type: PacketHeader.TypeId?
    var literalSegments: [Int] = []
    var lengthInBits: Int?
    var numberOfSubPackets: Int?
    var mode: OperatorData.Mode?
    var packetBuilders: [PacketBuilder] = []
}

extension PacketBuilder {
    func build() -> Packet? {
        guard let version = version, let type = type else {
            assertionFailure()
            return nil
        }

        let packetHeader = PacketHeader(
            version: version,
            type: type
        )

        guard let payload = buildPayload() else {
            assertionFailure()
            return nil
        }

        let packets = buildSubPackets()

        let packet = Packet(
            packetHeader: packetHeader,
            payload: payload,
            packets: packets
        )

        return packet
    }

    private func buildPayload() -> Packet.Payload? {
        if !literalSegments.isEmpty {
            return .literal(
                LiteralValueData(
                    type: .literalValue,
                    segments: literalSegments
                ))
        }

        if let lengthInBits = lengthInBits {
            return .operators(
                OperatorData(
                    type: .operators(lengthInBits),
                    mode: OperatorData.Mode.lengthInBits(lengthInBits)
                ))
        }

        if let numberOfSubPackets = numberOfSubPackets {
            return .operators(
                OperatorData(
                    type: .operators(numberOfSubPackets),
                    mode: .numberOfSubPackets(numberOfSubPackets)
                ))
        }

        assertionFailure()
        return nil
    }

    private func buildSubPackets() -> [Packet] {
        packetBuilders.compactMap { $0.build() }
    }
}
