//
//  CollectionImagesRequestTests.swift
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

@Suite(.tags(.requests, .collection))
struct CollectionImagesRequestTests {

    @Test("path is correct")
    func path() {
        let request = CollectionImagesRequest(id: 10)

        #expect(request.path == "/collection/10/images")
    }

    @Test("queryItems is empty when no languages")
    func queryItemsIsEmptyWhenNoLanguages() {
        let request = CollectionImagesRequest(id: 10)

        #expect(request.queryItems.isEmpty)
    }

    @Test("queryItems contains include_image_language when languages provided")
    func queryItemsContainsIncludeImageLanguageWhenLanguagesProvided() {
        let request = CollectionImagesRequest(id: 10, languages: ["en", "fr"])

        #expect(request.queryItems == ["include_image_language": "en,fr,null"])
    }

    @Test("queryItems removes region from languages")
    func queryItemsRemovesRegionFromLanguages() {
        let request = CollectionImagesRequest(id: 10, languages: ["en-US", "fr-FR"])

        #expect(request.queryItems == ["include_image_language": "en,fr,null"])
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = CollectionImagesRequest(id: 10)

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = CollectionImagesRequest(id: 10)

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = CollectionImagesRequest(id: 10)

        #expect(request.body == nil)
    }

}
