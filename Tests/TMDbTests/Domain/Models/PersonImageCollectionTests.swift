//
//  PersonImageCollectionTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct PersonImageCollectionTests {

    @Test("JSON decoding of PersonImageCollection", .tags(.decoding))
    func decodeReturnsPersonImageCollection() throws {
        let personImageCollection = try PersonImageCollection(
            id: 66633,
            profiles: [
                ImageMetadata(
                    filePath: #require(URL(string: "/rLSUjr725ez1cK7SKVxC9udO03Y.jpg")),
                    width: 546,
                    height: 819,
                    aspectRatio: 0.666666666666667,
                    voteAverage: 7.21,
                    voteCount: 345
                ),
                ImageMetadata(
                    filePath: #require(URL(string: "/lYqC8Amj4owX05xQg5Yo7uUHgah.jpg")),
                    width: 2000,
                    height: 3000,
                    aspectRatio: 0.666666666666667,
                    voteAverage: 4.21,
                    voteCount: 3
                )
            ]
        )

        let result = try JSONDecoder.theMovieDatabase
            .decode(PersonImageCollection.self, fromResource: "person-image-collection")

        #expect(result.id == personImageCollection.id)
        #expect(result.profiles == personImageCollection.profiles)
    }

}
