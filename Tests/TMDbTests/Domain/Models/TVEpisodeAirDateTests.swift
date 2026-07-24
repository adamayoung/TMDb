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
        #expect(result.runtime == .seconds(56 * 60))
        #expect(result.overview != nil)
    }

    @Test("JSON decoding handles missing showId", .tags(.decoding))
    func decodeHandlesMissingShowID() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TVEpisodeAirDate.self,
            fromResource: "tv-episode-air-date-without-show-id"
        )

        #expect(result.id == 62161)
        #expect(result.name == "Felina")
        #expect(result.showID == nil)
    }

    @Test("runtime is nil when absent from the response", .tags(.decoding))
    func decodeWhenRuntimeAbsentReturnsNilRuntime() throws {
        let json = Data(#"{"id": 1, "name": "Ep", "episode_number": 1, "season_number": 1}"#.utf8)

        let result = try JSONDecoder.theMovieDatabase.decode(TVEpisodeAirDate.self, from: json)

        #expect(result.runtime == nil)
    }

    @Test("encoding represents runtime as integer minutes")
    func encodeRepresentsRuntimeAsIntegerMinutes() throws {
        let airDate = TVEpisodeAirDate(
            id: 1, name: "Ep", episodeNumber: 1, seasonNumber: 1, runtime: .seconds(56 * 60)
        )

        let data = try JSONEncoder().encode(airDate)
        let json = try #require(JSONSerialization.jsonObject(with: data) as? [String: Any])

        #expect(json["runtime"] as? Int == 56)
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
            runtime: .seconds(56 * 60),
            showID: 1396,
            productionCode: "",
            stillPath: URL(string: "/pA0YwyhvdDXP3BEGL2grrIhq8aM.jpg"),
            voteAverage: 9.3,
            voteCount: 265
        )
    }

}
