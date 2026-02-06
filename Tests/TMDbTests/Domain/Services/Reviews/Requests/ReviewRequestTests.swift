//
//  ReviewRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .review))
struct ReviewRequestTests {

    var request: ReviewRequest!

    init() {
        self.request = ReviewRequest(
            id: "5488c29bc3a3686f4a00004a"
        )
    }

    @Test("path is correct")
    func path() {
        #expect(
            request.path
                == "/review/5488c29bc3a3686f4a00004a"
        )
    }

    @Test("queryItems is empty")
    func queryItemsIsEmpty() {
        #expect(request.queryItems.isEmpty)
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
