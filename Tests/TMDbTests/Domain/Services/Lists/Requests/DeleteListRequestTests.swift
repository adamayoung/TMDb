//
//  DeleteListRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
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
