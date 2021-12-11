@testable import AOCFramework

import Foundation
import XCTest

class EnergyLevelCalculatorTests: XCTestCase {
    func testTotalFlashes100steps() throws {
        // given
        let energyLevelCalculator = EnergyLevelCalculator(measurementsFile: .testEnergyLevelsData)

        // when
        let totalFlashes100steps = energyLevelCalculator.totalFlashes100steps()

        // then
        let expectedTotalFlashes100steps = 1656
        XCTAssertEqual(totalFlashes100steps, expectedTotalFlashes100steps)
    }

    func testPerformanceExample() throws {
        let energyLevelCalculator = EnergyLevelCalculator(measurementsFile: .testEnergyLevelsData)
        self.measure {
            _ = energyLevelCalculator.totalFlashes100steps()
        }
    }

}
