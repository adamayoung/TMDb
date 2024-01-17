//
//  TVEpisodeImageCollectionTests.swift
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

@testable import TMDb
import XCTest

final class TVEpisodeImageCollectionTests: XCTestCase {

    func testDecodeReturnsImageCollection() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            TVEpisodeImageCollection.self,
            fromResource: "tv-episode-image-collection"
        )

        XCTAssertEqual(result.id, episodeImageCollection.id)
        XCTAssertEqual(result.stills, episodeImageCollection.stills)
    }

    private let episodeImageCollection = TVEpisodeImageCollection(
        id: 66633,
        stills: [
            ImageMetadata(
                filePath: URL(string: "/rLSUjr725ez1cK7SKVxC9udO03Y.jpg")!,
                width: 1920,
                height: 1080,
                aspectRatio: 1.77778,
                voteAverage: 5.3125,
                voteCount: 1,
                languageCode: nil
            )
        ]
    )

}
