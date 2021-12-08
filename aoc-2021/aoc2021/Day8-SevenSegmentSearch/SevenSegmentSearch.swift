import Foundation

public final class SevenSegmentSearch {
    private let fileReader: FileReader
    public init(measurementsFile: FileResource = .sevenSegmentDisplayData) {
        fileReader = FileReader(fileResource: measurementsFile)
    }

    public func count_1_4_7_8() -> Int {
        guard let data = try? fileReader.lines() else {
            assertionFailure("data missing")
            return .zero
        }

        let filterLengths = [2, 3, 4, 7]

        return data
            .lazy
            .reduce(Int.zero, {
                let validFourDigitsCount = $1
                    .split(separator: "|")
                    .last?
                    .components(separatedBy: CharacterSet.whitespaces)
                    .compactMap({ String($0) })
                    .filter({ filterLengths.contains($0.count) })
                    .count
                ?? .zero
                return $0 + validFourDigitsCount
            })
    }
}
