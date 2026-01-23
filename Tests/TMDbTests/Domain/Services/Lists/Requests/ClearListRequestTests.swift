//
//  ClearListRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.requests, .list))
struct ClearListRequestTests {

    @Test("path is correct")
    func path() {
        let request = ClearListRequest(listID: 1234, sessionID: "abc123")

        #expect(request.path == "/list/1234/clear")
    }

    @Test("queryItems contains session_id")
    func queryItemsContainsSessionID() {
        let request = ClearListRequest(listID: 1234, sessionID: "abc123")

        #expect(request.queryItems == ["session_id": "abc123"])
    }

    @Test("method is POST")
    func methodIsPost() {
        let request = ClearListRequest(listID: 1234, sessionID: "abc123")

        #expect(request.method == .post)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = ClearListRequest(listID: 1234, sessionID: "abc123")

        #expect(request.headers.isEmpty)
    }

    @Test("body contains confirm true")
    func bodyContainsConfirmTrue() throws {
        let request = ClearListRequest(listID: 1234, sessionID: "abc123")

        let body = try #require(request.body)

        #expect(body.confirm == true)
    }

}
