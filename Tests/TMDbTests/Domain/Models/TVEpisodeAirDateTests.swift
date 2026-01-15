//
//  TVEpisodeAirDateTests.swift
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
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.models))
struct TVEpisodeAirDateTests {

    @Test("JSON decoding of TVEpisodeAirDate", .tags(.decoding))
    func decodeReturnsTVEpisodeAirDate() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TVEpisodeAirDate.self, fromResource: "tv-episode-air-date")

        #expect(result == tvEpisodeAirDate)
    }

    @Test("JSON decoding handles optional fields")
    func decodeHandlesOptionalFields() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TVEpisodeAirDate.self, fromResource: "tv-episode-air-date")

        #expect(result.episodeType == "finale")
        #expect(result.runtime == 56)
        #expect(result.overview != nil)
    }

}

extension TVEpisodeAirDateTests {

    private var tvEpisodeAirDate: TVEpisodeAirDate {
        .init(
            id: 62161,
            name: "Felina",
            episodeNumber: 16,
            seasonNumber: 5,
            overview: "All bad things must come to an end.",
            airDate: DateFormatter.theMovieDatabase.date(from: "2013-09-29"),
            episodeType: "finale",
            runtime: 56,
            showID: 1396,
            productionCode: "",
            stillPath: URL(string: "/pA0YwyhvdDXP3BEGL2grrIhq8aM.jpg"),
            voteAverage: 9.3,
            voteCount: 265
        )
    }

}
