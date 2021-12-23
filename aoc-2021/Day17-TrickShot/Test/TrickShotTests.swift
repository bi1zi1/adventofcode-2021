@testable import AOCFramework

import Foundation
import XCTest

class TrickShotTests: XCTestCase {
    func testShootHighest() throws {
        // given
        let trickShot = TrickShot(
            targetAreaX: 20...30,
            targetAreaY: (-10)...(-5)
        )

        // when
        let shootHighest = trickShot.shootHighest()

        // then
        let expectedShootHighest = 45
        XCTAssertEqual(shootHighest, expectedShootHighest)
    }

    func testPerformanceExample() throws {
        let trickShot = TrickShot()
        self.measure {
            _ = trickShot.shootHighest()
        }
    }

}
