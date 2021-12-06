@testable import AOCFramework

import Foundation
import XCTest

class LanternFishTests: XCTestCase {
    func testPopulationCount80day() throws {
        // given
        let lanternFish = LanternFish(measurementsFile: .testLanternfishSpawnData)

        // when
        let populationCount80day = lanternFish.populationCount80day()

        // then
        let expectedPopulationCount80day = 5934
        XCTAssertEqual(populationCount80day, expectedPopulationCount80day)
    }

    func testPopulationCount256day() throws {
        // given
        let lanternFish = LanternFish(measurementsFile: .testLanternfishSpawnData)

        // when
        let populationCount256day = lanternFish.populationCount256day()

        // then
        let expectedPopulationCount256day = 26984457539
        XCTAssertEqual(populationCount256day, expectedPopulationCount256day)
    }

    func testPerformanceExample() throws {
        let lanternFish = LanternFish(measurementsFile: .testLanternfishSpawnData)
        self.measure {
            _ = lanternFish.populationCount80day()
        }
    }

}
