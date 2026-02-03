//
//  TVEpisodeImageCollectionTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct TVEpisodeImageCollectionTests {

    @Test("JSON decoding of TVEpisodeImageCollection", .tags(.decoding))
    func decodeReturnsImageCollection() throws {
        let episodeImageCollection = try TVEpisodeImageCollection(
            id: 66633,
            stills: [
                ImageMetadata(
                    filePath: #require(URL(string: "/rLSUjr725ez1cK7SKVxC9udO03Y.jpg")),
                    width: 1920,
                    height: 1080,
                    aspectRatio: 1.77778,
                    voteAverage: 5.3125,
                    voteCount: 1,
                    languageCode: nil
                )
            ]
        )

        let result = try JSONDecoder.theMovieDatabase.decode(
            TVEpisodeImageCollection.self,
            fromResource: "tv-episode-image-collection"
        )

        #expect(result.id == episodeImageCollection.id)
        #expect(result.stills == episodeImageCollection.stills)
    }

}
