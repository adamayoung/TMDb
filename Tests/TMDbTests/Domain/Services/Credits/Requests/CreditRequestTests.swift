//
//  CreditRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .credit))
struct CreditRequestTests {

    var request: CreditRequest!

    init() {
        self.request = CreditRequest(
            id: "52542282760ee313280017f9"
        )
    }

    @Test("path is correct")
    func path() {
        #expect(
            request.path
                == "/credit/52542282760ee313280017f9"
        )
    }

    @Test("path percent-encodes an ID containing unsafe characters")
    func pathPercentEncodesUnsafeID() {
        let request = CreditRequest(id: "abc/def?x=y")

        #expect(request.path == "/credit/abc%2Fdef%3Fx%3Dy")
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
