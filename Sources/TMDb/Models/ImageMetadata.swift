import Foundation

public struct ImageMetadata: Identifiable, Decodable, Equatable {

    public var id: URL { filePath }
    public let filePath: URL
    public let width: Int
    public let height: Int

    public init(filePath: URL, width: Int, height: Int) {
        self.filePath = filePath
        self.width = width
        self.height = height
    }

}
