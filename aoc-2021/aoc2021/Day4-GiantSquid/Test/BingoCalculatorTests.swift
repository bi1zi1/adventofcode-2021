@testable import AOCFramework

import Foundation
import XCTest

class BingoCalculatorTests: XCTestCase {
    func testFinalScore() throws {
        // given
        let bingoCalculator = BingoCalculator(fileResource: .testBingoData)

        // when
        let finalScore = bingoCalculator.finalScore()

        // then
        let expectedFinalScore = 4512
        XCTAssertEqual(finalScore, expectedFinalScore)
    }

    func testPerformanceExample() throws {
        let bingoCalculator = BingoCalculator(fileResource: .testBingoData)
        self.measure {
            _ = bingoCalculator.finalScore()
        }
    }
}
