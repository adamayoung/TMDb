//
//  LanguaguesConfigurationRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.requests, .configuration))
struct LanguaguesConfigurationRequestTests {

    var request: LanguaguesConfigurationRequest!

    init() {
        self.request = LanguaguesConfigurationRequest()
    }

    @Test("path is correct")
    func path() {
        #expect(request.path == "/configuration/languages")
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
