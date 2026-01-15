//
//  DeleteListRequestTests.swift
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
struct DeleteListRequestTests {

    @Test("path is correct")
    func path() {
        let request = DeleteListRequest(listID: 1234, sessionID: "abc123")

        #expect(request.path == "/list/1234")
    }

    @Test("queryItems contains session_id")
    func queryItemsContainsSessionID() {
        let request = DeleteListRequest(listID: 1234, sessionID: "abc123")

        #expect(request.queryItems == ["session_id": "abc123"])
    }

    @Test("method is DELETE")
    func methodIsDelete() {
        let request = DeleteListRequest(listID: 1234, sessionID: "abc123")

        #expect(request.method == .delete)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = DeleteListRequest(listID: 1234, sessionID: "abc123")

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = DeleteListRequest(listID: 1234, sessionID: "abc123")

        #expect(request.body == nil)
    }

}
