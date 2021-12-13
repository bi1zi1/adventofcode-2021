@testable import AOCFramework

import Foundation
import XCTest

class PassagePathingTests: XCTestCase {
    func testPathOptionsCount_shouldBe10() throws {
        // given
        let passagePathing = PassagePathing(measurementsFile: .test10CavePathData)

        // when
        let pathOptionsCount = passagePathing.pathOptionsCount()

        // then
        let expectedPathOptionsCount = 10
        XCTAssertEqual(pathOptionsCount, expectedPathOptionsCount)
    }

    func testPathOptionsCount_shouldBe19() throws {
        // given
        let passagePathing = PassagePathing(measurementsFile: .test19CavePathData)

        // when
        let pathOptionsCount = passagePathing.pathOptionsCount()

        // then
        let expectedPathOptionsCount = 19
        XCTAssertEqual(pathOptionsCount, expectedPathOptionsCount)
    }

    func testPathOptionsCount_shouldBe226() throws {
        // given
        let passagePathing = PassagePathing(measurementsFile: .test226CavePathData)

        // when
        let pathOptionsCount = passagePathing.pathOptionsCount()

        // then
        let expectedPathOptionsCount = 226
        XCTAssertEqual(pathOptionsCount, expectedPathOptionsCount)
    }

    func testPathOptionsTwiceAllowedCount_shouldBe36() throws {
        // given
        let passagePathing = PassagePathing(measurementsFile: .test10CavePathData)

        // when
        let pathOptionsCount = passagePathing.pathOptionsTwiceAllowedCount()

        // then
        let expectedPathOptionsCount = 36
        XCTAssertEqual(pathOptionsCount, expectedPathOptionsCount)
    }

    func testPathOptionsTwiceAllowedCount_shouldBe103() throws {
        // given
        let passagePathing = PassagePathing(measurementsFile: .test19CavePathData)

        // when
        let pathOptionsCount = passagePathing.pathOptionsTwiceAllowedCount()

        // then
        let expectedPathOptionsCount = 103
        XCTAssertEqual(pathOptionsCount, expectedPathOptionsCount)
    }

    func testPathOptionsTwiceAllowedCount_shouldBe3509() throws {
        // given
        let passagePathing = PassagePathing(measurementsFile: .test226CavePathData)

        // when
        let pathOptionsCount = passagePathing.pathOptionsTwiceAllowedCount()

        // then
        let expectedPathOptionsCount = 3509
        XCTAssertEqual(pathOptionsCount, expectedPathOptionsCount)
    }

    func testPerformanceExample() throws {
        let passagePathing = PassagePathing(measurementsFile: .test226CavePathData)
        self.measure {
            _ = passagePathing.pathOptionsCount()
        }
    }

}
