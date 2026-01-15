//
//  TVSeriesCrewCredit.swift
//  TMDb
//
//  Copyright © 2025 Adam Young.
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
/// A model representing a TV series crew credit.
///
/// Combines TV series metadata with crew-specific credit information such as
/// job title and department.
///
public struct TVSeriesCrewCredit: Identifiable, Codable, Equatable, Hashable, Sendable {

    ///
    /// TV series identifier.
    ///
    public let id: Int

    ///
    /// TV series name.
    ///
    public let name: String

    ///
    /// Original TV series name.
    ///
    public let originalName: String

    ///
    /// Original language of the TV series.
    ///
    public let originalLanguage: String

    ///
    /// TV series overview.
    ///
    public let overview: String

    ///
    /// TV series genre identifiers.
    ///
    public let genreIDs: [Genre.ID]

    ///
    /// TV series' first air date.
    ///
    public let firstAirDate: Date?

    ///
    /// TV series countries of origin.
    ///
    public let originCountries: [String]

    ///
    /// TV series poster path.
    ///
    /// To generate a full URL see <doc:/TMDb/GeneratingImageURLs>.
    ///
    public let posterPath: URL?

    ///
    /// TV series backdrop path.
    ///
    /// To generate a full URL see <doc:/TMDb/GeneratingImageURLs>.
    ///
    public let backdropPath: URL?

    ///
    /// TV series current popularity.
    ///
    public let popularity: Double?

    ///
    /// Average vote score.
    ///
    public let voteAverage: Double?

    ///
    /// Number of votes.
    ///
    public let voteCount: Int?

    ///
    /// Is the TV series only suitable for adults.
    ///
    public let isAdultOnly: Bool?

    ///
    /// Number of episodes the person worked on.
    ///
    public let episodeCount: Int?

    ///
    /// Job title of the person in this TV series.
    ///
    public let job: String

    ///
    /// Department the person worked in for this TV series.
    ///
    public let department: String

    ///
    /// Credit identifier for this particular TV series role.
    ///
    public let creditID: String

    ///
    /// Creates a TV series crew credit object.
    ///
    /// - Parameters:
    ///    - id: TV series identifier.
    ///    - name: TV series name.
    ///    - originalName: Original TV series name.
    ///    - originalLanguage: Original language of the TV series.
    ///    - overview: TV series overview.
    ///    - genreIDs: TV series genre identifiers.
    ///    - firstAirDate: TV series's first air date.
    ///    - originCountries: TV series countries of origin.
    ///    - posterPath: TV series poster path.
    ///    - backdropPath: TV series backdrop path.
    ///    - popularity: TV series current popularity.
    ///    - voteAverage: Average vote score.
    ///    - voteCount: Number of votes.
    ///    - isAdultOnly: Is the TV series only suitable for adults.
    ///    - episodeCount: Number of episodes the person worked on.
    ///    - job: Job title of the person.
    ///    - department: Department the person worked in.
    ///    - creditID: Credit identifier for this role.
    ///
    public init(
        id: Int,
        name: String,
        originalName: String,
        originalLanguage: String,
        overview: String,
        genreIDs: [Genre.ID],
        firstAirDate: Date? = nil,
        originCountries: [String],
        posterPath: URL? = nil,
        backdropPath: URL? = nil,
        popularity: Double? = nil,
        voteAverage: Double? = nil,
        voteCount: Int? = nil,
        isAdultOnly: Bool? = nil,
        episodeCount: Int? = nil,
        job: String,
        department: String,
        creditID: String
    ) {
        self.id = id
        self.name = name
        self.originalName = originalName
        self.originalLanguage = originalLanguage
        self.overview = overview
        self.genreIDs = genreIDs
        self.firstAirDate = firstAirDate
        self.originCountries = originCountries
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.popularity = popularity
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.isAdultOnly = isAdultOnly
        self.episodeCount = episodeCount
        self.job = job
        self.department = department
        self.creditID = creditID
    }

}

extension TVSeriesCrewCredit {

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case originalName
        case originalLanguage
        case overview
        case genreIDs = "genreIds"
        case firstAirDate
        case originCountries = "originCountry"
        case posterPath
        case backdropPath
        case popularity
        case voteAverage
        case voteCount
        case isAdultOnly = "adult"
        case episodeCount
        case job
        case department
        case creditID = "creditId"
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
    ///   is not convertible to the requested type.
    /// - Throws: `DecodingError.keyNotFound` if self does not have an entry
    ///   for the given key.
    /// - Throws: `DecodingError.valueNotFound` if self has a null entry for
    ///   the given key.
    ///
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let container2 = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.originalName = try container.decode(String.self, forKey: .originalName)
        self.originalLanguage = try container.decode(String.self, forKey: .originalLanguage)
        self.overview = try container.decode(String.self, forKey: .overview)
        self.genreIDs = try container.decode([Genre.ID].self, forKey: .genreIDs)

        // Need to deal with empty strings - date decoding will fail with an empty string
        let firstAirDateString = try container.decodeIfPresent(String.self, forKey: .firstAirDate)
        self.firstAirDate = try {
            guard let firstAirDateString, !firstAirDateString.isEmpty else {
                return nil
            }

            return try container2.decodeIfPresent(Date.self, forKey: .firstAirDate)
        }()

        self.originCountries = try container.decode([String].self, forKey: .originCountries)
        self.posterPath = try container.decodeIfPresent(URL.self, forKey: .posterPath)
        self.backdropPath = try container.decodeIfPresent(URL.self, forKey: .backdropPath)
        self.popularity = try container.decodeIfPresent(Double.self, forKey: .popularity)
        self.voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage)
        self.voteCount = try container.decodeIfPresent(Int.self, forKey: .voteCount)
        self.isAdultOnly = try container.decodeIfPresent(Bool.self, forKey: .isAdultOnly)

        self.episodeCount = try container.decodeIfPresent(Int.self, forKey: .episodeCount)
        self.job = try container.decode(String.self, forKey: .job)
        self.department = try container.decode(String.self, forKey: .department)
        self.creditID = try container.decode(String.self, forKey: .creditID)
    }

}
