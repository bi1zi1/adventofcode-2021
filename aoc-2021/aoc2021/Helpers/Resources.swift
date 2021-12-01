import Foundation

public enum FileResource: String {
    case depthMeasurements = "depth-measurements.txt"

    // test files
    case testDepthMeasurements = "test-depth-measurements.txt"
}

extension FileResource {
    var filename: String? {
        rawValue.split(separator: ".").first.map(String.init)
    }

    var `extension`: String? {
        rawValue.split(separator: ".").last.map(String.init)
    }
}
