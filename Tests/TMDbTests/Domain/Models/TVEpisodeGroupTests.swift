//
//  TVEpisodeGroupTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models, .tvEpisodeGroup))
struct TVEpisodeGroupTests {

    @Test(
        "JSON decoding of TVEpisodeGroup",
        .tags(.decoding)
    )
    func decodeTVEpisodeGroup() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TVEpisodeGroup.self,
            fromResource: "tv-episode-group"
        )

        #expect(
            result.id == "5acf93e60e0a26346d0000ce"
        )
        #expect(result.name == "Netflix Collections")
        #expect(result.episodeCount == 83)
        #expect(result.groupCount == 6)
        #expect(result.type == 4)
        #expect(result.network?.id == 213)
        #expect(result.network?.name == "Netflix")

        let groups = try #require(result.groups)
        #expect(groups.isEmpty == false)

        let firstGroup = try #require(groups.first)
        #expect(
            firstGroup.id == "5acf93efc3a368739a0000a9"
        )
        #expect(firstGroup.name == "First Cup")
        #expect(firstGroup.order == 1)
        #expect(firstGroup.locked == true)

        let episodes = try #require(firstGroup.episodes)
        #expect(episodes.isEmpty == false)

        let firstEpisode = try #require(episodes.first)
        #expect(firstEpisode.id == 1_078_262)
    }

}
