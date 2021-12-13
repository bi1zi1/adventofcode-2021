import Foundation

public final class PassagePathing {
    private let fileReader: FileReader
    public init(measurementsFile: FileResource = .cavePathData) {
        fileReader = FileReader(fileResource: measurementsFile)
    }

    public func pathOptionsTwiceAllowedCount() -> Int {
        guard let data = try? fileReader.lines().filter({ !$0.isEmpty }) else {
            assertionFailure("data missing")
            return .zero
        }

        let nameDict = dict(data: data)
        let caves = caves(nameDict: nameDict)

        guard let startCave = caves
                .first(where: { $0.name == "start" }),
              let endCave = caves
                .first(where: { $0.name == "end" })
        else {
            return .zero
        }

        let smallCaves = caves.filter { cave in
            if cave == startCave { return false }
            if cave == endCave { return false }

            switch cave.size {
            case .small:
                return true
            case .big:
                return false
            }
        }

        var paths: Set<[Cave]> = []
        smallCaves.forEach { smallCave in
            findAllPaths(
                from: startCave,
                till: endCave,
                blocked: [startCave],
                twiceAllowed: smallCave,
                path: [],
                result: &paths
            )
        }

        return paths.count
    }

    func findAllPaths(
        from start: Cave,
        till end: Cave,
        blocked: [Cave],
        twiceAllowed: Cave?,
        path: [Cave],
        result: inout Set<[Cave]>
    ) {
//        print("==============================")
//        print("start", start)
//        print("blocked", blocked)
//        print("path", path)
//        print("==============================")

        let newPath = path + [start]

        if start == end {
            // found exit
            result.insert(newPath)
            return
        }

        let allowedCaves = start.caves
            .filter { !blocked.contains($0) }


        let newTwiceAllowed: Cave?
        let newBlocked: [Cave]
        switch start.size {
        case .small:
            if start == twiceAllowed {
                newTwiceAllowed = nil
                newBlocked = blocked
            } else {
                newTwiceAllowed = twiceAllowed
                newBlocked = blocked + [start]
            }
        case .big:
            newTwiceAllowed = twiceAllowed
            newBlocked = blocked
        }

        if allowedCaves.isEmpty {
            // dead end
            return
        }

        allowedCaves.forEach { nextCave in
            findAllPaths(
                from: nextCave,
                till: end,
                blocked: newBlocked,
                twiceAllowed: newTwiceAllowed,
                path: newPath,
                result: &result)
        }
    }

    public func pathOptionsCount() -> Int {
        guard let data = try? fileReader.lines().filter({ !$0.isEmpty }) else {
            assertionFailure("data missing")
            return .zero
        }

        let nameDict = dict(data: data)
        let caves = caves(nameDict: nameDict)

        guard let startCave = caves
                .first(where: { $0.name == "start" }),
              let endCave = caves
                .first(where: { $0.name == "end" })
        else {
            return .zero
        }

        var paths: [[Cave]] = []
        findAllPaths(
            from: startCave,
            till: endCave,
            blocked: [startCave],
            path: [],
            result: &paths
        )

        return paths.count
    }

    func findAllPaths(
        from start: Cave,
        till end: Cave,
        blocked: [Cave],
        path: [Cave],
        result: inout [[Cave]]
    ) {
//        print("==============================")
//        print("start", start)
//        print("blocked", blocked)
//        print("path", path)
//        print("==============================")

        let newPath = path + [start]

        if start == end {
            // found exit
            result.append(newPath)
            return
        }

        let allowedCaves = start.caves
            .filter { !blocked.contains($0) }


        let newBlocked: [Cave]
        switch start.size {
        case .small:
            newBlocked = blocked + [start]
        case .big:
            newBlocked = blocked
        }

        if allowedCaves.isEmpty {
            // dead end
            return
        }

        allowedCaves.forEach { nextCave in
            findAllPaths(
                from: nextCave,
                till: end,
                blocked: newBlocked,
                path: newPath,
                result: &result)
        }
    }

    func dict(data: [String]) -> [String: [String]] {
        data.reduce(into: [:]) { partialResult, line in
            let items = line
                .split(separator: "-")
                .compactMap(String.init)
            assert(items.count == 2)

            partialResult[items.first!, default: []] += [items.last!]
            partialResult[items.last!, default: []] += [items.first!]
        }
    }

    func caves(nameDict: [String: [String]]) -> [Cave] {
        let bareCaveDict = nameDict.keys.reduce(into: [:], { $0[$1] = Cave(name: $1) })

        bareCaveDict.forEach { key, cave in
            let caves = nameDict[cave.name]?
                .compactMap { bareCaveDict[$0] }
            ?? []

            cave.assignCaves(caves: caves)
        }

        return Array(bareCaveDict.values)
    }
}
