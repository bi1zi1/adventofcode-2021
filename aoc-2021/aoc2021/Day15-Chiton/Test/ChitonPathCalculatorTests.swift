@testable import AOCFramework

import Foundation
import XCTest

class ChitonPathCalculatorTests: XCTestCase {
    func testLowestRiskPath() throws {
        // given
        let chitonPathCalculator = ChitonPathCalculator(measurementsFile: .testChitonRiskLevelData)

        // when
        let lowestRiskPath = chitonPathCalculator.lowestRiskPath()

        // then
        let expectedLowestRiskPath = 40
        XCTAssertEqual(lowestRiskPath, expectedLowestRiskPath)
    }

    func testPerformanceExample() throws {
        let chitonPathCalculator = ChitonPathCalculator(measurementsFile: .testChitonRiskLevelData)
        self.measure {
            _ = chitonPathCalculator.lowestRiskPath()
        }
    }

}
