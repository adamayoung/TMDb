import Foundation

public struct ImageMetadataDTO: Identifiable, Decodable, Equatable {

    public let filePath: URL
    public let width: Int
    public let height: Int

    public var id: URL {
        filePath
    }

    public init(filePath: URL, width: Int, height: Int) {
        self.filePath = filePath
        self.width = width
        self.height = height
    }

}
