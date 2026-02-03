//
//  TVSeasonImageCollectionTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models, .decoding))
struct TVSeasonImageCollectionTests {

    @Test("JSON decoding of TVSeasonImageCollection")
    func decodeReturnsTVSeasonImageCollection() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TVSeasonImageCollection.self,
            fromResource: "tv-season-image-collection"
        )

        #expect(result.id == tvSeasonImageCollection.id)
        #expect(result.posters == tvSeasonImageCollection.posters)
    }

}

extension TVSeasonImageCollectionTests {

    private var tvSeasonImageCollection: TVSeasonImageCollection {
        TVSeasonImageCollection(
            id: 3624,
            posters: [
                ImageMetadata(
                    filePath: URL(string: "/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg")!,
                    width: 1280,
                    height: 720,
                    aspectRatio: 1.77777777777778,
                    voteAverage: 5.7,
                    voteCount: 957,
                    languageCode: "en"
                )
            ]
        )
    }

}
