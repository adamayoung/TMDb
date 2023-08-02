import Foundation

///
/// A model representing image metadata.
///
public struct ImageMetadata: Identifiable, Codable, Equatable, Hashable {

    ///
    /// Image metadata's identifier (same as `filePath`).
    ///
    public var id: URL { filePath }

    ///
    /// Path of the image.
    ///
    /// To generate a full URL see <doc:/TMDb/GeneratingImageURLs>.
    ///
    public let filePath: URL

    ///
    /// Image width.
    ///
    public let width: Int

    ///
    /// Image height.
    ///
    public let height: Int

    ///
    /// Aspect ratio.
    ///
    public let aspectRatio: Float

    ///
    /// ISO 639-1 language code.
    ///
    public let languageCode: String?

    ///
    /// The average of user votes on this image.
    ///
    public let voteAverage: Float?

    ///
    /// The number of user votes on this image.
    ///
    public let voteCount: Int?

    ///
    /// Creates an image metadata object.
    ///
    /// - Parameters:
    ///    - filePath: Path of the image.
    ///    - width: Image width.
    ///    - height: Image height.
    ///    - languageCode: ISO 639-1 language code.
    ///    - voteAverage: The average of user votes on this image.
    ///    - voteCount: The number of user votes on this image.
    ///
    public init(
        filePath: URL,
        width: Int,
        height: Int,
        aspectRatio: Float,
        voteAverage: Float?,
        voteCount: Int?,
        languageCode: String? = nil
    ) {
        self.filePath = filePath
        self.width = width
        self.height = height
        self.aspectRatio = aspectRatio
        self.languageCode = languageCode
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }

}

extension ImageMetadata {

    private enum CodingKeys: String, CodingKey {
        case filePath
        case width
        case height
        case aspectRatio
        case languageCode = "iso6391"
        case voteAverage
        case voteCount
    }

}
