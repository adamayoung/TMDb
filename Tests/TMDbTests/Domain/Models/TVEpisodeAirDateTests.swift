//
//  TVEpisodeAirDateTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct TVEpisodeAirDateTests {

    @Test("JSON decoding of TVEpisodeAirDate", .tags(.decoding))
    func decodeReturnsTVEpisodeAirDate() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TVEpisodeAirDate.self, fromResource: "tv-episode-air-date"
        )

        #expect(result == tvEpisodeAirDate)
    }

    @Test("JSON decoding handles optional fields")
    func decodeHandlesOptionalFields() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TVEpisodeAirDate.self, fromResource: "tv-episode-air-date"
        )

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
