//
//  CountriesConfigurationRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.requests, .configuration))
struct CountriesConfigurationRequestTests {

    @Test("path is correct")
    func path() {
        let request = CountriesConfigurationRequest()

        #expect(request.path == "/configuration/countries")
    }

    @Test("queryItems is empty")
    func queryItemsIsEmpty() {
        let request = CountriesConfigurationRequest()

        #expect(request.queryItems.isEmpty)
    }

    @Test("queryItems with language")
    func queryItemsWithLanguage() {
        let request = CountriesConfigurationRequest(language: "en")

        #expect(request.queryItems == ["language": "en"])
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = CountriesConfigurationRequest()

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = CountriesConfigurationRequest()

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = CountriesConfigurationRequest()

        #expect(request.body == nil)
    }

}
