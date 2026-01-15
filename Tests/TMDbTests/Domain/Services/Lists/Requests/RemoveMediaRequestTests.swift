//
//  RemoveMediaRequestTests.swift
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

@Suite(.tags(.requests, .list))
struct RemoveMediaRequestTests {

    @Test("path is correct")
    func path() {
        let request = RemoveMediaRequest(mediaID: 550, listID: 1234, sessionID: "abc123")

        #expect(request.path == "/list/1234/remove_item")
    }

    @Test("queryItems contains session_id")
    func queryItemsContainsSessionID() {
        let request = RemoveMediaRequest(mediaID: 550, listID: 1234, sessionID: "abc123")

        #expect(request.queryItems == ["session_id": "abc123"])
    }

    @Test("method is POST")
    func methodIsPost() {
        let request = RemoveMediaRequest(mediaID: 550, listID: 1234, sessionID: "abc123")

        #expect(request.method == .post)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = RemoveMediaRequest(mediaID: 550, listID: 1234, sessionID: "abc123")

        #expect(request.headers.isEmpty)
    }

    @Test("body contains media_id")
    func bodyContainsMediaID() throws {
        let request = RemoveMediaRequest(mediaID: 550, listID: 1234, sessionID: "abc123")

        let body = try #require(request.body)

        #expect(body.mediaID == 550)
    }

    @Test("body encoding uses correct CodingKeys")
    func bodyEncodingUsesCorrectCodingKeys() throws {
        let bodyValue = RemoveMediaRequest.Body(mediaID: 550)

        let encoder = JSONEncoder()
        let data = try encoder.encode(bodyValue)
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]

        #expect(json?["mediaId"] as? Int == 550)
    }

}
