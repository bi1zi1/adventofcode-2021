import Foundation

typealias KeyPair = String
typealias KeyAtom = String

public final class ExtendedPolymerization {
    private let fileReader: FileReader
    public init(measurementsFile: FileResource = .polymerData) {
        fileReader = FileReader(fileResource: measurementsFile)
    }

    public func quantityDiff10steps() -> Int {
        quantityDiff(after: 10)
    }

    // TOO SLOW
//    public func quantityDiff40steps() -> Int {
//        quantityDiff(after: 40)
//    }

    public func quantityDiff10stepsV2() -> Int {
        guard let data = try? fileReader.lines() else {
            assertionFailure("data missing")
            return .zero
        }

        let (polymer, map) = parseData(data: data)

        let itMap = iterationMap(for: map, itCount: 10)

        return quantityDiff(for: polymer, after: 1, with: itMap)
    }

    public func quantityDiff40stepsV2() -> Int {
        guard let data = try? fileReader.lines() else {
            assertionFailure("data missing")
            return .zero
        }

        let (polymer, map) = parseData(data: data)

        let itMap = iterationMap(for: map, itCount: 10)

        return quantityDiff(for: polymer, after: 4, with: itMap)
    }

    func quantityDiff(
        for polymer: String,
        after multipleOf10: Int,
        with iteration10Map: [KeyPair: [KeyPair: Int]]
    ) -> Int {
        if multipleOf10 == 1 {
            return diffSum(for: polymer, map: iteration10Map)
        }

        var itMapGenerated: [KeyPair: [KeyPair: Int]] = iteration10Map
        (2...multipleOf10).forEach { _ in
            itMapGenerated.keys.forEach { key in
                let currentValues = itMapGenerated[key, default: [:]]

                let nextValues = currentValues.reduce(into: [KeyPair: Int]()) { partialResult, currentItem in
                    let next10it = iteration10Map[currentItem.key, default: [:]]
                    next10it.forEach { item in
                        partialResult[item.key, default: .zero] += item.value * currentItem.value
                    }
                }

                itMapGenerated[key] = nextValues
            }
        }

        print(itMapGenerated)

        return diffSum(for: polymer, map: itMapGenerated)
    }

    func diffSum(for polymer: String, map: [KeyPair: [KeyPair: Int]]) -> Int {
        var sumDict = polymer.keyPairs.reduce(into: [KeyAtom: Int]()) { partialResult, item in
            var newMap = map[item, default: [:]]
            newMap[item, default: .zero] += 1
            let atomCount = newMap
                .reduce(into: [KeyAtom: Int]()) { partialResult, keyValuePair in
                    let (fAtom, sAtom) = keyValuePair.key.atoms

                    partialResult[fAtom, default: .zero] += keyValuePair.value
                    partialResult[sAtom, default: .zero] += keyValuePair.value
                }

            atomCount.forEach { atomDict in
                partialResult[atomDict.key, default: .zero] += atomDict.value / 2
            }

            let (f, _) = item.atoms
            partialResult[f, default: .zero] -= 1
//                partialResult[s, default: .zero] -= 1
        }
        sumDict[KeyAtom(polymer.first!), default: .zero] += 1

        let min = sumDict.values.min()
        let max = sumDict.values.max()

        return (max ?? .zero) - (min ?? .zero)
    }

    func quantityDiff(after steps: Int) -> Int {
        guard let data = try? fileReader.lines() else {
            assertionFailure("data missing")
            return .zero
        }

        let (polymer, map) = parseData(data: data)

        var sumDict = polymer.keyPairs.reduce(into: [KeyAtom: Int]()) { partialResult, item in
            var itemResult: [KeyAtom: Int] = [:]
            pairCount(
                item: item,
                map: map,
                iterationsLeft: steps,
                sum: &itemResult
            )

            itemResult.forEach { atomDict in
                partialResult[atomDict.key, default: .zero] += atomDict.value
            }
        }
        sumDict[KeyAtom(polymer.first!), default: .zero] += 1

        let min = sumDict.values.min()
        let max = sumDict.values.max()

        return (max ?? .zero) - (min ?? .zero)
    }

    func iterationMap(for map: [KeyPair: KeyAtom], itCount: Int) -> [KeyPair: [KeyPair: Int]] {
        var result: [KeyPair: [KeyPair: Int]] = [:]
        map.keys.forEach { item in
//            var itemResult: [KeyPair: Int] = [item: 1]
            var itemResult: [KeyPair: Int] = [:]
            itPairCount(
                item: item,
                map: map,
                iterationsLeft: itCount,
                sum: &itemResult
            )
            result[item] = itemResult
        }
        return result
    }

    func itPairCount(
        item: KeyPair,
        map: [KeyPair: KeyAtom],
        iterationsLeft: Int,
        sum: inout [KeyPair: Int]
    ) {
        guard iterationsLeft > .zero else {
            sum[item, default: .zero] += 1
            return
        }

        let (itemOne, itemTwo) = pair(item: item, map: map)

        itPairCount(
            item: itemOne,
            map: map,
            iterationsLeft: iterationsLeft - 1,
            sum: &sum)

        itPairCount(
            item: itemTwo,
            map: map,
            iterationsLeft: iterationsLeft - 1,
            sum: &sum)
    }

    func parseData(data: [String]) -> (String, [KeyPair: KeyAtom]) {
        var parseMap = false
        var polymer: String = ""
        var map: [String: String] = [:]

        data.forEach { line in
            if line.isEmpty {
                parseMap.toggle()
                return
            }

            if parseMap {
                guard let value = line.last else {
                    assertionFailure("missing values")
                    return
                }
                let key = line[line.startIndex..<line.index(line.startIndex, offsetBy: 2)]

                map[String(key)] = String(value)
                return
            }

            polymer = line
        }

        return (polymer, map)
    }

    func pairCount(
        item: KeyPair,
        map: [KeyPair: KeyAtom],
        iterationsLeft: Int,
        sum: inout [KeyAtom: Int]
    ) {
        guard iterationsLeft > .zero else {
            let (_, secondAtom) = item.atoms
//            sum[firstAtom, default: .zero] += 1
            sum[secondAtom, default: .zero] += 1
//            print(firstAtom, secondAtom)
            return
        }

        let (itemOne, itemTwo) = pair(item: item, map: map)

        pairCount(
            item: itemOne,
            map: map,
            iterationsLeft: iterationsLeft - 1,
            sum: &sum)

        pairCount(
            item: itemTwo,
            map: map,
            iterationsLeft: iterationsLeft - 1,
            sum: &sum)
    }

    func pair(item: KeyPair, map: [KeyPair: KeyAtom]) -> (KeyPair, KeyPair) {
        item.newPairs(with: map[item]!)
    }
}

extension KeyPair {
    func newPairs(with atom: KeyAtom) -> (KeyPair, KeyPair) {
        let (firstAtom, secondAtom) = atoms

        return (
            firstAtom + atom,
            atom + secondAtom
        )
    }

    var atoms: (KeyAtom, KeyAtom) {
        return (
            String(first!),
            String(last!)
        )
    }
}

extension String {
    var keyPairs: [KeyPair] {
        var sIndex = startIndex
        var eIndex = index(after: sIndex)
        var result: [KeyPair] = []

        while eIndex < endIndex {
            result.append(
                KeyPair(self[sIndex...eIndex])
            )

            sIndex = eIndex
            eIndex = index(after: sIndex)
        }

        return result
    }
}
