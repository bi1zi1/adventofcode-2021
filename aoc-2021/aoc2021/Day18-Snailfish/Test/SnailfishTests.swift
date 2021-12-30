@testable import AOCFramework

import Foundation
import XCTest

class SnailfishTests: XCTestCase {
    func testFinalSumMagnitude() throws {
        // given
        let snailfish = Snailfish(measurementsFile: .testSnailfishNumberData)

        // when
        let finalSumMagnitude = snailfish.finalSumMagnitude()

        // then
        let expectedFinalSumMagnitude = 4140
        XCTAssertEqual(finalSumMagnitude, expectedFinalSumMagnitude)
    }

    func testPerformanceExample() throws {
        let snailfish = Snailfish(measurementsFile: .testSnailfishNumberData)
        self.measure {
            _ = snailfish.finalSumMagnitude()
        }
    }
}
