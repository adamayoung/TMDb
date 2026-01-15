//
//  CollectionImageCollectionTests.swift
//  TMDb
//
//  Copyright © 2025 Adam Young.
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
struct CollectionImageCollectionTests {

    @Test("JSON decoding of CollectionImageCollection", .tags(.decoding))
    func decodeReturnsCollectionImageCollection() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            CollectionImageCollection.self,
            fromResource: "collection-image-collection"
        )

        #expect(result.id == 10)
        #expect(result.backdrops.count == 2)
        #expect(result.backdrops[0].filePath == URL(string: "/itH1Wlzwf6yTNa7fVkYMVUwXlhR.jpg"))
        #expect(result.backdrops[0].width == 1920)
        #expect(result.backdrops[0].height == 1080)
        #expect(result.backdrops[0].aspectRatio == 1.778)
        #expect(result.backdrops[1].filePath == URL(string: "/qVPChlozQ1BP3svfHjiAdNneMGA.jpg"))
        #expect(result.posters.count == 2)
        #expect(result.posters[0].filePath == URL(string: "/6mHkagjziBPth2Mx0VpEercocm4.jpg"))
        #expect(result.posters[0].width == 1000)
        #expect(result.posters[0].height == 1500)
        #expect(result.posters[0].aspectRatio == 0.667)
        #expect(result.posters[1].filePath == URL(string: "/22dj38IckjzEEUZwN1tPU5VJ1qq.jpg"))
    }

}
