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
            .compactMap({ closedBracketErrorValue[$0] })
            .reduce(.zero, +)
    }

    public func closingCharactersMiddleSum() -> Int {
        guard let data = try? fileReader.lines() else {
            assertionFailure("data missing")
            return .zero
        }

        let lineScore = data
            .compactMap({ closingCharacters(line: $0) })
            .compactMap({ closingCharactersScore(characters: $0) })
            .sorted()

        return lineScore[lineScore.count / 2]
    }

    func syntaxErrorCharacter(line: String) -> Character? {
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

    func closingCharacters(line: String) -> [Character]? {
        let openBracketsCount = line.reduce(.zero) { result, char in
            result + (openBrackets.contains(char) ? 1 : 0)
        }

        let closedBracketsCount = line.reduce(.zero) { result, char in
            result + (closedBrackets.contains(char) ? 1 : 0)
        }

        guard openBracketsCount > closedBracketsCount else { return nil }

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
                    return nil
                }
            }
        }

        if parsedChars.isEmpty { return nil }

        return parsedChars
            .reversed()
            .compactMap { openToClosedBracketPair[$0] }
    }

    func closingCharactersScore(characters: [Character]) -> Int {
        characters.reduce(.zero) { $0 * 5 + closedBracketScoreValue[$1, default: .zero] }
    }
}
