import Foundation
import CoreImage

public final class HydrothermalDanger {
    private let formattedFileReader: FormattedFileReader
    public init(measurementsFile: FileResource = .hydrothermalLinesData) {
        self.formattedFileReader = FormattedFileReader(fileResource: measurementsFile)
    }

    public func dangerPointsCount() -> Int {
        let data = formattedFileReader.dataRows()
        var dangerPoints: [Point: Int] = [:]

        data.forEach { row in
            let lineItems = lineItems(from: row, useDiagonal: false)
            lineItems.forEach {
                dangerPoints[$0] = (dangerPoints[$0] ?? .zero) + 1
            }
        }

        return dangerPoints.reduce(.zero) { $1.value < 2 ? $0 : $0 + 1 }
    }

    public func dangerPointsWithDiagonalCount() -> Int {
        let data = formattedFileReader.dataRows()
        var dangerPoints: [Point: Int] = [:]

        data.forEach { row in
            let lineItems = lineItems(from: row, useDiagonal: true)
            lineItems.forEach {
                dangerPoints[$0] = (dangerPoints[$0] ?? .zero) + 1
            }
        }

        return dangerPoints.reduce(.zero) { $1.value < 2 ? $0 : $0 + 1 }
    }

    func lineItems(from row: Row, useDiagonal: Bool) -> [Point] {
        let typeVentLine = row.columns[0].type
        let rawValueVentLine = row.columns[0].rawValue
        guard let ventLine: VentLine = typeVentLine.value(from: rawValueVentLine) else { return [] }

        return ventLine.lineItems(useDiagonal: useDiagonal)
    }
}
