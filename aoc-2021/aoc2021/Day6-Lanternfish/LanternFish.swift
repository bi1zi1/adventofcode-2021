import Foundation

typealias Population = [Int]

public final class LanternFish {
    private let fileReader: FileReader
    public init(measurementsFile: FileResource = .lanternfishSpawnData) {
        fileReader = FileReader(fileResource: measurementsFile)
    }

    public func populationCount80day() -> Int {
        guard let data = try? fileReader.lines().first else {
            assertionFailure("data missing")
            return .zero
        }

        let population = data.split(separator: ",").compactMap { Int($0) }

        return populationCount(in: 80, for: population)
    }

    func populationCount(in days: Int, for currentPopulation: Population) -> Int {
        assert(days >= 0)

        var population = currentPopulation

        (0..<days).forEach { _ in
            let newMembersCount = population.filter({ $0 == .zero }).count
            population.decreaseAll()
            population.append(contentsOf:Array(repeatElement(8, count: newMembersCount)))
        }

        return population.count
    }
}

extension Population {
    mutating func decreaseAll() {
        enumerated().forEach { key, value in
            self[key] = value.decrease()
        }
    }
}

extension Int {
    func decrease() -> Int {
        switch self {
        case ...0:
            return 6
        default:
            return self - 1
        }
    }
}
