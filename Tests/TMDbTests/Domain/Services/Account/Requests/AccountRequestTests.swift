//
//  AccountRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.requests, .account))
struct AccountRequestTests {

    var request: AccountRequest!

    init() {
        self.request = AccountRequest(sessionID: "1234567890")
    }

    @Test("path is correct")
    func path() {
        #expect(request.path == "/account")
    }

    @Test("queryItems contains session_id")
    func queryItemsContainsSessionID() {
        #expect(request.queryItems == ["session_id": "1234567890"])
    }

    @Test("method is GET")
    func methodIsGet() {
        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        #expect(request.body == nil)
    }

}
