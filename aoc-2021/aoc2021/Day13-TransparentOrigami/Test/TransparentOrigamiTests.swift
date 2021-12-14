@testable import AOCFramework

import Foundation
import XCTest

class TransparentOrigamiTests: XCTestCase {
    func testVisibleDotsFirstFold() throws {
        // given
        let transparentOrigami = TransparentOrigami(measurementsFile: .testPaperDotsData)

        // when
        let visibleDotsFirstFold = transparentOrigami.visibleDotsFirstFold()

        // then
        let expectedVisibleDotsFirstFold = 17
        XCTAssertEqual(visibleDotsFirstFold, expectedVisibleDotsFirstFold)
    }

    func testPerformanceExample() throws {
        let transparentOrigami = TransparentOrigami(measurementsFile: .testPaperDotsData)
        self.measure {
            _ = transparentOrigami.visibleDotsFirstFold()
        }
    }

}
