//
//  CreateGuestSessionRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .authentication))
struct CreateGuestSessionRequestTests {

    var request: CreateGuestSessionRequest!

    init() {
        self.request = CreateGuestSessionRequest()
    }

    @Test("path is correct")
    func path() {
        #expect(request.path == "/authentication/guest_session/new")
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
