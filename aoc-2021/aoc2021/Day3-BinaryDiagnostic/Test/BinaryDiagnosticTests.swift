@testable import AOCFramework

import Foundation
import XCTest

class BinaryDiagnosticTests: XCTestCase {
    func testGammaRateAndEpsilonRate() throws {
        // given
        let binaryDiagnostic = BinaryDiagnostic(measurementsFile: .testBinaryDiagnosticData)

        // when
        let (gammaRate, epsilonRate) = binaryDiagnostic.gammaRateAndEpsilonRate()

        // then
        let expectedGammaRate = 22
        XCTAssertEqual(gammaRate, expectedGammaRate)
        let expectedEpsilonRate = 9
        XCTAssertEqual(epsilonRate, expectedEpsilonRate)
    }

    func testOxygenGeneratorRatingAndCO2ScrubberRating() throws {
        // given
        let binaryDiagnostic = BinaryDiagnostic(measurementsFile: .testBinaryDiagnosticData)

        // when
        let (oxygenGeneratorRating, co2ScrubberRating) = binaryDiagnostic.oxygenGeneratorRatingAndCO2ScrubberRating()

        // then
        let expectedOxygenGeneratorRating = 23
        XCTAssertEqual(oxygenGeneratorRating, expectedOxygenGeneratorRating)
        let expectedCO2ScrubberRating = 10
        XCTAssertEqual(co2ScrubberRating, expectedCO2ScrubberRating)
    }

    func testPerformanceExample() throws {
        let binaryDiagnostic = BinaryDiagnostic(measurementsFile: .testBinaryDiagnosticData)
        self.measure {
            _ = binaryDiagnostic.gammaRateAndEpsilonRate()
        }
    }
}
