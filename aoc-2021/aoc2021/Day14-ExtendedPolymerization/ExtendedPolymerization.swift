import Foundation

typealias KeyPair = String
typealias KeyAtom = String

public final class ExtendedPolymerization {
    private let fileReader: FileReader
    public init(measurementsFile: FileResource = .polymerData) {
        fileReader = FileReader(fileResource: measurementsFile)
    }

    public func quantityDiff10steps() -> Int {
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
                iterationsLeft: 10,
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
