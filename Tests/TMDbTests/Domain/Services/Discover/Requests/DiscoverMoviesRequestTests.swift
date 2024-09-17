//
//  DiscoverMoviesRequestTests.swift
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

@Suite(.tags(.requests, .discover))
struct DiscoverMoviesRequestTests {

    @Test("path is correct")
    func path() {
        let request = DiscoverMoviesRequest()

        #expect(request.path == "/discover/movie")
    }

    @Test("queryItems is empty")
    func queryItemsIsEmpty() {
        let request = DiscoverMoviesRequest()

        #expect(request.queryItems.isEmpty)
    }

    @Test("queryItems with people")
    func queryItemsWithPeople() {
        let request = DiscoverMoviesRequest(people: [1, 2, 3])

        #expect(request.queryItems == ["with_people": "1,2,3"])
    }

    @Test("queryItems with sortedBy")
    func queryItemsWithSortedBy() {
        let request = DiscoverMoviesRequest(sortedBy: .originalTitle(descending: false))

        #expect(request.queryItems == ["sort_by": "original_title.asc"])
    }

    @Test("queryItems with page")
    func queryItemsWithPage() {
        let request = DiscoverMoviesRequest(page: 1)

        #expect(request.queryItems == ["page": "1"])
    }

    @Test("queryItems with language")
    func queryItemsWithLanguage() {
        let request = DiscoverMoviesRequest(language: "en")

        #expect(request.queryItems == ["language": "en"])
    }

    @Test("queryItems with sortedBy, people, page and language")
    func queryItemsWithSortedByAndPeopleAndPageAndLanguage() {
        let request = DiscoverMoviesRequest(
            people: [1, 2, 3],
            sortedBy: .originalTitle(descending: false),
            page: 2,
            language: "en"
        )

        #expect(request.queryItems == [
            "sort_by": "original_title.asc",
            "with_people": "1,2,3",
            "page": "2",
            "language": "en"
        ])
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = DiscoverMoviesRequest()

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = DiscoverMoviesRequest()

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = DiscoverMoviesRequest()

        #expect(request.body == nil)
    }

}
