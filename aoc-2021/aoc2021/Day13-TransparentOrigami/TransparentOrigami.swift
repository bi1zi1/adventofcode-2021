import Foundation

public final class TransparentOrigami {
    private let fileReader: FileReader
    public init(measurementsFile: FileResource = .paperDotsData) {
        fileReader = FileReader(fileResource: measurementsFile)
    }

    public func visibleDotsFirstFold() -> Int {
        guard let data = try? fileReader.lines() else {
            assertionFailure("data missing")
            return .zero
        }

        let (points, folds) = parseData(data: data)
        let paper = Paper(points: points)

        guard let firstFold = folds.first else {
            return .zero
        }

        paper.fold(firstFold)

        return paper.dotsCount
    }

    func parseData(data: [String]) -> ([Point], [Fold]) {
        var parseFolds = false
        var points: [Point] = []
        var folds: [Fold] = []

        data.forEach { line in
            if line.isEmpty {
                parseFolds.toggle()
                return
            }

            if parseFolds {
                if let fold = Fold(
                    string: line.replacingOccurrences(of: "fold along ", with: "")
                ) {
                    folds.append(fold)
                }
                return
            }

            if let point = Point(string: line) {
                points.append(point)
            }
        }

        return (points, folds)
    }
}
