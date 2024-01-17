//
//  Media.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
            movie.id

        case let .tvSeries(tvSeries):
            tvSeries.id

        case let .person(person):
            person.id
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

    private enum MediaType: String, Codable, Equatable {
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
