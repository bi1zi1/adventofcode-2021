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

    func testLowestRiskPath5x5() throws {
        // given
        let chitonPathCalculator = ChitonPathCalculator(measurementsFile: .testChitonRiskLevelData)

        // when
        let lowestRiskPath5x5 = chitonPathCalculator.lowestRiskPath5x5()

        // then
        let expectedLowestRiskPath = 315
        XCTAssertEqual(lowestRiskPath5x5, expectedLowestRiskPath)
    }

    func testPerformanceExample() throws {
        let chitonPathCalculator = ChitonPathCalculator(measurementsFile: .testChitonRiskLevelData)
        self.measure {
            _ = chitonPathCalculator.lowestRiskPath()
        }
    }

}
