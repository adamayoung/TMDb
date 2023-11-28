//
//  MediaPageableListTests.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
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

final class MediaPageableListTests: XCTestCase {

    func testDecodeReturnsMediaPageableList() throws {
        let result = try JSONDecoder.theMovieDatabase
            .decode(MediaPageableList.self, fromResource: "media-pageable-list")

        XCTAssertEqual(result.page, list.page)
        XCTAssertEqual(result.results, list.results)
        XCTAssertEqual(result.totalResults, list.totalResults)
        XCTAssertEqual(result.totalPages, list.totalPages)
    }

    private let list = MediaPageableList(
        page: 1,
        results: [
            .movie(Movie(id: 1, title: "Fight Club")),
            .tvSeries(TVSeries(id: 2, name: "The Mrs Bradley Mysteries")),
            .person(Person(id: 51329, name: "Bradley Cooper", gender: .unknown))
        ],
        totalResults: 3,
        totalPages: 1
    )

}
