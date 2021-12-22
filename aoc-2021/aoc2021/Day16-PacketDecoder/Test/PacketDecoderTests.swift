@testable import AOCFramework

import Foundation
import XCTest

class PacketDecoderTests: XCTestCase {
    func testVersionSummary() throws {
        // given
        let packetDecoder = PacketDecoder(measurementsFile: .testHexPacketData)

        // when
        let versionSummary = packetDecoder.versionSummary()

        // then
        let expectedVersionSummary = [16, 12, 23, 31]
        XCTAssertEqual(versionSummary, expectedVersionSummary)
    }

    func testPerformanceExample() throws {
        let packetDecoder = PacketDecoder(measurementsFile: .testHexPacketData)
        self.measure {
            _ = packetDecoder.versionSummary()
        }
    }

}
