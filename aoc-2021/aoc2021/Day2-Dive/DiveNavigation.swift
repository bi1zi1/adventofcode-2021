import Foundation

enum Direction: String {
    case forward
    case down
    case up
}

public final class DiveNavigation {
    private let formattedFileReader: FormattedFileReader

    public init(measurementsFile: FileResource = .navigationData) {
        self.formattedFileReader = FormattedFileReader(fileResource: measurementsFile)
    }

    public func positionAndDepthWithAim() -> (Int, Int) {
        let data = extractDirectionAndVelocity(from: formattedFileReader.dataRows())

        var aim = Int.zero
        var position = Int.zero
        var depth = Int.zero

        data.forEach { (direction, velocity) in
            switch direction {
            case .forward:
                position += velocity
                depth += aim * velocity
            case .down:
                aim += velocity
            case .up:
                aim -= velocity
            }
        }

        return (position, depth)
    }

    public func positionAndDepth() -> (Int, Int) {
        let data = extractDirectionAndVelocity(from: formattedFileReader.dataRows())

        var position = Int.zero
        var depth = Int.zero

        data.forEach { (direction, velocity) in
            switch direction {
            case .forward:
                position += velocity
            case .down:
                depth += velocity
            case .up:
                depth -= velocity
            }
        }

        return (position, depth)
    }

    private func extractDirectionAndVelocity(from rows: [Row]) -> [(Direction, Int)] {
        rows.compactMap {
            let typeDirection = $0.columns[0].type
            let rawValueDirection = $0.columns[0].rawValue
            let direction: Direction? = typeDirection.value(from: rawValueDirection)

            let typeVelocity = $0.columns[1].type
            let rawValueVelocity = $0.columns[1].rawValue
            let velocity: Int? = typeVelocity.value(from: rawValueVelocity)

            guard let direction = direction, let velocity = velocity else {
                return nil
            }

            return (direction, velocity)
        }
    }
}
