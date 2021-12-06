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

    public func populationCount256day() -> Int {
        guard let data = try? fileReader.lines().first else {
            assertionFailure("data missing")
            return .zero
        }

        let population = data.split(separator: ",").compactMap { Int($0) }

        return populationCountSum(in: 256, for: population)
    }

    func populationCount(in days: Int, for currentPopulation: Population) -> Int {
        assert(days >= 0)

        var population = currentPopulation

        printPopulation(day: .zero, population: sumGrid(population: population))

        (1...days).forEach { day in
            let newMembersCount = population.filter({ $0 == .zero }).count
            population.decreaseAll()
            population.append(contentsOf:Array(repeatElement(8, count: newMembersCount)))

            printPopulation(day: day, population: sumGrid(population: population))
        }

        return population.count
    }

    func populationCountSum(in days: Int, for currentPopulation: Population) -> Int {
        assert(days >= 0)

        var daysLeftPopulationCount = [
            0: 0,
            1: 0,
            2: 0,
            3: 0,
            4: 0,
            5: 0,
            6: 0,
            7: 0,
            8: 0,
        ]

        currentPopulation.forEach { dayValue in
            daysLeftPopulationCount[dayValue, default: 0] += 1
        }

        printPopulation(day: .zero, population: daysLeftPopulationCount)
        (1...days).forEach { day in
            let newMembersCount = daysLeftPopulationCount[0, default: 0]
            (0...7).forEach { key in
                daysLeftPopulationCount[key] = daysLeftPopulationCount[key + 1, default: 0]
            }
            daysLeftPopulationCount[8] = newMembersCount
            daysLeftPopulationCount[6, default: .zero] += newMembersCount

            printPopulation(day: day, population: daysLeftPopulationCount)
        }

        return daysLeftPopulationCount.reduce(into: .zero) { $0 += $1.value }

    }

    func printPopulation(day: Int, population: [Int: Int]) {
//        print("DAY: \(day)")
//        (0...20).forEach {
//            print("[\($0)] = ", population[$0, default: .zero])
//        }
//        print("===== SUM[\(day)] = \(population.reduce(into: .zero) { $0 += $1.value }) =====")
    }

    func sumGrid(population: Population) -> [Int: Int] {
        var daysLeftPopulationCount = [
            0: 0,
            1: 0,
            2: 0,
            3: 0,
            4: 0,
            5: 0,
            6: 0,
            7: 0,
            8: 0,
        ]

        population.forEach { dayValue in
            daysLeftPopulationCount[dayValue, default: 0] += 1
        }

        return daysLeftPopulationCount
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
