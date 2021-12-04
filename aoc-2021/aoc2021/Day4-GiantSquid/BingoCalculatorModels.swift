import Foundation

final class BingoLine {
    let numbers: [Int]
    private var matchedNumbers: [Int] = []

    init(numbers: [Int]) {
        self.numbers = numbers
    }

    func tryMatch(number: Int) {
        if numbers.contains(number) {
            matchedNumbers.append(number)
        }
    }

    var allMatched: Bool {
        numbers.count == matchedNumbers.count
    }

    func score() -> Int {
        let numbersSum = numbers.reduce(Int.zero, +)
        let matchedNumbersSum = matchedNumbers.reduce(Int.zero, +)
        return numbersSum - matchedNumbersSum
    }
}

final class BingoCard {
    private var rows: [BingoLine]
    private var columns: [BingoLine]

    init(rows: [BingoLine], columns: [BingoLine]) {
        self.rows = rows
        self.columns = columns
    }
}

typealias BingoDraw = [Int]

extension BingoDraw {
    // 7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1
    init?(string: String) {
        let items = string.components(separatedBy: ",")
        self = items.compactMap { Int($0) }
    }
}

extension BingoCard {
    var containsMatch: Bool {
        let rowsMatch = rows.reduce(into: false) { partialResult, line in
            partialResult = partialResult || line.allMatched
        }

        let columnsMatch = columns.reduce(into: false) { partialResult, line in
            partialResult = partialResult || line.allMatched
        }

        return rowsMatch || columnsMatch
    }

    // 22 13 17 11  0
    //  8  2 23  4 24
    // 21  9 14 16  7
    //  6 10  3 18  5
    //  1 12 20 15 19
    convenience init?(lines: [String]) {
        var rows: [Int: [Int]] = [:]
        var columns: [Int: [Int]] = [:]

        lines.enumerated().forEach { lineWithIndex in
            let lineNo = lineWithIndex.offset
            let items = lineWithIndex.element
                .components(separatedBy: CharacterSet.whitespaces)
                .compactMap(Int.init)

            assert(items.count == 5) // for this task only

            rows[lineNo] = items
            (0...items.count - 1).forEach { columnIndex in
                columns[columnIndex] = (columns[columnIndex] ?? []) + [items[columnIndex]]
            }
        }

        self.init(
            rows: rows.values.map { BingoLine(numbers: $0) },
            columns: columns.values.map { BingoLine(numbers: $0) }
        )
    }

    func tryMatch(number: Int) {
        rows.forEach { $0.tryMatch(number: number) }
        columns.forEach { $0.tryMatch(number: number) }
    }

    func score() -> Int {
        rows.reduce(Int.zero) { $0 + $1.score() }
    }

    private func selfValidate() {
        rows.enumerated().forEach { rowItem in
            let rowIndex = rowItem.offset
            let rowNumbers = rowItem.element.numbers

            rowNumbers.enumerated().forEach { colItem in
                let index = colItem.offset
                let value = colItem.element

                assert(columns[index].numbers[rowIndex] == value)
            }
        }
    }
}
