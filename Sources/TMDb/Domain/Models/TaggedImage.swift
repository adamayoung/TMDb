//
//  TaggedImage.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a tagged image for a person.
///
public struct TaggedImage: Identifiable, Codable, Equatable, Hashable,
Sendable {

    ///
    /// Tagged image identifier.
    ///
    public let id: String

    ///
    /// Aspect ratio of the image.
    ///
    public let aspectRatio: Double

    ///
    /// File path of the image.
    ///
    /// To generate a full URL see <doc:/TMDb/GeneratingImageURLs>.
    ///
    public let filePath: URL

    ///
    /// Height of the image in pixels.
    ///
    public let height: Int

    ///
    /// Width of the image in pixels.
    ///
    public let width: Int

    ///
    /// ISO 639-1 language code.
    ///
    public let languageCode: String?

    ///
    /// ISO 3166-1 country code.
    ///
    public let countryCode: String?

    ///
    /// Average vote score for the image.
    ///
    public let voteAverage: Double

    ///
    /// Number of votes for the image.
    ///
    public let voteCount: Int

    ///
    /// The type of image.
    ///
    public let imageType: String

    ///
    /// The media item associated with the tagged image.
    ///
    public let media: TaggedImageMedia

    ///
    /// Creates a tagged image object.
    ///
    /// - Parameters:
    ///    - id: Tagged image identifier.
    ///    - aspectRatio: Aspect ratio of the image.
    ///    - filePath: File path of the image.
    ///    - height: Height of the image in pixels.
    ///    - width: Width of the image in pixels.
    ///    - languageCode: ISO 639-1 language code.
    ///    - countryCode: ISO 3166-1 country code.
    ///    - voteAverage: Average vote score for the image.
    ///    - voteCount: Number of votes for the image.
    ///    - imageType: The type of image.
    ///    - media: The media item associated with the image.
    ///
    public init(
        id: String,
        aspectRatio: Double,
        filePath: URL,
        height: Int,
        width: Int,
        languageCode: String? = nil,
        countryCode: String? = nil,
        voteAverage: Double,
        voteCount: Int,
        imageType: String,
        media: TaggedImageMedia
    ) {
        self.id = id
        self.aspectRatio = aspectRatio
        self.filePath = filePath
        self.height = height
        self.width = width
        self.languageCode = languageCode
        self.countryCode = countryCode
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.imageType = imageType
        self.media = media
    }

}

extension TaggedImage {

    private enum CodingKeys: String, CodingKey {
        case id
        case aspectRatio
        case filePath
        case height
        case width
        case languageCode = "iso6391"
        case countryCode = "iso31661"
        case voteAverage
        case voteCount
        case imageType
        case media
    }

}
