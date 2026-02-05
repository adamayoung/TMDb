//
//  TaggedImageTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct TaggedImageTests {

    @Test("JSON decoding of TaggedImage with movie media", .tags(.decoding))
    func decodeWithMovieMediaReturnsTaggedImage() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TaggedImage.self, fromResource: "tagged-image"
        )

        #expect(result.id == "59164af592514156f50269b6")
        #expect(result.aspectRatio == 0.667)
        #expect(result.filePath.path().contains("iOpi3ut5DhQIbrVVjlnmfy2U7dI.jpg"))
        #expect(result.height == 3000)
        #expect(result.width == 2000)
        let languageCode = try #require(result.languageCode)
        #expect(languageCode == "en")
        let countryCode = try #require(result.countryCode)
        #expect(countryCode == "US")
        #expect(result.voteAverage == 6.5)
        #expect(result.voteCount == 19)
        #expect(result.imageType == "poster")
        #expect(result.media.id == 437_342)

        guard case .movie(let movie) = result.media else {
            Issue.record("Expected movie media type")
            return
        }
        #expect(movie.title == "The First Omen")
    }

    @Test(
        "JSON decoding of TaggedImage with TV episode media",
        .tags(.decoding)
    )
    func decodeWithTVEpisodeMediaReturnsTaggedImage() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TaggedImage.self,
            fromResource: "tagged-image-tv-episode"
        )

        #expect(result.id == "55862d0bc3a368336500170a")
        #expect(result.aspectRatio == 1.778)
        #expect(result.imageType == "still")
        #expect(result.media.id == 1_062_838)

        guard case .tvEpisode(let episode) = result.media else {
            Issue.record("Expected tvEpisode media type")
            return
        }
        #expect(episode.name == "Pilot")
        #expect(episode.episodeNumber == 1)
        #expect(episode.seasonNumber == 1)
    }

}
