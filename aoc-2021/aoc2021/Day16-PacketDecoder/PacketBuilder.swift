import Foundation

class PacketBuilder {
    let uuid: String
    var version: Int?
    var type: PacketHeader.TypeId?
    var literalSegments: [Int] = []
    var lengthInBits: Int?
    var numberOfSubPackets: Int?
    var mode: OperatorData.Mode?
    var packetBuilders: [PacketBuilder] = []

    init(uuid: String, version: Int? = nil, type: PacketHeader.TypeId? = nil, literalSegments: [Int] = [], lengthInBits: Int? = nil, numberOfSubPackets: Int? = nil, mode: OperatorData.Mode? = nil, packetBuilders: [PacketBuilder] = []) {
        
        self.uuid = uuid
        self.version = version
        self.type = type
        self.literalSegments = literalSegments
        self.lengthInBits = lengthInBits
        self.numberOfSubPackets = numberOfSubPackets
        self.mode = mode
        self.packetBuilders = packetBuilders
    }
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
                    type: type!,
                    mode: OperatorData.Mode.lengthInBits(lengthInBits)
                ))
        }

        if let numberOfSubPackets = numberOfSubPackets {
            return .operators(
                OperatorData(
                    type: type!,
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
