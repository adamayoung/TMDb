//
//  MovieChangesListRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .movie))
struct MovieChangesListRequestTests {

    /// 2024-01-01T00:00:00Z.
    private static let startDate = Date(timeIntervalSince1970: 1_704_067_200)
    /// 2024-12-31T00:00:00Z.
    private static let endDate = Date(timeIntervalSince1970: 1_735_603_200)

    @Test("path is correct")
    func path() {
        let request = MovieChangesListRequest()

        #expect(request.path == "/movie/changes")
    }

    @Test("queryItems is empty when no parameters")
    func queryItemsIsEmptyWhenNoParameters() {
        let request = MovieChangesListRequest()

        #expect(request.queryItems.isEmpty)
    }

    /// See `MovieChangesRequestTests` for why this is pinned: this request
    /// assigned the `Date` itself, which `APIRequestQueryItems` stringifies
    /// with `Date.description`, bypassing the GMT-pinned formatter.
    @Test("queryItems formats dates as GMT calendar days")
    func queryItemsFormatsDatesAsGMTCalendarDays() {
        let request = MovieChangesListRequest(startDate: Self.startDate, endDate: Self.endDate)

        #expect(request.queryItems["start_date"] == "2024-01-01")
        #expect(request.queryItems["end_date"] == "2024-12-31")
    }

    @Test("queryItems contains page when provided")
    func queryItemsContainsPageWhenProvided() {
        let request = MovieChangesListRequest(page: 3)

        #expect(request.queryItems["page"] == "3")
    }

}
