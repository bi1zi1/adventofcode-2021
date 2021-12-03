import Foundation

enum SupportedDataType {
    case int
    case string
    case direction
    case binaryNumber
}

extension SupportedDataType {
    func value(from string: String) -> Int? {
        switch self {
        case .int:
            return Int(string)
        case .string, .direction, .binaryNumber:
            return nil
        }
    }

    func value(from string: String) -> String? {
        switch self {
        case .string:
            return string
        case .int, .direction, .binaryNumber:
            return nil
        }
    }

    func value(from string: String) -> Direction? {
        switch self {
        case .direction:
            return Direction(rawValue: string)
        case .int, .string, .binaryNumber:
            return nil
        }
    }

    func value(from string: String) -> BinaryNumber? {
        switch self {
        case .binaryNumber:
            return BinaryNumber(string: string)
        case .int, .string, .direction:
            return nil
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
