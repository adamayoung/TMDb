//
//  DiscoverTVSeriesRequestTests.swift
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
struct DiscoverTVSeriesRequestTests {

    @Test("path is correct")
    func path() {
        let request = DiscoverTVSeriesRequest()

        #expect(request.path == "/discover/tv")
    }

    @Test("queryItems is empty")
    func queryItemsIsEmpty() {
        let request = DiscoverTVSeriesRequest()

        #expect(request.queryItems.isEmpty)
    }

    @Test("queryItems with sortedBy")
    func queryItemsWithSortedBy() {
        let request = DiscoverTVSeriesRequest(sortedBy: .firstAirDate(descending: false))

        #expect(request.queryItems == ["sort_by": "first_air_date.asc"])
    }

    @Test("queryItems with page")
    func queryItemsWithPage() throws {
        let request = DiscoverTVSeriesRequest(page: 1)

        #expect(request.queryItems == ["page": "1"])
    }

    @Test("queryItems with language")
    func queryItemsWithLanguage() {
        let request = DiscoverMoviesRequest(language: "en")

        #expect(request.queryItems == ["language": "en"])
    }

    @Test("queryItems with sortedBy, page and language")
    func queryItemsWithSortedByAndPageAndLanguage() {
        let request = DiscoverTVSeriesRequest(
            sortedBy: .firstAirDate(descending: false),
            page: 2,
            language: "en"
        )

        #expect(
            request.queryItems == [
                "sort_by": "first_air_date.asc",
                "page": "2",
                "language": "en",
            ])
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = DiscoverTVSeriesRequest()

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = DiscoverTVSeriesRequest()

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = DiscoverTVSeriesRequest()

        #expect(request.body == nil)
    }

}
