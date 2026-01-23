//
//  ImageMetadataTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.models))
struct ImageMetadataTests {

    var imageMetadata: ImageMetadata!

    init() throws {
        self.imageMetadata = try ImageMetadata(
            filePath: #require(URL(string: "/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg")),
            width: 1280,
            height: 720,
            aspectRatio: 1.77777777777778,
            voteAverage: 5.7,
            voteCount: 957,
            languageCode: "en"
        )
    }

    @Test("ID and filePath matches")
    func iDReturnsFilePath() {
        #expect(imageMetadata.id == imageMetadata.filePath)
    }

    @Test("JSON decoding of ImageMetadata", .tags(.decoding))
    func decodeReturnsImageMetadata() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            ImageMetadata.self, fromResource: "image-metadata"
        )

        #expect(result.filePath == imageMetadata.filePath)
        #expect(result.width == imageMetadata.width)
        #expect(result.height == imageMetadata.height)
        #expect(result.aspectRatio == imageMetadata.aspectRatio)
        #expect(result.voteAverage == imageMetadata.voteAverage)
        #expect(result.voteCount == imageMetadata.voteCount)
        #expect(result.languageCode == imageMetadata.languageCode)
    }

}
