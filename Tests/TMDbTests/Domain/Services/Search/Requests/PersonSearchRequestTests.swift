//
//  PersonSearchRequestTests.swift
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

@Suite(.tags(.requests, .search))
struct PersonSearchRequestTests {

    @Test("path is correct")
    func path() {
        let request = PersonSearchRequest(query: "")

        #expect(request.path == "/search/person")
    }

    @Test("queryItems with query")
    func queryItemsWithQuery() {
        let request = PersonSearchRequest(query: "edward norton")

        #expect(request.queryItems == ["query": "edward norton"])
    }

    @Test("queryItems with query and includeAdult")
    func queryItemsWithQueryAndIncludeAdult() {
        let request = PersonSearchRequest(query: "edward norton", includeAdult: true)

        #expect(request.queryItems == ["query": "edward norton", "include_adult": "true"])
    }

    @Test("queryItems with page")
    func queryItemsWithPage() {
        let request = PersonSearchRequest(query: "edward norton", page: 3)

        #expect(request.queryItems == ["query": "edward norton", "page": "3"])
    }

    @Test("queryItems with language")
    func queryItemsWithLanguage() {
        let request = PersonSearchRequest(query: "edward norton", language: "en")

        #expect(request.queryItems == ["query": "edward norton", "language": "en"])
    }

    @Test("queryItems with query, includeAdult, page and language")
    func queryItemsWithQueryAndIncludeAdultAndPageAndLanguage() {
        let request = PersonSearchRequest(
            query: "edward norton", includeAdult: false, page: 2, language: "en")

        #expect(
            request.queryItems == [
                "query": "edward norton",
                "include_adult": "false",
                "page": "2",
                "language": "en"
            ])
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = PersonSearchRequest(query: "")

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = PersonSearchRequest(query: "")

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = PersonSearchRequest(query: "")

        #expect(request.body == nil)
    }

}
