//
//  PersonCombinedCreditsRequestTests.swift
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

@Suite(.tags(.requests, .people))
struct PersonCombinedCreditsRequestTests {

    @Test("path is correct")
    func path() {
        let request = PersonCombinedCreditsRequest(id: 1)

        #expect(request.path == "/person/1/combined_credits")
    }

    @Test("queryItems is empty")
    func queryItemsIsEmpty() {
        let request = PersonCombinedCreditsRequest(id: 1)

        #expect(request.queryItems.isEmpty)
    }

    @Test("queryItems with language")
    func queryItemsWithLanguage() {
        let request = PersonCombinedCreditsRequest(id: 1, language: "en")

        #expect(request.queryItems == ["language": "en"])
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = PersonCombinedCreditsRequest(id: 1)

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = PersonCombinedCreditsRequest(id: 1)

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = PersonCombinedCreditsRequest(id: 1)

        #expect(request.body == nil)
    }

}
