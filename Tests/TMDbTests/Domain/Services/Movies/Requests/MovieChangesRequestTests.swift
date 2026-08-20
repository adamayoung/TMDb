//
//  MovieChangesRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .movie))
struct MovieChangesRequestTests {

    /// 2024-01-01T00:00:00Z.
    private static let startDate = Date(timeIntervalSince1970: 1_704_067_200)
    /// 2024-12-31T00:00:00Z.
    private static let endDate = Date(timeIntervalSince1970: 1_735_603_200)

    @Test("path is correct")
    func path() {
        let request = MovieChangesRequest(id: 550)

        #expect(request.path == "/movie/550/changes")
    }

    @Test("queryItems is empty when no parameters")
    func queryItemsIsEmptyWhenNoParameters() {
        let request = MovieChangesRequest(id: 550)

        #expect(request.queryItems.isEmpty)
    }

    /// The movie changes requests were the only outbound date path that did not
    /// route through `DateFormatter.theMovieDatabase` — they assigned the `Date`
    /// itself, which `APIRequestQueryItems` stringifies with `Date.description`,
    /// emitting `"2024-01-01 00:00:00 +0000"`. Their six sibling changes
    /// requests were all covered by tests like this one; these two were not,
    /// which is how the divergence survived.
    @Test("queryItems formats dates as GMT calendar days")
    func queryItemsFormatsDatesAsGMTCalendarDays() {
        let request = MovieChangesRequest(id: 550, startDate: Self.startDate, endDate: Self.endDate)

        #expect(request.queryItems["start_date"] == "2024-01-01")
        #expect(request.queryItems["end_date"] == "2024-12-31")
    }

    @Test("queryItems contains page when provided")
    func queryItemsContainsPageWhenProvided() {
        let request = MovieChangesRequest(id: 550, page: 2)

        #expect(request.queryItems["page"] == "2")
    }

}

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

    @Test("queryItems formats dates as GMT calendar days")
    func queryItemsFormatsDatesAsGMTCalendarDays() {
        let request = MovieChangesListRequest(startDate: Self.startDate, endDate: Self.endDate)

        #expect(request.queryItems["start_date"] == "2024-01-01")
        #expect(request.queryItems["end_date"] == "2024-12-31")
    }

}
