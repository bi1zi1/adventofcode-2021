import Foundation

public final class SevenSegmentSearch {
    private let fileReader: FileReader
    public init(measurementsFile: FileResource = .sevenSegmentDisplayData) {
        fileReader = FileReader(fileResource: measurementsFile)
    }

    public func count_1_4_7_8() -> Int {
        guard let data = try? fileReader.lines() else {
            assertionFailure("data missing")
            return .zero
        }

        let filterLengths = [2, 3, 4, 7]

        return data
            .lazy
            .reduce(Int.zero, {
                let validFourDigitsCount = $1
                    .split(separator: "|")
                    .last?
                    .components(separatedBy: CharacterSet.whitespaces)
                    .compactMap({ String($0) })
                    .filter({ filterLengths.contains($0.count) })
                    .count
                ?? .zero
                return $0 + validFourDigitsCount
            })
    }

    public func sumDecipheredNumbers() -> Int {
        guard let data = try? fileReader.lines() else {
            assertionFailure("data missing")
            return .zero
        }

        return data.reduce(Int.zero) { partialResult, line in
            let segmentNumbers = line
                .split(separator: "|")
                .first?
                .components(separatedBy: CharacterSet.whitespaces)
                .filter({ !$0.isEmpty })
            ?? []

            let displayedNumbers = line
                .split(separator: "|")
                .last?
                .components(separatedBy: CharacterSet.whitespaces)
                .filter({ !$0.isEmpty })
            ?? []

            print(segmentNumbers, displayedNumbers)

            let charMap = bruteForce(segmentNumbers: segmentNumbers)

            return partialResult
            + displayedNumbers
                .reduce(Int.zero) { partialResultNumber, number in
                    10 * partialResultNumber + segmentNumber(string: number, charMap: charMap)
                }
        }
    }

    func segmentNumber(string: String, charMap: [Character: Int]) -> Int {
        let binaryValue = string.reduce(.zero) { $0 + charMap[$1, default: .zero] }
        return binaryToNumberMap[binaryValue, default: .zero]
    }

    func bruteForce(segmentNumbers: [String]) -> [Character: Int] {
        let digitMap = digitMap(segmentNumbers: segmentNumbers)

        var result: [Character: Int] = [:]

        digitMap["a"]?.forEach { a in
            digitMap["b"]?.forEach { b in
                digitMap["c"]?.forEach { c in
                    digitMap["d"]?.forEach { d in
                        digitMap["e"]?.forEach { e in
                            digitMap["f"]?.forEach { f in
                                digitMap["g"]?.forEach { g in
                                    let charMap = [
                                        Character("a"): a,
                                        Character("b"): b,
                                        Character("c"): c,
                                        Character("d"): d,
                                        Character("e"): e,
                                        Character("f"): f,
                                        Character("g"): g,
                                    ]
                                    if validate(
                                        segmentNumbers: segmentNumbers,
                                        charMap: charMap
                                    ) {
                                        result = charMap
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        return result
    }

    func validate(segmentNumbers: [String], charMap: [Character: Int]) -> Bool {
        var result = true
        segmentNumbers.forEach { number in
            let possibleValues = lengthToValuesMap[number.count]
            let numberValue = number.reduce(Int.zero) { $0 + charMap[$1, default: .zero] }
            result = result && possibleValues?.contains(numberValue) ?? false
        }

        return result
    }

    func tryWithPairs() -> Int {
        let segmentNumbers = [ "be", "cfbegad", "cbdgef", "fgaecd", "cgeb", "fdcge", "agebfd", "fecdb", "fabcd", "edb" ]

        let displayedNumbers = [ "fdgacbe", "cefdb", "cefbgd", "gcbe" ]

        let digitPairMap = digitPairMap(segmentNumbers: segmentNumbers)
        print(digitPairMap)

        var totalSum = Int.zero
        displayedNumbers.forEach { number in
            var processedNumber = number
            var processedValue = Int.zero

            digitPairMap.forEach { (keys, values) in
                let keysSet = Set(keys)
                if keysSet.isSubset(of: processedNumber) {
                    processedNumber.removeAll(where: { keysSet.contains($0) })
                    processedValue += values.reduce(.zero, +)
                }
            }
            assert(processedNumber.isEmpty)
            totalSum += processedValue
        }

        return totalSum
    }

    func digitMap(segmentNumbers: [String]) -> [Character: [Int]] {
        let sortedSegmentNumbers = segmentNumbers
            .sorted { $0.count < $1.count }
            .map { $0.sorted() }

        var map = [Character: [Int]]()
        var processedSegmentNumbers = [[Character]: [Int]]()

        sortedSegmentNumbers.forEach { characters in
//            print("\n")
            var filteredCharacters = characters
            var filteredValues = lengthToWeightMap[characters.count] ?? []
//            print("Start: [\(filteredCharacters)] => [\(filteredValues)]")

            processedSegmentNumbers.forEach { item in
                let (key, value) = item

                guard key.count == value.count else { return }
//                print("keys: [\(key)] <=> values: [\(value)]")

                let valuesToRemove = Set(value)
                let charactersToRemove = key

                if valuesToRemove.isSubset(of: filteredValues) {
                    filteredCharacters.removeAll(where: { charactersToRemove.contains($0) })
                    filteredValues.removeAll(where: { valuesToRemove.contains($0) })
                }
            }

//            print("After processed values: [\(filteredCharacters)] => [\(filteredValues)]")

            if !filteredCharacters.isEmpty, !filteredValues.isEmpty {
                processedSegmentNumbers[filteredCharacters] = filteredValues
            }

            filteredCharacters.forEach { char in
                if let values = map[char], values.count < filteredValues.count {
//                    print("map contains [\(char)] with [\(values)], new ones [\(filteredValues)]")
                    return
                }

                map[char] = filteredValues
            }

//            print(processedSegmentNumbers)
//            print(map)
        }
//        print("\n")
//        print(map)

        return map
    }

    func digitPairMap(segmentNumbers: [String]) -> [[Character]: [Int]] {
        let sortedSegmentNumbers = segmentNumbers
            .sorted { $0.count < $1.count }
            .map { $0.sorted() }

        var processedSegmentNumbers = [[Character]: [Int]]()

        sortedSegmentNumbers.forEach { characters in
            var filteredCharacters = characters
            var filteredValues = lengthToWeightMap[characters.count] ?? []

            processedSegmentNumbers.forEach { item in
                let (key, value) = item

                guard key.count == value.count else { return }

                let valuesToRemove = Set(value)
                let charactersToRemove = key

                if valuesToRemove.isSubset(of: filteredValues) {
                    filteredCharacters.removeAll(where: { charactersToRemove.contains($0) })
                    filteredValues.removeAll(where: { valuesToRemove.contains($0) })
                }
            }

            if !filteredCharacters.isEmpty, !filteredValues.isEmpty {
                processedSegmentNumbers[filteredCharacters] = filteredValues
            }
        }

        return processedSegmentNumbers.filter { $0.key.count == $0.value.count }
    }
}
