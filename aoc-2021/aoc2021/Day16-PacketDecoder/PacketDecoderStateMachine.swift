import Foundation

class PacketDecoderStateMachine {
    indirect enum States {
        case version
        case type
        case literal
        case operatorType
        case operatorLength
        case operatorPackageCount
        case operatorSubPacketsWithLength(Int)
        case operatorSubPacketsWithCount(Int)
        case done
    }

    let level: Int
    let index: Int
    lazy var uuid = "<\(level)-\(index)>"

    let packetBuilder = PacketBuilder()
    private var state: States
    private var binaryBuffer: BinaryBuffer
    private var bitsProcessed: Int = .zero

    private var subStateMachines: [PacketDecoderStateMachine]

    init(state: PacketDecoderStateMachine.States = .version,
         binaryBuffer: BinaryBuffer,
         subStateMachines: [PacketDecoderStateMachine] = [],
         level: Int = .zero,
         index: Int = .zero
    ) {
        self.state = state
        self.binaryBuffer = binaryBuffer
        self.subStateMachines = subStateMachines
        self.level = level
        self.index = index
    }
}

extension PacketDecoderStateMachine {
    @discardableResult
    func run() -> Int {
        mainRun:
        while binaryBuffer.hasData() {
            state = parse(with: state)

            switch state {
            case .done:
                break mainRun
            default:
                break
            }
        }

        return bitsProcessed
    }

    private func parse(with state: States) -> States {
        switch state {
        case .version:
            return parseVersion()
        case .type:
            return parseType()
        case .literal:
            return parseLiteral()
        case .operatorType:
            return parseOperatorType()
        case .operatorLength:
            return parseOperatorLength()
        case .operatorPackageCount:
            return parseOperatorPackageCount()
        case .operatorSubPacketsWithLength(let length):
            return parseOperatorSubPacketsWithLength(length)
        case .operatorSubPacketsWithCount(let count):
            return parseOperatorSubPacketsWithCount(count)
        case .done:
            assertionFailure()
            return .done
        }
    }

    private func parseVersion() -> States {
        bitsProcessed += 3
        packetBuilder.version = binaryBuffer.read(3)!
        return .type
    }

    private func parseType() -> States {
        bitsProcessed += 3
        let typeValue = binaryBuffer.read(3)!

        switch typeValue {
        case 4:
            packetBuilder.type = .literalValue
            return .literal
        default:
            packetBuilder.type = .operators(typeValue)
            return .operatorType
        }
    }

    private func parseOperatorType() -> States {
        bitsProcessed += 1
        let operatorType = binaryBuffer.read(1)!
        switch operatorType {
        case 0:
            return .operatorLength
        default:
            return .operatorPackageCount
        }
    }

    private func parseLiteral() -> States {
        var numberRead = false
        var processedLength = Int.zero
        while !numberRead {
            let endBit = binaryBuffer.read(1)!
            let numberSegment = binaryBuffer.read(4)!
            packetBuilder.literalSegments.append(numberSegment)

            processedLength += 5
            numberRead = endBit == .zero
        }
//        processedLength += binaryBuffer.clearLastRemainingCharBits()

        bitsProcessed += processedLength
        return .done
    }

    private func parseOperatorLength() -> States {
        bitsProcessed += 15
        let length = binaryBuffer.read(15)!
        packetBuilder.lengthInBits = length
        return .operatorSubPacketsWithLength(length)
    }

    private func parseOperatorPackageCount() -> States {
        bitsProcessed += 11
        let count = binaryBuffer.read(11)!
        packetBuilder.numberOfSubPackets = count
        return .operatorSubPacketsWithCount(count)
    }

    private func parseOperatorSubPacketsWithLength(_ length: Int) -> States {
        var processedLength = Int.zero
        while processedLength < length {
            let subStateMachine = PacketDecoderStateMachine(
                binaryBuffer: binaryBuffer,
                level: level + 1,
                index: subStateMachines.count
            )
            subStateMachines.append(subStateMachine)
            packetBuilder.packetBuilders.append(subStateMachine.packetBuilder)
            processedLength += subStateMachine.run()
        }

        assert(length == processedLength)
        bitsProcessed += processedLength
        return .done
    }

    private func parseOperatorSubPacketsWithCount(_ count: Int) -> States {
        var processedLength = Int.zero
        (0..<count).forEach { _ in
            let subStateMachine = PacketDecoderStateMachine(
                binaryBuffer: binaryBuffer
            )
            subStateMachines.append(subStateMachine)
            packetBuilder.packetBuilders.append(subStateMachine.packetBuilder)
            processedLength += subStateMachine.run()
        }

        bitsProcessed += processedLength
        return .done
    }
}
