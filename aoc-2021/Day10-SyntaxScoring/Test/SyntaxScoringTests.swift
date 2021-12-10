@testable import AOCFramework

import Foundation
import XCTest

class SyntaxScoringTests: XCTestCase {
    func testExample() throws {
        // given
        let syntaxScoring = SyntaxScoring(measurementsFile: .testSyntaxData)

        // when
        let syntaxErrorCount = syntaxScoring.syntaxErrorCount()

        // then
        let expectedSyntaxErrorCount = 26397
        XCTAssertEqual(syntaxErrorCount, expectedSyntaxErrorCount)
    }

    func testPerformanceExample() throws {
        let syntaxScoring = SyntaxScoring(measurementsFile: .testSyntaxData)
        self.measure {
            _ = syntaxScoring.syntaxErrorCount()
        }
    }

}
