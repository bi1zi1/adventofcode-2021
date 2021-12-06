@testable import AOCFramework

import Foundation
import XCTest

class HydrothermalDangerTests: XCTestCase {
    func testDangerPointsCount() throws {
        // given
        let hydrothermalDanger = HydrothermalDanger(measurementsFile: .testHydrothermalLinesData)

        // when
        let dangerPointsCount = hydrothermalDanger.dangerPointsCount()

        // then
        let expectedDangerPointsCount = 5
        XCTAssertEqual(dangerPointsCount, expectedDangerPointsCount)
    }

    func testDangerPointsWithDiagonalCount() throws {
        // given
        let hydrothermalDanger = HydrothermalDanger(measurementsFile: .testHydrothermalLinesData)

        // when
        let dangerPointsCount = hydrothermalDanger.dangerPointsWithDiagonalCount()

        // then
        let expectedDangerPointsCount = 12
        XCTAssertEqual(dangerPointsCount, expectedDangerPointsCount)
    }

    func testPerformanceExample() throws {
        let hydrothermalDanger = HydrothermalDanger(measurementsFile: .testHydrothermalLinesData)
        self.measure {
            _ = hydrothermalDanger.dangerPointsCount()
        }
    }

}
