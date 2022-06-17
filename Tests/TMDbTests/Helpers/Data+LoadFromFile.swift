import Foundation

extension Data {

    init(fromResource fileName: String, withExtension fileType: String) throws {
        guard let filePath = Bundle.module.url(forResource: fileName, withExtension: fileType) else {
            throw LoadDataError.fileNotFound(fileName: fileName, fileType: fileType)
        }

        try self.init(contentsOf: filePath)
    }

}

enum LoadDataError: Error {

    case fileNotFound(fileName: String, fileType: String)

}
