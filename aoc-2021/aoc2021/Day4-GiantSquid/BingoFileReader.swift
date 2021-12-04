import Foundation

final class BingoFileReader {
    let fileReader: FileReader
    var bingoDraw: String = ""
    var bingoCards: [[String]] = []

    init(fileResource: FileResource) {
        fileReader = FileReader(fileResource: fileResource)
        processData()
    }

    private func processData() {
        guard let dataRows = try? fileReader.lines() else { return }

        bingoDraw = dataRows[0]

        var bingoCardData: [String] = []
        dataRows.enumerated().forEach { rowItem in
            let index = rowItem.offset
            let lineData = rowItem.element

            if index == .zero { return } // skip this, contains drawn numbers

            if lineData.isEmpty {
                if !bingoCardData.isEmpty {
                    bingoCards.append(bingoCardData)
                    bingoCardData = []
                }
                return
            }

            bingoCardData.append(lineData)
        }

        if !bingoCardData.isEmpty {
            bingoCards.append(bingoCardData)
            bingoCardData = []
        }
    }
}
