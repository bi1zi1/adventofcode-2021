import Foundation

public enum FileResource: String {
    case depthMeasurements = "depth-measurements.txt"
    case navigationData = "navigation-data.txt"
    case binaryDiagnosticData = "binary-diagnostic-data.txt"
    case bingoData = "bingo-data.txt"
    case hydrothermalLinesData = "hydrothermal-lines-data.txt"
    case lanternfishSpawnData = "lanternfish-spawn-data.txt"
    case horizontalPositionData = "horizontal-position-data.txt"
    case sevenSegmentDisplayData = "7segment-display-data.txt"
    case areaPointsData = "area-points-data.txt"
    case syntaxData = "syntax-data.txt"
    case energyLevelsData = "energy-levels-data.txt"
    case cavePathData = "cave-path-data.txt"
    case paperDotsData = "paper-dots-data.txt"
    case polymerData = "polymer-data.txt"
    case chitonRiskLevelData = "chiton-risk-level-data.txt"
    case chitonRiskLevel5x5Data = "chiton-risk-level-5x5-data.txt"
    case hexPacketData = "hex-packet-data.txt"

    // test files
    case testDepthMeasurements = "test-depth-measurements.txt"
    case testNavigationData = "test-navigation-data.txt"
    case testBinaryDiagnosticData = "test-binary-diagnostic-data.txt"
    case testBingoData = "test-bingo-data.txt"
    case testHydrothermalLinesData = "test-hydrothermal-lines-data.txt"
    case testLanternfishSpawnData = "test-lanternfish-spawn-data.txt"
    case testHorizontalPositionData = "test-horizontal-position-data.txt"
    case testSevenSegmentDisplayData = "test-7segment-display-data.txt"
    case testAreaPointsData = "test-area-points-data.txt"
    case testSyntaxData = "test-syntax-data.txt"
    case testEnergyLevelsData = "test-energy-levels-data.txt"
    case test10CavePathData = "test10-cave-path-data.txt"
    case test19CavePathData = "test19-cave-path-data.txt"
    case test226CavePathData = "test226-cave-path-data.txt"
    case testPaperDotsData = "test-paper-dots-data.txt"
    case testPolymerData = "test-polymer-data.txt"
    case testChitonRiskLevelData = "test-chiton-risk-level-data.txt"
    case testHexPacketData = "test-hex-packet-data.txt"
    case testHexPacketValueData = "test-hex-packet-value-data.txt"
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

        case .hydrothermalLinesData, .testHydrothermalLinesData:
            return ColumnDefinition(
                columns: [
                    ColumnKey(index: 0, name: "vent-line"): .ventLine
                ])

        case .bingoData, .testBingoData,
                .lanternfishSpawnData, .testLanternfishSpawnData,
                .horizontalPositionData, .testHorizontalPositionData,
                .sevenSegmentDisplayData, .testSevenSegmentDisplayData,
                .areaPointsData, .testAreaPointsData,
                .syntaxData, .testSyntaxData,
                .energyLevelsData, .testEnergyLevelsData,
                .cavePathData, .test10CavePathData, .test19CavePathData, .test226CavePathData,
                .paperDotsData, .testPaperDotsData,
                .polymerData, .testPolymerData,
                .chitonRiskLevelData, .chitonRiskLevel5x5Data, .testChitonRiskLevelData,
                .hexPacketData, .testHexPacketData, .testHexPacketValueData:
            // Currently not supported
            fatalError()
        }
    }
}
