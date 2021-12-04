import Foundation

public final class BingoCalculator {
    let bingoFileReader: BingoFileReader

    public init(fileResource: FileResource = .bingoData) {
        bingoFileReader = BingoFileReader(fileResource: fileResource)
    }

    public func finalScore() -> Int {
        guard let numbersDrawn = BingoDraw(string: bingoFileReader.bingoDraw) else {
            return .zero
        }

        let bingoCards = bingoFileReader.bingoCards
            .compactMap { BingoCard(lines: $0) }

        for number in numbersDrawn {
            for card in bingoCards {
                card.tryMatch(number: number)
                if card.containsMatch {
//                    print("\(card.score()) * \(number)")
                    return card.score() * number
                }
            }
        }

        return .zero
    }

    public func lastCardFinalScore() -> Int {
        guard let numbersDrawn = BingoDraw(string: bingoFileReader.bingoDraw) else {
            return .zero
        }

        let bingoCards = bingoFileReader.bingoCards
            .compactMap { BingoCard(lines: $0) }

        var lastFinalScore = Int.zero
        for number in numbersDrawn {
            for card in bingoCards {
                if card.containsMatch { continue }

                card.tryMatch(number: number)
                if card.containsMatch {
                    print("\(card.score()) * \(number)")
                    lastFinalScore = card.score() * number
                }
            }
        }

        return lastFinalScore
    }
}
