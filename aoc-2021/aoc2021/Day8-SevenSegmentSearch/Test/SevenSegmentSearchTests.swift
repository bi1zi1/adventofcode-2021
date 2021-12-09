@testable import AOCFramework

import Foundation
import XCTest

class SevenSegmentSearchTests: XCTestCase {
    func testCount_1_4_7_8() throws {
        // given
        let sevenSegmentSearch = SevenSegmentSearch(measurementsFile: .testSevenSegmentDisplayData)

        // when
        let count_1_4_7_8 = sevenSegmentSearch.count_1_4_7_8()

        // then
        let expectedCount_1_4_7_8 = 26
        XCTAssertEqual(count_1_4_7_8, expectedCount_1_4_7_8)
    }

    func testSumDecipheredNumbers() throws {
        // given
        let sevenSegmentSearch = SevenSegmentSearch(measurementsFile: .testSevenSegmentDisplayData)

        // when
        let sumDecipheredNumbers = sevenSegmentSearch.sumDecipheredNumbers()

        // then
        let expectedSumDecipheredNumbers = 61229
        XCTAssertEqual(sumDecipheredNumbers, expectedSumDecipheredNumbers)
    }

    func testPerformanceExample() throws {
        let sevenSegmentSearch = SevenSegmentSearch(measurementsFile: .testSevenSegmentDisplayData)
        self.measure {
            _ = sevenSegmentSearch.count_1_4_7_8()
        }
    }

}
