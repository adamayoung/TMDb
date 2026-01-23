//
//  KeywordMoviesRequestTests.swift
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

@Suite(.tags(.requests, .keyword))
struct KeywordMoviesRequestTests {

    @Test("path is correct")
    func path() {
        let request = KeywordMoviesRequest(id: 378)

        #expect(request.path == "/keyword/378/movies")
    }

    @Test("queryItems is empty when no parameters")
    func queryItemsIsEmptyWhenNoParameters() {
        let request = KeywordMoviesRequest(id: 378)

        #expect(request.queryItems.isEmpty)
    }

    @Test("queryItems with page")
    func queryItemsWithPage() {
        let request = KeywordMoviesRequest(id: 378, page: 2)

        #expect(request.queryItems == ["page": "2"])
    }

    @Test("queryItems with language")
    func queryItemsWithLanguage() {
        let request = KeywordMoviesRequest(id: 378, language: "en")

        #expect(request.queryItems == ["language": "en"])
    }

    @Test("queryItems with page and language")
    func queryItemsWithPageAndLanguage() {
        let request = KeywordMoviesRequest(id: 378, page: 3, language: "fr")

        #expect(request.queryItems == ["page": "3", "language": "fr"])
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = KeywordMoviesRequest(id: 378)

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = KeywordMoviesRequest(id: 378)

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = KeywordMoviesRequest(id: 378)

        #expect(request.body == nil)
    }

}
