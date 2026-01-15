//
//  CollectionTests.swift
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
struct CollectionTests {

    @Test("JSON decoding of Collection", .tags(.decoding))
    func decodeReturnsCollection() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            Collection.self,
            fromResource: "collection"
        )

        #expect(result.id == 10)
        #expect(result.name == "Star Wars Collection")
        #expect(result.originalName == "Star Wars Collection")
        #expect(result.originalLanguage == "en")
        #expect(
            result.overview
                == "An epic space-opera theatrical film series, which depicts the adventures of various characters \"a long time ago in a galaxy far, far away….\""
        )
        #expect(result.posterPath == URL(string: "/22dj38IckjzEEUZwN1tPU5VJ1qq.jpg"))
        #expect(result.backdropPath == URL(string: "/qVPChlozQ1BP3svfHjiAdNneMGA.jpg"))
        #expect(result.parts.count == 2)
        #expect(result.parts[0].id == 11)
        #expect(result.parts[0].title == "Star Wars")
        #expect(result.parts[1].id == 1891)
        #expect(result.parts[1].title == "The Empire Strikes Back")
    }

}
