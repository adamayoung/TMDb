//
//  ImageCollectionTests.swift
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
struct ImageCollectionTests {

    @Test("JSON decoding of ImageCollection", .tags(.decoding))
    func decodeImageCollection() throws {
        let imageCollection = try imageCollection()

        let result = try JSONDecoder.theMovieDatabase.decode(
            ImageCollection.self, fromResource: "image-collection")

        #expect(result.id == imageCollection.id)
        #expect(result.backdrops == imageCollection.backdrops)
        #expect(result.logos == imageCollection.logos)
        #expect(result.posters == imageCollection.posters)
    }

    // swift-format-ignore: NeverForceUnwrap
    private func imageCollection() throws -> ImageCollection {
        try ImageCollection(
            id: 550,
            posters: [
                ImageMetadata(
                    filePath: #require(URL(string: "/fpemzjF623QVTe98pCVlwwtFC5N.jpg")),
                    width: 1200,
                    height: 1800,
                    aspectRatio: 0.666666666666667,
                    voteAverage: 5.21,
                    voteCount: 3,
                    languageCode: "en"
                )
            ],
            logos: [
                ImageMetadata(
                    filePath: #require(URL(string: "/fasasakfRaCRCTh8GqN30f8oyQF.jpg")),
                    width: 100,
                    height: 400,
                    aspectRatio: 2.5,
                    voteAverage: 5.31,
                    voteCount: 345,
                    languageCode: nil
                )
            ],
            backdrops: [
                ImageMetadata(
                    filePath: #require(URL(string: "/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg")),
                    width: 1280,
                    height: 720,
                    aspectRatio: 1.77777777777778,
                    voteAverage: 1.21,
                    voteCount: 435,
                    languageCode: nil
                )
            ]
        )
    }

}
