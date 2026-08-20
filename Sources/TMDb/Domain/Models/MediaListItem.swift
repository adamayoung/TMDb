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
    /// A TV series arrives from TMDb as `name` rather than `title`; both decode
    /// into this property, so a caller does not have to branch on ``mediaType``.
    ///
    public let title: String

    ///
    /// Original title.
    ///
    /// A TV series arrives from TMDb as `original_name` rather than
    /// `original_title`; both decode into this property.
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
    /// A movie's `release_date`, or a TV series' `first_air_date`.
    ///
    /// Empty strings are decoded as `nil`, as are strings this cannot parse as a
    /// calendar day. A trailing time component is accepted and ignored.
    ///
    /// Midnight GMT on the day TMDb reports.
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

public extension MediaListItem {

    private enum CodingKeys: String, CodingKey {
        case id
        case mediaType
        case title
        case name
        case originalTitle
        case originalName
        case originalLanguage
        case overview
        case genreIDs = "genreIds"
        case releaseDate
        case firstAirDate
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
    /// A list holds movies and TV series together, and TMDb gives each shape its
    /// own keys: a movie carries `title`, `original_title` and `release_date`,
    /// while a TV series carries `name`, `original_name` and `first_air_date`.
    /// Both decode into ``title``, ``originalTitle`` and ``releaseDate``, so a
    /// caller never has to branch on ``mediaType``.
    ///
    /// Empty date strings decode as `nil`, as do strings this cannot parse as a
    /// calendar day. A trailing time component is accepted and ignored.
    ///
    /// - Parameter decoder: The decoder to read data from.
    ///
    /// - Throws: An error if decoding fails.
    ///
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Int.self, forKey: .id)

        let mediaType = try container.decodeMediaType(ShowType.self, forKey: .mediaType)
        // A list item's field shape depends on its media type, so one this
        // library does not model cannot be decoded at all — unlike a value enum,
        // where `.unknown` is a usable result.
        guard mediaType != .unknown else {
            throw DecodingError.unknownMediaType(
                rawValue: ShowType.unknown.rawValue,
                codingPath: container.codingPath + [CodingKeys.mediaType]
            )
        }
        self.mediaType = mediaType

        self.title = try container.decodeIfPresent(
            String.self, forKey: .title
        ) ?? container.decode(String.self, forKey: .name)
        self.originalTitle = try container.decodeIfPresent(
            String.self, forKey: .originalTitle
        ) ?? container.decode(String.self, forKey: .originalName)
        self.originalLanguage = try container.decode(String.self, forKey: .originalLanguage)
        self.overview = try container.decode(String.self, forKey: .overview)
        // Some results omit `genre_ids` entirely; default to an empty array
        // rather than failing to decode.
        self.genreIDs = try container.decodeIfPresent([Genre.ID].self, forKey: .genreIDs) ?? []
        self.posterPath = try container.decodeIfPresent(URL.self, forKey: .posterPath)
        self.backdropPath = try container.decodeIfPresent(URL.self, forKey: .backdropPath)
        self.popularity = try container.decodeIfPresent(Double.self, forKey: .popularity)
        self.voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage)
        self.voteCount = try container.decodeIfPresent(Int.self, forKey: .voteCount)
        self.hasVideo = try container.decodeIfPresent(Bool.self, forKey: .hasVideo)
        self.isAdultOnly = try container.decodeIfPresent(Bool.self, forKey: .isAdultOnly)

        // Handle empty release_date strings - decode as nil.
        // Day-precision dates (e.g. "2025-04-30") are parsed at GMT midnight; an
        // unparseable string decodes as nil, per the decode-tolerance policy
        // (ADR-0019). A TV series sends `first_air_date` in place of
        // `release_date`.
        //
        // This keeps its own `.iso8601` strategy rather than sharing
        // `JSONDecoder.theMovieDatabaseDateStrategy`, and the difference is
        // deliberate: `Date.ParseStrategy` is *lenient*, rolling out-of-range
        // components over ("2025-13-45" -> 2026-02-14, "0000-00-00" ->
        // -0001-11-30), while `.iso8601` rejects them. Behind the `try?` above,
        // sharing the strategy would silently turn a malformed date into a
        // plausible wrong one instead of nil. Both already parse at GMT, so the
        // divergence costs nothing. Measured in `MediaListItemDateToleranceTests`.
        let dateString = try container.decodeIfPresent(
            String.self, forKey: .releaseDate
        ) ?? container.decodeIfPresent(String.self, forKey: .firstAirDate)

        if let dateString, !dateString.isEmpty {
            self.releaseDate = try? Date(
                dateString,
                strategy: .iso8601.year().month().day().dateSeparator(.dash)
            )
        } else {
            self.releaseDate = nil
        }
    }

    ///
    /// Encodes this value into the given encoder.
    ///
    /// Both media shapes encode through the movie-style ``title``,
    /// ``originalTitle`` and ``releaseDate`` keys — the same choice
    /// ``CollectionListItem`` makes for the same two-shape input — so the output
    /// is one consistent shape rather than one that depends on ``mediaType``.
    ///
    /// - Parameter encoder: The encoder to write data to.
    ///
    /// - Throws: An error if encoding fails.
    ///
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(mediaType, forKey: .mediaType)
        try container.encode(title, forKey: .title)
        try container.encode(originalTitle, forKey: .originalTitle)
        try container.encode(originalLanguage, forKey: .originalLanguage)
        try container.encode(overview, forKey: .overview)
        try container.encode(genreIDs, forKey: .genreIDs)
        try container.encodeIfPresent(releaseDate, forKey: .releaseDate)
        try container.encodeIfPresent(posterPath, forKey: .posterPath)
        try container.encodeIfPresent(backdropPath, forKey: .backdropPath)
        try container.encodeIfPresent(popularity, forKey: .popularity)
        try container.encodeIfPresent(voteAverage, forKey: .voteAverage)
        try container.encodeIfPresent(voteCount, forKey: .voteCount)
        try container.encodeIfPresent(hasVideo, forKey: .hasVideo)
        try container.encodeIfPresent(isAdultOnly, forKey: .isAdultOnly)
    }

}
