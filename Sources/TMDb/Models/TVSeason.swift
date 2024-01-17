//
//  TVSeason.swift
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
/// A model representing a TV season.
///
public struct TVSeason: Identifiable, Codable, Equatable, Hashable {

    ///
    /// TV season identifier.
    ///
    public let id: Int

    ///
    /// TV season name.
    ///
    public let name: String

    ///
    /// TV season number.
    ///
    public let seasonNumber: Int

    ///
    /// Overview of TV season.
    ///
    public let overview: String?

    ///
    /// TV season's air date.
    ///
    public let airDate: Date?

    ///
    /// TV season's poster path.
    ///
    /// To generate a full URL see <doc:/TMDb/GeneratingImageURLs>.
    ///
    public let posterPath: URL?

    ///
    /// Episodes in this TV season.
    ///
    public let episodes: [TVEpisode]?

    ///
    /// Creates a TV season object.
    ///
    /// - Parameters:
    ///    - id: TV season identifier.
    ///    - name: TV season name.
    ///    - seasonNumber: TV season number.
    ///    - overview: Overview of TV season.
    ///    - airDate: TV season's air date.
    ///    - posterPath: TV season's poster path.
    ///    - episodes: Episodes in this TV season.
    ///
    public init(
        id: Int,
        name: String,
        seasonNumber: Int,
        overview: String? = nil,
        airDate: Date? = nil,
        posterPath: URL? = nil,
        episodes: [TVEpisode]? = nil
    ) {
        self.id = id
        self.name = name
        self.seasonNumber = seasonNumber
        self.overview = overview
        self.airDate = airDate
        self.posterPath = posterPath
        self.episodes = episodes
    }

}
