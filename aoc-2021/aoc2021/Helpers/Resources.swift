import Foundation

public enum FileResource: String {
    case depthMeasurements = "depth-measurements.txt"
    case navigationData = "navigation-data.txt"
    case binaryDiagnosticData = "binary-diagnostic-data.txt"
    case bingoData = "bingo-data.txt"

    // test files
    case testDepthMeasurements = "test-depth-measurements.txt"
    case testNavigationData = "test-navigation-data.txt"
    case testBinaryDiagnosticData = "test-binary-diagnostic-data.txt"
    case testBingoData = "test-bingo-data.txt"
}

extension FileResource {
    var filename: String? {
        rawValue.split(separator: ".").first.map(String.init)
    }

    var `extension`: String? {
        rawValue.split(separator: ".").last.map(String.init)
    }
}

extension FileResource {
    var columnDefinition: ColumnDefinition {
        switch self {
        case .depthMeasurements, .testDepthMeasurements:
            return ColumnDefinition(
                columns: [
                    ColumnKey(index: 0, name: "depth"): .int
                ])

        case .navigationData, .testNavigationData:
            return ColumnDefinition(
                columns: [
                    ColumnKey(index: 0, name: "direction"): .direction,
                    ColumnKey(index: 1, name: "velocity"): .int,
                ])

        case .binaryDiagnosticData, .testBinaryDiagnosticData:
            return ColumnDefinition(
                columns: [
                    ColumnKey(index: 0, name: "binary"): .binaryNumber
                ])

        case .bingoData, .testBingoData:
            // Currently not supported
            fatalError()
        }
    }
}
