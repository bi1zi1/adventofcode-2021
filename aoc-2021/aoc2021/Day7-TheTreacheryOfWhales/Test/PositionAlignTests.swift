@testable import AOCFramework

import Foundation
import XCTest

class PositionAlignTests: XCTestCase {
    func testMinFuel() throws {
        // given
        let positionAlign = PositionAlign(measurementsFile: .testHorizontalPositionData)

        // when
        let minFuel = positionAlign.minFuel()

        // then
        let expectedMinFuel = 37
        XCTAssertEqual(minFuel, expectedMinFuel)
    }

    func testPerformanceExample() throws {
        let positionAlign = PositionAlign(measurementsFile: .testHorizontalPositionData)
        self.measure {
            _ = positionAlign.minFuel()
        }
    }

}
