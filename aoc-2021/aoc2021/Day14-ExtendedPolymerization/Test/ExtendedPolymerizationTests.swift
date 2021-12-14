@testable import AOCFramework

import Foundation
import XCTest

class ExtendedPolymerizationTests: XCTestCase {
    func testQuantityDiff10steps() throws {
        // given
        let extendedPolymerization = ExtendedPolymerization(measurementsFile: .testPolymerData)

        // when
        let quantityDiff10steps = extendedPolymerization.quantityDiff10steps()

        // then
        let expectedQuantityDiff10steps = 1588
        XCTAssertEqual(quantityDiff10steps, expectedQuantityDiff10steps)
    }

    func testPerformanceExample() throws {
        let extendedPolymerization = ExtendedPolymerization(measurementsFile: .testPolymerData)
        self.measure {
            _ = extendedPolymerization.quantityDiff10steps()
        }
    }

}
