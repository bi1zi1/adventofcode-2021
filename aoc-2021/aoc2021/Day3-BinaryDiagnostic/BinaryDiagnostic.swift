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

    func gammaRate(from rows: [Row]) -> BinaryNumber {
        let maxSum = rows.count
        var radixSum: [Int: Int] = [:]

        rows.forEach { row in
            let typeBinary = row.columns[0].type
            let rawValueBinary = row.columns[0].rawValue
            guard let binary: BinaryNumber = typeBinary.value(from: rawValueBinary) else { return }

            binary.digits.forEach { key, value in
                radixSum[key] = (radixSum[key] ?? .zero) + value.rawValue
            }
        }

        var digits: [Int: BinaryDigit] = [:]
        radixSum.forEach { digits[$0.key] = ($0.value > (maxSum / 2) ? .one : .zero) }

        return BinaryNumber(digits: digits)
    }
}
