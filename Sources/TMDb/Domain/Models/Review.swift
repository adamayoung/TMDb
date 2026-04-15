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
    /// Author details of the review.
    ///
    public let authorDetails: ReviewAuthorDetails?

    ///
    /// URL of the review.
    ///
    public let url: URL?

    ///
    /// Date the review was created.
    ///
    public let createdAt: Date?

    ///
    /// Date the review was last updated.
    ///
    public let updatedAt: Date?

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
    ///    - authorDetails: Author details of the review.
    ///    - url: URL of the review.
    ///    - createdAt: Date the review was created.
    ///    - updatedAt: Date the review was last updated.
    ///
    public init(
        id: String,
        author: String,
        content: String,
        languageCode: String? = nil,
        mediaID: Int? = nil,
        mediaTitle: String? = nil,
        mediaType: String? = nil,
        authorDetails: ReviewAuthorDetails? = nil,
        url: URL? = nil,
        createdAt: Date? = nil,
        updatedAt: Date? = nil
    ) {
        self.id = id
        self.author = author
        self.content = content
        self.languageCode = languageCode
        self.mediaID = mediaID
        self.mediaTitle = mediaTitle
        self.mediaType = mediaType
        self.authorDetails = authorDetails
        self.url = url
        self.createdAt = createdAt
        self.updatedAt = updatedAt
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
        case authorDetails
        case url
        case createdAt
        case updatedAt
    }

    private nonisolated(unsafe) static let iso8601Formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withInternetDateTime, .withFractionalSeconds
        ]
        return formatter
    }()

    ///
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// - Parameter decoder: The decoder to read data from.
    ///
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)
        self.author = try container.decode(String.self, forKey: .author)
        self.content = try container.decode(String.self, forKey: .content)
        self.languageCode = try container.decodeIfPresent(
            String.self, forKey: .languageCode
        )
        self.mediaID = try container.decodeIfPresent(Int.self, forKey: .mediaID)
        self.mediaTitle = try container.decodeIfPresent(
            String.self, forKey: .mediaTitle
        )
        self.mediaType = try container.decodeIfPresent(
            String.self, forKey: .mediaType
        )
        self.authorDetails = try container.decodeIfPresent(
            ReviewAuthorDetails.self, forKey: .authorDetails
        )
        self.url = try container.decodeIfPresent(URL.self, forKey: .url)

        if let createdAtString = try container.decodeIfPresent(
            String.self, forKey: .createdAt
        ) {
            self.createdAt = Self.iso8601Formatter.date(
                from: createdAtString
            )
        } else {
            self.createdAt = nil
        }

        if let updatedAtString = try container.decodeIfPresent(
            String.self, forKey: .updatedAt
        ) {
            self.updatedAt = Self.iso8601Formatter.date(
                from: updatedAtString
            )
        } else {
            self.updatedAt = nil
        }
    }

}
