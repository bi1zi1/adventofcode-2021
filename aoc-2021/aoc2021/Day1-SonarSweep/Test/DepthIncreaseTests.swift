@testable import AOCFramework

import Foundation
import XCTest

class DepthIncreaseTests: XCTestCase {
    func testDepthIncreaseCount() throws {
        // given
        let depthIncrease = DepthIncrease(measurementsFile: .testDepthMeasurements)

        // when
        let totalCount = depthIncrease.depthIncreaseCount()

        // then
        let expectedCount = 7
        XCTAssertEqual(totalCount, expectedCount)
    }

    func testDepthIncreaseCount_SlidingWindow3() throws {
        // given
        let depthIncrease = DepthIncrease(measurementsFile: .testDepthMeasurements)

        // when
        let totalCount = depthIncrease.depthIncreaseCount(with: 3)

        // then
        let expectedCount = 5
        XCTAssertEqual(totalCount, expectedCount)
    }

    func testPerformanceDepthIncreaseCount() throws {
        let depthIncrease = DepthIncrease(measurementsFile: .testDepthMeasurements)
        self.measure {
            _ = depthIncrease.depthIncreaseCount()
        }
    }
}
