//
//  DeleteSessionRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
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
