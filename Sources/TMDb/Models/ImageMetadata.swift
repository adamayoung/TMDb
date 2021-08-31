import Foundation

/// Details describing an image.
public struct ImageMetadata: Identifiable, Decodable, Equatable, Hashable {

    public var id: URL { filePath }
    /// Path of the image.
    public let filePath: URL
    /// Image width.
    public let width: Int
    /// Image height.
    public let height: Int

    /// Creates a new `ImageMetadata`.
    ///
    /// - Parameters:
    ///    - filePath: Path of the image.
    ///    - width: Image width.
    ///    - height: Image height.
    public init(filePath: URL, width: Int, height: Int) {
        self.filePath = filePath
        self.width = width
        self.height = height
    }

}
