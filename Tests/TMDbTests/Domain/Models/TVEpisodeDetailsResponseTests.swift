//
//  TVEpisodeDetailsResponseTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct TVEpisodeDetailsResponseTests {

    @Test("JSON decoding of TVEpisodeDetailsResponse", .tags(.decoding))
    func decodeTVEpisodeDetailsResponse() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TVEpisodeDetailsResponse.self,
            fromResource: "tv-episode-details-append-response"
        )

        #expect(result.episode.id == 63056)
        #expect(result.episode.name == "Winter Is Coming")
        #expect(result.episode.episodeNumber == 1)
        #expect(result.episode.seasonNumber == 1)

        let credits = try #require(result.credits)
        #expect(credits.id == 63056)
        #expect(!credits.cast.isEmpty)
        #expect(credits.cast[0].id == 22970)
        #expect(credits.cast[0].name == "Peter Dinklage")
        #expect(credits.cast[0].character == "Tyrion Lannister")
        #expect(!credits.crew.isEmpty)
        #expect(credits.crew[0].id == 44797)
        #expect(credits.crew[0].name == "Tim Van Patten")
        #expect(credits.crew[0].job == "Director")

        let images = try #require(result.images)
        #expect(images.id == 63056)
        #expect(!images.stills.isEmpty)

        let videos = try #require(result.videos)
        #expect(videos.id == 63056)
        #expect(!videos.results.isEmpty)

        let translations = try #require(result.translations)
        #expect(!translations.isEmpty)

        let externalIDs = try #require(result.externalIDs)
        #expect(externalIDs.id == 63056)
        #expect(externalIDs.imdb != nil)
    }

    @Test(
        "JSON decoding of TVEpisodeDetailsResponse without appended data",
        .tags(.decoding)
    )
    func decodeTVEpisodeDetailsResponseWithoutAppendedData() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TVEpisodeDetailsResponse.self,
            fromResource: "tv-episode"
        )

        #expect(result.episode.id == 63056)
        #expect(result.episode.name == "Winter Is Coming")
        #expect(result.episode.episodeNumber == 1)
        #expect(result.episode.seasonNumber == 1)
        #expect(result.credits == nil)
        #expect(result.images == nil)
        #expect(result.videos == nil)
        #expect(result.translations == nil)
        #expect(result.externalIDs == nil)
    }

}
