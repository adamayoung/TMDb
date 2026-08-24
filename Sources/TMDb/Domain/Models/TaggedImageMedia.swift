//
//  TaggedImageMedia.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing the media associated with a tagged image.
///
/// A tagged image can be associated with a movie, with a whole TV series, with
/// a single season of one, with a single TV episode, or with a movie
/// collection. TMDb occasionally tags an image with a media type this library
/// does not model; such an image is skipped while decoding a page rather than
/// failing the whole page.
///
public enum TaggedImageMedia: Identifiable, Codable, Equatable, Hashable,
Sendable {

    ///
    /// Media's identifier.
    ///
    /// This is always the identifier of the media the image is tagged against,
    /// which for ``tvSeason(_:)`` is the **season's** identifier rather than
    /// its parent series'. Use ``TVSeason/showID`` to reach the series.
    ///
    public var id: Int {
        switch self {
        case .movie(let movie):
            movie.id

        case .tvSeries(let tvSeries):
            tvSeries.id

        case .tvSeason(let tvSeason):
            tvSeason.id

        case .tvEpisode(let tvEpisode):
            tvEpisode.id

        case .collection(let collection):
            collection.id
        }
    }

    ///
    /// Movie.
    ///
    case movie(MovieListItem)

    ///
    /// TV series.
    ///
    case tvSeries(TVSeriesListItem)

    ///
    /// A single season of a TV series.
    ///
    case tvSeason(TVSeason)

    ///
    /// TV episode.
    ///
    case tvEpisode(TVEpisode)

    ///
    /// Movie collection.
    ///
    case collection(CollectionListItem)

}

extension TaggedImageMedia {

    private enum CodingKeys: String, CodingKey {
        case mediaType
    }

    private enum MediaType: String, Codable, Equatable {
        case movie
        case tvSeries = "tv"
        case tvSeason = "tv_season"
        case tvEpisode = "tv_episode"
        case collection
    }

    ///
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// - Parameter decoder: The decoder to read data from.
    ///
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let mediaType = try container.decodeMediaType(
            MediaType.self,
            forKey: .mediaType
        )

        switch mediaType {
        case .movie:
            self = try .movie(MovieListItem(from: decoder))

        case .tvSeries:
            self = try .tvSeries(TVSeriesListItem(from: decoder))

        case .tvSeason:
            self = try .tvSeason(TVSeason(from: decoder))

        case .tvEpisode:
            self = try .tvEpisode(TVEpisode(from: decoder))

        case .collection:
            self = try .collection(CollectionListItem(from: decoder))
        }
    }

    ///
    /// Encodes this value into the given encoder.
    ///
    /// - Parameter encoder: The encoder to write data to.
    ///
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .movie(let movie):
            try container.encode(MediaType.movie, forKey: .mediaType)
            try movie.encode(to: encoder)

        case .tvSeries(let tvSeries):
            try container.encode(
                MediaType.tvSeries,
                forKey: .mediaType
            )
            try tvSeries.encode(to: encoder)

        case .tvSeason(let tvSeason):
            try container.encode(
                MediaType.tvSeason,
                forKey: .mediaType
            )
            try tvSeason.encode(to: encoder)

        case .tvEpisode(let tvEpisode):
            try container.encode(
                MediaType.tvEpisode,
                forKey: .mediaType
            )
            try tvEpisode.encode(to: encoder)

        case .collection(let collection):
            try container.encode(
                MediaType.collection,
                forKey: .mediaType
            )
            try collection.encode(to: encoder)
        }
    }

}
