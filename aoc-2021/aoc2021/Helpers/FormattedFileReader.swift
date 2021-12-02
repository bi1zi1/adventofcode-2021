import Foundation

final class FormattedFileReader {
    let fileReader: FileReader
    let columnDefinition: ColumnDefinition

    init(fileResource: FileResource) {
        fileReader = FileReader(fileResource: fileResource)
        columnDefinition = fileResource.columnDefinition
    }

    func dataRows() -> [Row] {
        guard let enumeratedLines = try? fileReader.lines().enumerated().lazy else {
            return []
        }

        return enumeratedLines.compactMap(parseRow(index:line:))
    }

    func parseRow(index: Int, line: String) -> Row? {
        let columnStringValues = line
            .components(separatedBy: CharacterSet.whitespaces)
            .compactMap({ String($0) })

        guard columnStringValues.count == columnDefinition.columns.count else {
            return nil
        }

        let columns: [Column] = columnDefinition.columns.map { (key, type) in
            let rawValue = columnStringValues[key.index]
            return Column(name: key.name, type: type, rawValue: rawValue)
        }

        return Row(index: index, columns: columns)
    }
}
