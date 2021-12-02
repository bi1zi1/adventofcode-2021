@testable import AOCFramework

import Foundation
import XCTest

class DiveNavigationTests: XCTestCase {
    func testPositionAndDepth() throws {
        // given
        let diveNavigation = DiveNavigation(measurementsFile: .testNavigationData)

        // when
        let (position, depth) = diveNavigation.positionAndDepth()

        // then
        let expectedPosition = 15
        XCTAssertEqual(position, expectedPosition)
        let expectedDepth = 10
        XCTAssertEqual(depth, expectedDepth)
    }

    func testPositionAndDepthWithAim() throws {
        // given
        let diveNavigation = DiveNavigation(measurementsFile: .testNavigationData)

        // when
        let (position, depth) = diveNavigation.positionAndDepthWithAim()

        // then
        let expectedPosition = 15
        XCTAssertEqual(position, expectedPosition)
        let expectedDepth = 60
        XCTAssertEqual(depth, expectedDepth)
    }

    func testPerformanceExample() throws {
        let diveNavigation = DiveNavigation(measurementsFile: .testNavigationData)
        self.measure {
            _ = diveNavigation.positionAndDepth()
        }
    }
}
