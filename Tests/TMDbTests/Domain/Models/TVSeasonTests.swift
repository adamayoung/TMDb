//
//  TVSeasonTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct TVSeasonTests {

    @Test("JSON decoding of TVSeason with empty air date returns nil air date", .tags(.decoding))
    func decodeWithEmptyAirDateReturnsNilAirDate() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TVSeason.self, fromResource: "tv-season-empty-air-date"
        )

        #expect(result.id == 3624)
        #expect(result.airDate == nil)
    }

    @Test("JSON decoding of TVSeason", .tags(.decoding))
    func decodeReturnsTVSeason() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TVSeason.self, fromResource: "tv-season"
        )

        #expect(result.id == tvSeason.id)
        #expect(result.name == tvSeason.name)
        #expect(result.seasonNumber == tvSeason.seasonNumber)
        #expect(result.overview == tvSeason.overview)
        #expect(result.airDate == tvSeason.airDate)
        #expect(result.posterPath == tvSeason.posterPath)
        #expect(result.episodes == tvSeason.episodes)
    }

    private let tvSeason = TVSeason(
        id: 3624,
        name: "Season 1",
        seasonNumber: 1,
        overview:
        // swiftlint:disable:next line_length
        "Trouble is brewing in the Seven Kingdoms of Westeros. For the driven inhabitants of this visionary world, control of Westeros' Iron Throne holds the lure of great power. But in a land where the seasons can last a lifetime, winter is coming...and beyond the Great Wall that protects them, an ancient evil has returned. In Season One, the story centers on three primary areas: the Stark and the Lannister families, whose designs on controlling the throne threaten a tenuous peace; the dragon princess Daenerys, heir to the former dynasty, who waits just over the Narrow Sea with her malevolent brother Viserys; and the Great Wall--a massive barrier of ice where a forgotten danger is stirring.",
        airDate: DateFormatter.theMovieDatabase.date(from: "2011-04-17"),
        posterPath: URL(string: "/zwaj4egrhnXOBIit1tyb4Sbt3KP.jpg"),
        episodes: nil
    )

}
