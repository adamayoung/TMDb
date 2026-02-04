//
//  TVSeriesAccountStatesRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .tvSeries))
struct TVSeriesAccountStatesRequestTests {

    @Test("path is correct")
    func path() {
        let request = TVSeriesAccountStatesRequest(id: 1, sessionID: "abc123")

        #expect(request.path == "/tv/1/account_states")
    }

    @Test("queryItems contains sessionID")
    func queryItemsContainsSessionID() {
        let request = TVSeriesAccountStatesRequest(id: 1, sessionID: "abc123")

        #expect(request.queryItems.count == 1)
        #expect(request.queryItems["session_id"] == "abc123")
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = TVSeriesAccountStatesRequest(id: 1, sessionID: "abc123")

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = TVSeriesAccountStatesRequest(id: 1, sessionID: "abc123")

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = TVSeriesAccountStatesRequest(id: 1, sessionID: "abc123")

        #expect(request.body == nil)
    }

}
