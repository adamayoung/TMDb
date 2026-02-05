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

    @Test("JSON decoding of TaggedImage", .tags(.decoding))
    func decodeReturnsTaggedImage() throws {
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
    }

}
