//
//  TrendingAllRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .trending))
struct TrendingAllRequestTests {

    @Test("path with day time window")
    func pathWithDayTimeWindow() {
        let request = TrendingAllRequest(timeWindow: .day)

        #expect(request.path == "/trending/all/day")
    }

    @Test("path with week time window")
    func pathWithWeekTimeWindow() {
        let request = TrendingAllRequest(timeWindow: .week)

        #expect(request.path == "/trending/all/week")
    }

    @Test("queryItems is empty")
    func queryItemsIsEmpty() {
        let request = TrendingAllRequest(timeWindow: .day)

        #expect(request.queryItems.isEmpty)
    }

    @Test("queryItems with page")
    func queryItemsWithPage() {
        let request = TrendingAllRequest(timeWindow: .day, page: 1)

        #expect(request.queryItems == ["page": "1"])
    }

    @Test("queryItems with language")
    func queryItemsWithLanguage() {
        let request = TrendingAllRequest(timeWindow: .day, language: "en")

        #expect(request.queryItems == ["language": "en"])
    }

    @Test("queryItems with page and language")
    func queryItemsWithPageAndLanguage() {
        let request = TrendingAllRequest(timeWindow: .day, page: 1, language: "en")

        #expect(request.queryItems == ["page": "1", "language": "en"])
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = TrendingAllRequest(timeWindow: .day)

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = TrendingAllRequest(timeWindow: .day)

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = TrendingAllRequest(timeWindow: .day)

        #expect(request.body == nil)
    }

}
