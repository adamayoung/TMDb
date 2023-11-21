//
//  Show.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

import Foundation

///
/// A model representing a show - movie or TV series.
///
public enum Show: Identifiable, Equatable, Hashable {

    ///
    /// Show identifier.
    ///
    public var id: Int {
        switch self {
        case let .movie(movie):
            return movie.id

        case let .tvSeries(tvSeries):
            return tvSeries.id
        }
    }

    ///
    /// Show's popularity.
    ///
    var popularity: Double? {
        switch self {
        case let .movie(movie):
            return movie.popularity

        case let .tvSeries(tvSeries):
            return tvSeries.popularity
        }
    }

    ///
    /// Show's release or first air date.
    ///
    var date: Date? {
        switch self {
        case let .movie(movie):
            return movie.releaseDate

        case let .tvSeries(tvSeries):
            return tvSeries.firstAirDate
        }
    }

    ///
    /// Movie.
    ///
    case movie(Movie)

    ///
    /// TV series.
    ///
    case tvSeries(TVSeries)

}

extension Show: Decodable {

    private enum CodingKeys: String, CodingKey {
        case mediaType
    }

    private enum MediaType: String, Decodable, Equatable {
        case movie
        case tvSeries = "tv"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let mediaType = try container.decode(MediaType.self, forKey: .mediaType)

        switch mediaType {
        case .movie:
            self = try .movie(Movie(from: decoder))

        case .tvSeries:
            self = try .tvSeries(TVSeries(from: decoder))
        }
    }

}
