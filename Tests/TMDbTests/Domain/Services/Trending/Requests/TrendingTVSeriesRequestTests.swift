//
//  TrendingTVSeriesRequestTests.swift
//  TMDb
//
//  Copyright © 2025 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.requests, .trending))
struct TrendingTVSeriesRequestTests {

    @Test("path with day time window")
    func pathWithDayTimeWindow() {
        let request = TrendingTVSeriesRequest(timeWindow: .day)

        #expect(request.path == "/trending/tv/day")
    }

    @Test("path with week time window")
    func pathWithWeekTimeWindow() {
        let request = TrendingTVSeriesRequest(timeWindow: .week)

        #expect(request.path == "/trending/tv/week")
    }

    @Test("queryItems is empty")
    func queryItemsIsEmpty() {
        let request = TrendingTVSeriesRequest(timeWindow: .day)

        #expect(request.queryItems.isEmpty)
    }

    @Test("queryItems with page")
    func queryItemsWithPage() {
        let request = TrendingTVSeriesRequest(timeWindow: .day, page: 1)

        #expect(request.queryItems == ["page": "1"])
    }

    @Test("queryItems with language")
    func queryItemsWithLanguage() {
        let request = TrendingTVSeriesRequest(timeWindow: .day, language: "en")

        #expect(request.queryItems == ["language": "en"])
    }

    @Test("queryItems with page and language")
    func queryItemsWithPageAndLanguage() {
        let request = TrendingTVSeriesRequest(timeWindow: .day, page: 1, language: "en")

        #expect(request.queryItems == ["page": "1", "language": "en"])
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = TrendingTVSeriesRequest(timeWindow: .day)

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = TrendingTVSeriesRequest(timeWindow: .day)

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = TrendingTVSeriesRequest(timeWindow: .day)

        #expect(request.body == nil)
    }

}
