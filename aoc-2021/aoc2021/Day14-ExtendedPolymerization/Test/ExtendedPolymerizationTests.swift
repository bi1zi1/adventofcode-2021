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

    func testQuantityDiff40steps() throws {
        // given
        let extendedPolymerization = ExtendedPolymerization(measurementsFile: .testPolymerData)

        // when
        let quantityDiff40stepsV2 = extendedPolymerization.quantityDiff40stepsV2()

        // then
        let expectedQuantityDiff40steps = 2188189693529
        XCTAssertEqual(quantityDiff40stepsV2, expectedQuantityDiff40steps)
    }

    func testPerformanceExample() throws {
        let extendedPolymerization = ExtendedPolymerization(measurementsFile: .testPolymerData)
        self.measure {
            _ = extendedPolymerization.quantityDiff10steps()
        }
    }

}
