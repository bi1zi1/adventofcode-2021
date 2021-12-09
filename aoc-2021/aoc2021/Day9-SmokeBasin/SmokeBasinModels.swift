import Foundation

struct Area {
    let rows: [[Int]]
    let columns: [[Int]]
}

extension Area {
    init(lines: [String]) {
        var rows: [[Int]] = Array(repeating: [], count: lines.count)
        var columns: [[Int]] = Array(repeating: [], count: lines.first?.count ?? .zero)

        lines.enumerated().forEach { lineWithIndex in
            guard !lineWithIndex.element.isEmpty else {
                return
            }

            let lineNo = lineWithIndex.offset
            let items = lineWithIndex.element.compactMap { Int(String($0)) }

            rows[lineNo] = items
            (0...items.count - 1).forEach { columnIndex in
                columns[columnIndex] = columns[columnIndex] + [items[columnIndex]]
            }
        }

        self.init(rows: rows, columns: columns)
    }
}
