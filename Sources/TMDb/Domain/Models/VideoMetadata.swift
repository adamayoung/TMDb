//
//  VideoMetadata.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing details of a video.
///
public struct VideoMetadata: Identifiable, Codable, Equatable, Hashable, Sendable {

    ///
    /// Video identifier.
    ///
    public let id: String

    ///
    /// Video name.
    ///
    public let name: String

    ///
    /// Site which the video is from.
    ///
    public let site: String

    ///
    /// Site's video identifier.
    ///
    public let key: String

    ///
    /// Video type.
    ///
    public let type: VideoType

    ///
    /// Video size.
    ///
    public let size: VideoSize

    ///
    /// Whether this is an official video.
    ///
    public let official: Bool

    ///
    /// Date the video was published.
    ///
    public let publishedAt: Date

    ///
    /// Creates a video metadata object.
    ///
    /// - Parameters:
    ///    - id: Video identifier.
    ///    - name: Video name.
    ///    - site: Site which the video is from.
    ///    - key: Site's video identifier.
    ///    - type: Video type.
    ///    - size: Video size.
    ///    - official: Whether this is an official video.
    ///    - publishedAt: Date the video was published.
    ///
    public init(
        id: String,
        name: String,
        site: String,
        key: String,
        type: VideoType,
        size: VideoSize,
        official: Bool,
        publishedAt: Date
    ) {
        self.id = id
        self.name = name
        self.site = site
        self.key = key
        self.type = type
        self.size = size
        self.official = official
        self.publishedAt = publishedAt
    }

}

extension VideoMetadata {

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case site
        case key
        case type
        case size
        case official
        case publishedAt
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.site = try container.decode(String.self, forKey: .site)
        self.key = try container.decode(String.self, forKey: .key)
        self.type = try container.decode(VideoType.self, forKey: .type)
        self.size = try container.decode(VideoSize.self, forKey: .size)
        self.official = try container.decode(Bool.self, forKey: .official)

        let publishedAtString = try container.decode(String.self, forKey: .publishedAt)
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        guard let publishedAtDate = formatter.date(from: publishedAtString) else {
            throw DecodingError.dataCorruptedError(
                forKey: .publishedAt,
                in: container,
                debugDescription:
                "Date string does not match ISO8601 format: \(publishedAtString)"
            )
        }
        self.publishedAt = publishedAtDate
    }

}
