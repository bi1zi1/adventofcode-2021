import Foundation

final class FileReader {
    enum Errors: Error {
        case fileMissing(String)
    }
    private let fileManager = FileManager.default
    private let filename: String?
    private let `extension`: String?
    private let bundle: Bundle

    init(filename: String?, extension: String?) {
        self.filename = filename
        self.extension = `extension`
        bundle = Bundle(for: type(of: self))
    }
    

    func lines() throws -> [String] {
        guard let file = bundle.url(forResource: filename, withExtension: `extension`) else {
            throw Errors.fileMissing("\(filename ?? .empty).\(`extension` ?? .empty) could not be found.")
        }

        let text = try String(contentsOf: file, encoding: .utf8)
        let lines = text.components(separatedBy: CharacterSet.whitespacesAndNewlines)

        return lines;
    }
}

extension FileReader {
    convenience init(fileResource: FileResource) {
        self.init(filename: fileResource.filename, extension: fileResource.extension)
    }
}
