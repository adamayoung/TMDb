//
//  ImageMetadataTests.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
    func testIDReturnsFilePath() {
        #expect(imageMetadata.id == imageMetadata.filePath)
    }

    @Test("JSON decoding of ImageMetadata", .tags(.decoding))
    func testDecodeReturnsImageMetadata() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            ImageMetadata.self, fromResource: "image-metadata")

        #expect(result.filePath == imageMetadata.filePath)
        #expect(result.width == imageMetadata.width)
        #expect(result.height == imageMetadata.height)
        #expect(result.aspectRatio == imageMetadata.aspectRatio)
        #expect(result.voteAverage == imageMetadata.voteAverage)
        #expect(result.voteCount == imageMetadata.voteCount)
        #expect(result.languageCode == imageMetadata.languageCode)
    }

}
