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
                stateMachine.packetBuilder.build()?.versionSum() ?? .zero
            )
        }
    }
}
