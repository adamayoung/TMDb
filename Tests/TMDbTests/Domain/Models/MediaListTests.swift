//
//  MediaListTests.swift
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
struct MediaListTests {

    @Test("JSON decoding of MediaList", .tags(.decoding))
    func decodeReturnsMediaList() throws {
        let json = """
            {
              "created_by": "Travis Bell",
              "description": "The idea behind this list is to collect the live action comic book movies.",
              "favorite_count": 0,
              "id": 1,
              "iso_639_1": "en",
              "item_count": 69,
              "items": [],
              "name": "The Marvel Universe",
              "page": 1,
              "poster_path": "/coJVIUEOToAEGViuhclM7pXC75R.jpg",
              "total_pages": 4,
              "total_results": 69
            }
            """

        let data = Data(json.utf8)
        let result = try JSONDecoder.theMovieDatabase.decode(MediaList.self, from: data)

        #expect(result.id == 1)
        #expect(result.name == "The Marvel Universe")
        #expect(result.description != nil)
        #expect(result.createdBy == "Travis Bell")
        #expect(result.iso6391 == "en")
        #expect(result.itemCount == 69)
        #expect(result.favoriteCount == 0)
        #expect(result.posterPath?.absoluteString == "/coJVIUEOToAEGViuhclM7pXC75R.jpg")
        #expect(result.items.count == 0)
        #expect(result.page == 1)
        #expect(result.totalPages == 4)
        #expect(result.totalResults == 69)
    }

}
