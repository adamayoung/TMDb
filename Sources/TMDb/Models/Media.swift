//
//  Media.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

import Foundation

///
/// A model representing a media.
///
public enum Media: Identifiable, Codable, Equatable, Hashable {

    ///
    /// Media's identifier.
    ///
    public var id: Int {
        switch self {
        case let .movie(movie):
            return movie.id

        case let .tvSeries(tvSeries):
            return tvSeries.id

        case let .person(person):
            return person.id
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

    ///
    /// Person.
    ///
    case person(Person)

}

extension Media {

    private enum CodingKeys: String, CodingKey {
        case mediaType
    }

    private enum MediaType: String, Decodable, Equatable {
        case movie
        case tvSeries = "tv"
        case person
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let mediaType = try container.decode(MediaType.self, forKey: .mediaType)

        switch mediaType {
        case .movie:
            self = try .movie(Movie(from: decoder))

        case .tvSeries:
            self = try .tvSeries(TVSeries(from: decoder))

        case .person:
            self = try .person(Person(from: decoder))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var singleContainer = encoder.singleValueContainer()

        switch self {
        case let .movie(movie):
            try singleContainer.encode(movie)

        case let .tvSeries(tvSeries):
            try singleContainer.encode(tvSeries)

        case let .person(person):
            try singleContainer.encode(person)
        }
    }

}
