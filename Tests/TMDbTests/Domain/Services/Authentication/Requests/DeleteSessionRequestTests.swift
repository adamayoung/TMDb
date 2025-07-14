//
//  DeleteSessionRequestTests.swift
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

@Suite(.tags(.requests, .authentication))
struct DeleteSessionRequestTests {

    var request: DeleteSessionRequest!

    init() {
        self.request = DeleteSessionRequest(sessionID: "qwerty")
    }

    @Test("path is correct")
    func path() {
        #expect(request.path == "/authentication/session")
    }

    @Test("queryItems is empty")
    func queryItemsIsEmpty() {
        #expect(request.queryItems.isEmpty)
    }

    @Test("method is POST")
    func methodIsPost() {
        #expect(request.method == .delete)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        #expect(request.headers.isEmpty)
    }

    @Test("body contains sessionID")
    func bodyContainsSessionID() throws {
        let body = try #require(request.body)

        #expect(body.sessionID == "qwerty")
    }

}
