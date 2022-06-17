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
    /// Aspect ratio.
    public let aspectRatio: Float
    /// ISO 639-1 language code.
    public let languageCode: String?

    /// Creates a new `ImageMetadata`.
    ///
    /// - Parameters:
    ///    - filePath: Path of the image.
    ///    - width: Image width.
    ///    - height: Image height.
    ///    - languageCode: ISO 639-1 language code.
    public init(filePath: URL, width: Int, height: Int, aspectRatio: Float, languageCode: String? = nil) {
        self.filePath = filePath
        self.width = width
        self.height = height
        self.aspectRatio = aspectRatio
        self.languageCode = languageCode
    }

}

extension ImageMetadata {

    private enum CodingKeys: String, CodingKey {
        case filePath
        case width
        case height
        case aspectRatio
        case languageCode = "iso6391"
    }

}
