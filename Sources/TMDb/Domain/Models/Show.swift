//
//  Show.swift
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
/// A model representing a show - movie or TV series.
///
public enum Show: Identifiable, Codable, Equatable, Hashable, Sendable {

    ///
    /// Show identifier.
    ///
    public var id: Int {
        switch self {
        case .movie(let movie):
            movie.id

        case .tvSeries(let tvSeries):
            tvSeries.id
        }
    }

    ///
    /// Show's popularity.
    ///
    var popularity: Double? {
        switch self {
        case .movie(let movie):
            movie.popularity

        case .tvSeries(let tvSeries):
            tvSeries.popularity
        }
    }

    ///
    /// Show's release or first air date.
    ///
    var date: Date? {
        switch self {
        case .movie(let movie):
            movie.releaseDate

        case .tvSeries(let tvSeries):
            tvSeries.firstAirDate
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

}

extension Show {

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
            self = try .movie(MovieListItem(from: decoder))

        case .tvSeries:
            self = try .tvSeries(TVSeriesListItem(from: decoder))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var singleContainer = encoder.singleValueContainer()

        switch self {
        case .movie(let movie):
            try singleContainer.encode(movie)

        case .tvSeries(let tvSeries):
            try singleContainer.encode(tvSeries)
        }
    }
}
