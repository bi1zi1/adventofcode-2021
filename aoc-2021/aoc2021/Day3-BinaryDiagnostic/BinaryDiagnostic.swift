import Foundation

public final class BinaryDiagnostic {
    private let formattedFileReader: FormattedFileReader
    public init(measurementsFile: FileResource = .binaryDiagnosticData) {
        self.formattedFileReader = FormattedFileReader(fileResource: measurementsFile)
    }

    public func gammaRateAndEpsilonRate() -> (Int, Int) {
        let data = formattedFileReader.dataRows()

        let gammaRate = gammaRate(from: data)
        let epsilonRate = gammaRate.inverse

        return (gammaRate.intValue, epsilonRate.intValue)
    }

    public func oxygenGeneratorRatingAndCO2ScrubberRating() -> (Int, Int) {
        let data = formattedFileReader.dataRows()

        let oxygenGeneratorRating = oxygenGeneratorRating(from: data)
        let co2ScrubberRating = co2ScrubberRating(from: data)

        return (oxygenGeneratorRating.intValue, co2ScrubberRating.intValue)
    }

    func gammaRate(from rows: [Row]) -> BinaryNumber {
        let maxSum = rows.count
        var indexSum: [Int: Int] = [:]

        rows.forEach { row in
            let typeBinary = row.columns[0].type
            let rawValueBinary = row.columns[0].rawValue
            guard let binary: BinaryNumber = typeBinary.value(from: rawValueBinary) else { return }

            binary.digits.forEach { key, value in
                indexSum[key] = (indexSum[key] ?? .zero) + value.rawValue
            }
        }

        var digits: [Int: BinaryDigit] = [:]
        indexSum.forEach { digits[$0.key] = ($0.value >= ((maxSum + 1) / 2) ? .one : .zero) }

        return BinaryNumber(digits: digits)
    }

    func oxygenGeneratorRating(from rows: [Row]) -> BinaryNumber {
        var resultRows = rows
        var iteration = Int.zero

        while resultRows.count > 1 {
            let filterNumber = gammaRate(from: resultRows)
            let filterIndex = filterNumber.length - iteration
            if filterIndex < .zero {
                assertionFailure("Did not end up with only one number")
                break
            }
            let filterDigit = filterNumber.digits[filterIndex] ?? .zero

            resultRows = resultRows.filter { row in
                guard let binary = BinaryNumber(row: row) else { return false }

                return (binary.digits[filterIndex] ?? .zero) == filterDigit
            }

            iteration += 1
        }

        assert(resultRows.count == 1)

        return BinaryNumber(row: resultRows.first!)!
    }

    func co2ScrubberRating(from rows: [Row]) -> BinaryNumber {
        var resultRows = rows
        var iteration = Int.zero

        while resultRows.count > 1 {
            let filterNumber = gammaRate(from: resultRows).inverse
            let filterIndex = filterNumber.length - iteration
            if filterIndex < .zero {
                assertionFailure("Did not end up with only one number")
                break
            }
            let filterDigit = filterNumber.digits[filterIndex] ?? .zero

            resultRows = resultRows.filter { row in
                guard let binary = BinaryNumber(row: row) else { return false }

                return (binary.digits[filterIndex] ?? .zero) == filterDigit
            }

            iteration += 1
        }

        assert(resultRows.count == 1)

        return BinaryNumber(row: resultRows.first!)!
    }
}

extension BinaryNumber {
    init?(row: Row) {
        let typeBinary = row.columns[0].type
        let rawValueBinary = row.columns[0].rawValue
        guard let binary: BinaryNumber = typeBinary.value(from: rawValueBinary) else { return nil }
        self.init(digits: binary.digits)
    }
}
