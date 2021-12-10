import Foundation

public final class SyntaxScoring {
    private let fileReader: FileReader
    public init(measurementsFile: FileResource = .syntaxData) {
        fileReader = FileReader(fileResource: measurementsFile)
    }

    public func syntaxErrorCount() -> Int {
        guard let data = try? fileReader.lines() else {
            assertionFailure("data missing")
            return .zero
        }

        return data
            .compactMap({ syntaxErrorCharacter(line: $0) })
            .compactMap({ closedTBracketErrorValue[$0] })
            .reduce(.zero, +)
    }

    func syntaxErrorCharacter(line: String) -> Character? {
//        guard line.count % 2 == 0 else { return nil }
//
//        let openBracketsCount = line.reduce(.zero) { result, char in
//            result + (openBrackets.contains(char) ? 1 : 0)
//        }
//
//        let closedBracketsCount = line.reduce(.zero) { result, char in
//            result + (closedBrackets.contains(char) ? 1 : 0)
//        }
//
//        guard openBracketsCount == closedBracketsCount else { return nil }

        var parsedChars: [Character] = []

        for char in line {
            if openBrackets.contains(char) {
                parsedChars.append(char)
            }

            if closedBrackets.contains(char) {
                guard let openBracket = parsedChars.last else { return nil }
                parsedChars.remove(at: parsedChars.count - 1)
                let expectedBracket = openToClosedBracketPair[openBracket]

                if char != expectedBracket {
                    return char
                }
            }
        }

        return nil
    }
}
