//
//  TVSeriesChangesListRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .tvSeries))
struct TVSeriesChangesListRequestTests {

    @Test("path is correct")
    func path() {
        let request = TVSeriesChangesListRequest()

        #expect(request.path == "/tv/changes")
    }

    @Test("queryItems is empty when no parameters")
    func queryItemsIsEmptyWhenNoParameters() {
        let request = TVSeriesChangesListRequest()

        #expect(request.queryItems.isEmpty)
    }

    @Test("queryItems contains startDate when provided")
    func queryItemsContainsStartDate() {
        let date = Date(timeIntervalSince1970: 1_704_067_200) // 2024-01-01
        let request = TVSeriesChangesListRequest(startDate: date)

        #expect(request.queryItems.count == 1)
        #expect(request.queryItems["start_date"] == "2024-01-01")
    }

    @Test("queryItems contains endDate when provided")
    func queryItemsContainsEndDate() {
        let date = Date(timeIntervalSince1970: 1_704_153_600) // 2024-01-02
        let request = TVSeriesChangesListRequest(endDate: date)

        #expect(request.queryItems.count == 1)
        #expect(request.queryItems["end_date"] == "2024-01-02")
    }

    @Test("queryItems contains page when provided")
    func queryItemsContainsPage() {
        let request = TVSeriesChangesListRequest(page: 2)

        #expect(request.queryItems.count == 1)
        #expect(request.queryItems["page"] == "2")
    }

    @Test("queryItems contains all parameters when provided")
    func queryItemsContainsAllParameters() {
        let startDate = Date(timeIntervalSince1970: 1_704_067_200)
        let endDate = Date(timeIntervalSince1970: 1_704_153_600)
        let request = TVSeriesChangesListRequest(startDate: startDate, endDate: endDate, page: 2)

        #expect(request.queryItems.count == 3)
        #expect(request.queryItems["start_date"] == "2024-01-01")
        #expect(request.queryItems["end_date"] == "2024-01-02")
        #expect(request.queryItems["page"] == "2")
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = TVSeriesChangesListRequest()

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = TVSeriesChangesListRequest()

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = TVSeriesChangesListRequest()

        #expect(request.body == nil)
    }

}
