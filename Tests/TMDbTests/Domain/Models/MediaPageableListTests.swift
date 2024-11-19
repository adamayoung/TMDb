//
//  MediaPageableListTests.swift
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
struct MediaPageableListTests {

    @Test("JSON decoding of MediaPageableList", .tags(.decoding))
    func decodeReturnsMediaPageableList() throws {
        let result = try JSONDecoder.theMovieDatabase
            .decode(MediaPageableList.self, fromResource: "media-pageable-list")

        #expect(result.page == list.page)
        #expect(result.results == list.results)
        #expect(result.totalResults == list.totalResults)
        #expect(result.totalPages == list.totalPages)
    }

    private let list = MediaPageableList(
        page: 1,
        results: [
            .movie(.theFirstOmen),
            .tvSeries(.bigBrother),
            .person(Person(id: 51329, name: "Bradley Cooper", gender: .unknown))
        ],
        totalResults: 3,
        totalPages: 1
    )

}
