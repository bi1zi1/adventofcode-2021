import Foundation

enum SupportedDataType {
    case int
    case string
}

extension SupportedDataType {
    func value(from string: String) -> Int? {
        switch self {
        case .int:
            return Int(string)
        case .string:
            return nil
        }
    }

    func value(from string: String) -> String? {
        switch self {
        case .int:
            return nil
        case .string:
            return string
        }
    }
}

struct ColumnDefinition {
    let columns: [ColumnKey: SupportedDataType]
}

struct Column {
    let name: String
    let type: SupportedDataType
    let rawValue: String
}

struct Row {
    let index: Int
    let columns: [Column]
}

struct ColumnKey: Hashable {
    let index: Int
    let name: String
}
