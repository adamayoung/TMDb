//
//  TrendingMoviesRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .trending))
struct TrendingMoviesRequestTests {

    @Test("path with day time window")
    func pathWithDayTimeWindow() {
        let request = TrendingMoviesRequest(timeWindow: .day)

        #expect(request.path == "/trending/movie/day")
    }

    @Test("path with week time window")
    func pathWithWeekTimeWindow() {
        let request = TrendingMoviesRequest(timeWindow: .week)

        #expect(request.path == "/trending/movie/week")
    }

    @Test("queryItems is empty")
    func queryItemsIsEmpty() {
        let request = TrendingMoviesRequest(timeWindow: .day)

        #expect(request.queryItems.isEmpty)
    }

    @Test("queryItems with page")
    func queryItemsWithPage() {
        let request = TrendingMoviesRequest(timeWindow: .day, page: 1)

        #expect(request.queryItems == ["page": "1"])
    }

    @Test("queryItems with language")
    func queryItemsWithLanguage() {
        let request = TrendingMoviesRequest(timeWindow: .day, language: "en")

        #expect(request.queryItems == ["language": "en"])
    }

    @Test("queryItems with page and language")
    func queryItemsWithPageAndLanguage() {
        let request = TrendingMoviesRequest(timeWindow: .day, page: 1, language: "en")

        #expect(request.queryItems == ["page": "1", "language": "en"])
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = TrendingMoviesRequest(timeWindow: .day)

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = TrendingMoviesRequest(timeWindow: .day)

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = TrendingMoviesRequest(timeWindow: .day)

        #expect(request.body == nil)
    }

}
