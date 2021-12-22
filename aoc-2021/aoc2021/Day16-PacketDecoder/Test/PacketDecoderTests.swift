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

    func testPacketValue() throws {
        // given
        let packetDecoder = PacketDecoder(measurementsFile: .testHexPacketValueData)

        // when
        let packetValue = packetDecoder.packetValue()

        // then
        let expectedPacketValue = [3, 54, 7, 9, 1, 0, 0, 1]
        XCTAssertEqual(packetValue, expectedPacketValue)
    }

    func testPerformanceExample() throws {
        let packetDecoder = PacketDecoder(measurementsFile: .testHexPacketData)
        self.measure {
            _ = packetDecoder.versionSummary()
        }
    }

    func testVariadicMapper() {
        let ints = [
            32621, 0, 59459, 0, 111, 8, 1970, 10, 12, 0, 0, 0, 62178, 0, 0, 5, 727534, 392231, 27989, 324648, 0, 148, 0,
            153771750, 92, 798147744, 9, 36058, 147, 699027234825, 39180112029, 31535, 46292006, 2152,
            938, 1633473, 8640, 4326, 86207391, 4, 8511595, 951, 255150, 43288, 0, 0, 0 ,14, 434, 0, 0, 3, 190
        ]

//        let ints = [
//            153771750, 92, 798147744, 9, 36058, 147, 699027234825, 39180112029
//        ]

        let value = callWithVariadic(items: ints, method: sum(items:))

        XCTAssertEqual(value, 739303923668)
    }

    func sum(items: Int ...) -> Int {
        items.reduce(.zero, +)
    }

}
