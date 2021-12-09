@testable import AOCFramework

import Foundation
import XCTest

class SmokeBasinTests: XCTestCase {
    func testLowPointsRiskLevelSum() throws {
        // given
        let smokeBasin = SmokeBasin(measurementsFile: .testAreaPointsData)

        // when
        let lowPointsRiskLevelSum = smokeBasin.lowPointsRiskLevelSum()

        // then
        let expectedLowPointsRiskLevelSum = 15
        XCTAssertEqual(lowPointsRiskLevelSum, expectedLowPointsRiskLevelSum)
    }

    func testBasinTop3Multiply() throws {
        // given
        let smokeBasin = SmokeBasin(measurementsFile: .testAreaPointsData)

        // when
        let basinTop3Multiply = smokeBasin.basinTop3Multiply()

        // then
        let expectedBasinTop3Multiply = 1134
        XCTAssertEqual(basinTop3Multiply, expectedBasinTop3Multiply)
    }

    func testPerformanceExample() throws {
        let smokeBasin = SmokeBasin(measurementsFile: .testAreaPointsData)
        self.measure {
            _ = smokeBasin.lowPointsRiskLevelSum()
        }
    }

}
