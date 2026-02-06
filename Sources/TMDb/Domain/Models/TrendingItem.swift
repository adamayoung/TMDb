//
//  TrendingItem.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a trending item, which can be a movie, TV series, or person.
///
public enum TrendingItem: Identifiable, Codable, Equatable, Hashable, Sendable {

    ///
    /// Trending item's identifier.
    ///
    public var id: Int {
        switch self {
        case .movie(let movie):
            movie.id

        case .tvSeries(let tvSeries):
            tvSeries.id

        case .person(let person):
            person.id
        }
    }

    ///
    /// A trending movie.
    ///
    case movie(MovieListItem)

    ///
    /// A trending TV series.
    ///
    case tvSeries(TVSeriesListItem)

    ///
    /// A trending person.
    ///
    case person(PersonListItem)

}

extension TrendingItem {

    private enum CodingKeys: String, CodingKey {
        case mediaType
    }

    private enum MediaType: String, Codable, Equatable {
        case movie
        case tvSeries = "tv"
        case person
    }

    ///
    /// Creates a new instance by decoding from the given decoder.
    ///
    /// This initializer throws an error if reading from the decoder fails, or
    /// if the data read is corrupted or otherwise invalid.
    ///
    /// - Parameter decoder: The decoder to read data from.
    ///
    /// - Throws: `DecodingError.typeMismatch` if the encountered encoded value
    /// is not convertible to the requested type.
    /// - Throws: `DecodingError.keyNotFound` if self does not have an entry
    /// for the given key.
    /// - Throws: `DecodingError.valueNotFound` if self has a null entry for
    /// the given key.
    ///
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let mediaType = try container.decode(MediaType.self, forKey: .mediaType)

        switch mediaType {
        case .movie:
            self = try .movie(MovieListItem(from: decoder))

        case .tvSeries:
            self = try .tvSeries(TVSeriesListItem(from: decoder))

        case .person:
            self = try .person(PersonListItem(from: decoder))
        }
    }

    ///
    /// Encodes this value into the given encoder.
    ///
    /// If the value fails to encode anything, `encoder` will encode an empty
    /// keyed container in its place.
    ///
    /// This function throws an error if any values are invalid for the given
    /// encoder's format.
    ///
    /// - Parameter encoder: The encoder to write data to.
    ///
    /// - Throws: `EncodingError.invalidValue` if the given value is invalid in
    ///   the current context for this format.
    ///
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .movie(let movie):
            try container.encode(MediaType.movie, forKey: .mediaType)
            try movie.encode(to: encoder)

        case .tvSeries(let tvSeries):
            try container.encode(MediaType.tvSeries, forKey: .mediaType)
            try tvSeries.encode(to: encoder)

        case .person(let person):
            try container.encode(MediaType.person, forKey: .mediaType)
            try person.encode(to: encoder)
        }
    }

}
