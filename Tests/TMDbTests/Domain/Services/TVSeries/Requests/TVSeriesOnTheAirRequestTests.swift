//
//  TVSeriesOnTheAirRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.requests, .tvSeries))
struct TVSeriesOnTheAirRequestTests {

    @Test("path is correct")
    func path() {
        let request = TVSeriesOnTheAirRequest()

        #expect(request.path == "/tv/on_the_air")
    }

    @Test("queryItems is empty")
    func queryItemsIsEmpty() {
        let request = TVSeriesOnTheAirRequest()

        #expect(request.queryItems.isEmpty)
    }

    @Test("queryItems with page")
    func queryItemsWithPage() {
        let request = TVSeriesOnTheAirRequest(page: 3)

        #expect(request.queryItems == ["page": "3"])
    }

    @Test("queryItems with timezone")
    func queryItemsWithTimezone() {
        let request = TVSeriesOnTheAirRequest(timezone: "America/New_York")

        #expect(request.queryItems == ["timezone": "America/New_York"])
    }

    @Test("queryItems with language")
    func queryItemsWithLanguage() {
        let request = TVSeriesOnTheAirRequest(language: "en")

        #expect(request.queryItems == ["language": "en"])
    }

    @Test("queryItems with page, timezone and language")
    func queryItemsWithPageTimezoneAndLanguage() {
        let request = TVSeriesOnTheAirRequest(page: 3, timezone: "Europe/London", language: "en")

        #expect(request.queryItems == ["page": "3", "timezone": "Europe/London", "language": "en"])
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = TVSeriesOnTheAirRequest()

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = TVSeriesOnTheAirRequest()

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = TVSeriesOnTheAirRequest()

        #expect(request.body == nil)
    }

}
