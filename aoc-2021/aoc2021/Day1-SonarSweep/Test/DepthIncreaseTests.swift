@testable import AOCFramework

import Foundation
import XCTest

class DepthIncreaseTests: XCTestCase {
    func testDepthIncreaseCount() throws {
        print(Bundle(for: type(of: self)))

        // given
        let depthIncrease = DepthIncrease(measurementsFile: .testDepthMeasurements)
//
        // when
        let totalCount = depthIncrease.depthIncreaseCount()

        // then
        let expectedCount = 7
        XCTAssertEqual(totalCount, expectedCount)
    }

//    func testPerformanceDepthIncreaseCount() throws {
//        let depthIncrease = DepthIncrease(measurementsFile: .testDepthMeasurements)
//        self.measure {
//            _ = depthIncrease.depthIncreaseCount()
//        }
//    }
}
