//
//  ListItemStatusRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .list))
struct ListItemStatusRequestTests {

    @Test("path is correct")
    func path() {
        let request = ListItemStatusRequest(listID: 123, mediaID: 550)

        #expect(request.path == "/list/123/item_status")
    }

    @Test("queryItems contains movie_id")
    func queryItemsContainsMovieID() {
        let request = ListItemStatusRequest(listID: 123, mediaID: 550)

        #expect(request.queryItems == ["movie_id": "550"])
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = ListItemStatusRequest(listID: 123, mediaID: 550)

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = ListItemStatusRequest(listID: 123, mediaID: 550)

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = ListItemStatusRequest(listID: 123, mediaID: 550)

        #expect(request.body == nil)
    }

}
