//
//  TVSeriesAiringTodayRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .tvSeries))
struct TVSeriesAiringTodayRequestTests {

    @Test("path is correct")
    func path() {
        let request = TVSeriesAiringTodayRequest()

        #expect(request.path == "/tv/airing_today")
    }

    @Test("queryItems is empty")
    func queryItemsIsEmpty() {
        let request = TVSeriesAiringTodayRequest()

        #expect(request.queryItems.isEmpty)
    }

    @Test("queryItems with page")
    func queryItemsWithPage() {
        let request = TVSeriesAiringTodayRequest(page: 3)

        #expect(request.queryItems == ["page": "3"])
    }

    @Test("queryItems with timezone")
    func queryItemsWithTimezone() {
        let request = TVSeriesAiringTodayRequest(timezone: "America/New_York")

        #expect(request.queryItems == ["timezone": "America/New_York"])
    }

    @Test("queryItems with language")
    func queryItemsWithLanguage() {
        let request = TVSeriesAiringTodayRequest(language: "en")

        #expect(request.queryItems == ["language": "en"])
    }

    @Test("queryItems with page, timezone and language")
    func queryItemsWithPageTimezoneAndLanguage() {
        let request = TVSeriesAiringTodayRequest(page: 3, timezone: "Europe/London", language: "en")

        #expect(request.queryItems == ["page": "3", "timezone": "Europe/London", "language": "en"])
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = TVSeriesAiringTodayRequest()

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = TVSeriesAiringTodayRequest()

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = TVSeriesAiringTodayRequest()

        #expect(request.body == nil)
    }

}
