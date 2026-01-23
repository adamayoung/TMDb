//
//  TVSeriesAiringTodayRequestTests.swift
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
