@testable import AOCFramework

import Foundation
import XCTest

class SyntaxScoringTests: XCTestCase {
    func testSyntaxErrorCount() throws {
        // given
        let syntaxScoring = SyntaxScoring(measurementsFile: .testSyntaxData)

        // when
        let syntaxErrorCount = syntaxScoring.syntaxErrorCount()

        // then
        let expectedSyntaxErrorCount = 26397
        XCTAssertEqual(syntaxErrorCount, expectedSyntaxErrorCount)
    }

    func testClosingCharactersMiddleSum() throws {
        // given
        let syntaxScoring = SyntaxScoring(measurementsFile: .testSyntaxData)

        // when
        let closingCharactersMiddleSum = syntaxScoring.closingCharactersMiddleSum()

        // then
        let expectedClosingCharactersMiddleSum = 288957
        XCTAssertEqual(closingCharactersMiddleSum, expectedClosingCharactersMiddleSum)
    }

    func testPerformanceExample() throws {
        let syntaxScoring = SyntaxScoring(measurementsFile: .testSyntaxData)
        self.measure {
            _ = syntaxScoring.syntaxErrorCount()
        }
    }

}
