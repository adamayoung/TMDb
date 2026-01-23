//
//  MediaListItem.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing an item in a media list.
///
/// Supports both movies and TV shows.
///
public struct MediaListItem: Identifiable, Codable, Equatable, Hashable, Sendable {

    ///
    /// Media identifier.
    ///
    public let id: Int

    ///
    /// Media type (movie or TV series).
    ///
    public let mediaType: ShowType

    ///
    /// Title.
    ///
    public let title: String

    ///
    /// Original title.
    ///
    public let originalTitle: String

    ///
    /// Original language.
    ///
    public let originalLanguage: String

    ///
    /// Overview.
    ///
    public let overview: String

    ///
    /// Genre identifiers.
    ///
    public let genreIDs: [Genre.ID]

    ///
    /// Release date.
    ///
    /// Empty strings are decoded as `nil`.
    ///
    public let releaseDate: Date?

    ///
    /// Poster path.
    ///
    public let posterPath: URL?

    ///
    /// Backdrop path.
    ///
    public let backdropPath: URL?

    ///
    /// Popularity score.
    ///
    public let popularity: Double?

    ///
    /// Vote average.
    ///
    public let voteAverage: Double?

    ///
    /// Vote count.
    ///
    public let voteCount: Int?

    ///
    /// Whether the media has video.
    ///
    public let hasVideo: Bool?

    ///
    /// Whether the media is adult-only.
    ///
    public let isAdultOnly: Bool?

    ///
    /// Creates a media list item object.
    ///
    /// - Parameters:
    ///    - id: Media identifier.
    ///    - mediaType: Media type (movie or TV series).
    ///    - title: Title.
    ///    - originalTitle: Original title.
    ///    - originalLanguage: Original language.
    ///    - overview: Overview.
    ///    - genreIDs: Genre identifiers.
    ///    - releaseDate: Release date.
    ///    - posterPath: Poster path.
    ///    - backdropPath: Backdrop path.
    ///    - popularity: Popularity score.
    ///    - voteAverage: Vote average.
    ///    - voteCount: Vote count.
    ///    - hasVideo: Whether the media has video.
    ///    - isAdultOnly: Whether the media is adult-only.
    ///
    public init(
        id: Int,
        mediaType: ShowType,
        title: String,
        originalTitle: String,
        originalLanguage: String,
        overview: String,
        genreIDs: [Genre.ID],
        releaseDate: Date? = nil,
        posterPath: URL? = nil,
        backdropPath: URL? = nil,
        popularity: Double? = nil,
        voteAverage: Double? = nil,
        voteCount: Int? = nil,
        hasVideo: Bool? = nil,
        isAdultOnly: Bool? = nil
    ) {
        self.id = id
        self.mediaType = mediaType
        self.title = title
        self.originalTitle = originalTitle
        self.originalLanguage = originalLanguage
        self.overview = overview
        self.genreIDs = genreIDs
        self.releaseDate = releaseDate
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.popularity = popularity
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.hasVideo = hasVideo
        self.isAdultOnly = isAdultOnly
    }

}

extension MediaListItem {

    private enum CodingKeys: String, CodingKey {
        case id
        case mediaType
        case title
        case originalTitle
        case originalLanguage
        case overview
        case genreIDs = "genreIds"
        case releaseDate
        case posterPath
        case backdropPath
        case popularity
        case voteAverage
        case voteCount
        case hasVideo = "video"
        case isAdultOnly = "adult"
    }

    ///
    /// Creates a media list item from a decoder.
    ///
    /// Handles empty `release_date` strings by decoding them as `nil`.
    ///
    /// - Parameter decoder: The decoder to read data from.
    ///
    /// - Throws: An error if decoding fails.
    ///
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Int.self, forKey: .id)
        self.mediaType = try container.decode(ShowType.self, forKey: .mediaType)
        self.title = try container.decode(String.self, forKey: .title)
        self.originalTitle = try container.decode(String.self, forKey: .originalTitle)
        self.originalLanguage = try container.decode(String.self, forKey: .originalLanguage)
        self.overview = try container.decode(String.self, forKey: .overview)
        self.genreIDs = try container.decode([Genre.ID].self, forKey: .genreIDs)
        self.posterPath = try container.decodeIfPresent(URL.self, forKey: .posterPath)
        self.backdropPath = try container.decodeIfPresent(URL.self, forKey: .backdropPath)
        self.popularity = try container.decodeIfPresent(Double.self, forKey: .popularity)
        self.voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage)
        self.voteCount = try container.decodeIfPresent(Int.self, forKey: .voteCount)
        self.hasVideo = try container.decodeIfPresent(Bool.self, forKey: .hasVideo)
        self.isAdultOnly = try container.decodeIfPresent(Bool.self, forKey: .isAdultOnly)

        // Handle empty release_date strings - decode as nil
        if let releaseDateString = try container.decodeIfPresent(String.self, forKey: .releaseDate),
           !releaseDateString.isEmpty {
            let dateFormatter = ISO8601DateFormatter()
            dateFormatter.formatOptions = [.withFullDate]
            self.releaseDate = dateFormatter.date(from: releaseDateString)
        } else {
            self.releaseDate = nil
        }
    }

}
