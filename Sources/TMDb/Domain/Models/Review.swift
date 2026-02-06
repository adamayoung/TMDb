//
//  Review.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a review.
///
public struct Review: Identifiable, Codable, Equatable, Hashable,
Sendable {

    ///
    /// Review identifier.
    ///
    public let id: String

    ///
    /// Author of the review.
    ///
    public let author: String

    ///
    /// Review content.
    ///
    public let content: String

    ///
    /// ISO 639-1 language code.
    ///
    public let languageCode: String?

    ///
    /// Media identifier.
    ///
    public let mediaID: Int?

    ///
    /// Media title.
    ///
    public let mediaTitle: String?

    ///
    /// Media type.
    ///
    public let mediaType: String?

    ///
    /// URL of the review.
    ///
    public let url: URL?

    ///
    /// Creates a review object.
    ///
    /// - Parameters:
    ///    - id: Review identifier.
    ///    - author: Author of the review.
    ///    - content: Review content.
    ///    - languageCode: ISO 639-1 language code.
    ///    - mediaID: Media identifier.
    ///    - mediaTitle: Media title.
    ///    - mediaType: Media type.
    ///    - url: URL of the review.
    ///
    public init(
        id: String,
        author: String,
        content: String,
        languageCode: String? = nil,
        mediaID: Int? = nil,
        mediaTitle: String? = nil,
        mediaType: String? = nil,
        url: URL? = nil
    ) {
        self.id = id
        self.author = author
        self.content = content
        self.languageCode = languageCode
        self.mediaID = mediaID
        self.mediaTitle = mediaTitle
        self.mediaType = mediaType
        self.url = url
    }

}

extension Review {

    private enum CodingKeys: String, CodingKey {
        case id
        case author
        case content
        case languageCode = "iso6391"
        case mediaID = "mediaId"
        case mediaTitle
        case mediaType
        case url
    }

}
