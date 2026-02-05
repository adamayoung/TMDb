//
//  PersonChangesListRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .people))
struct PersonChangesListRequestTests {

    @Test("path is correct")
    func path() {
        let request = PersonChangesListRequest()

        #expect(request.path == "/person/changes")
    }

    @Test("queryItems is empty when no parameters")
    func queryItemsIsEmptyWhenNoParameters() {
        let request = PersonChangesListRequest()

        #expect(request.queryItems.isEmpty)
    }

    @Test("queryItems contains startDate when provided")
    func queryItemsContainsStartDate() {
        let date = Date(timeIntervalSince1970: 1_704_067_200) // 2024-01-01
        let request = PersonChangesListRequest(startDate: date)

        #expect(request.queryItems.count == 1)
        #expect(request.queryItems["start_date"] == "2024-01-01")
    }

    @Test("queryItems contains endDate when provided")
    func queryItemsContainsEndDate() {
        let date = Date(timeIntervalSince1970: 1_704_153_600) // 2024-01-02
        let request = PersonChangesListRequest(endDate: date)

        #expect(request.queryItems.count == 1)
        #expect(request.queryItems["end_date"] == "2024-01-02")
    }

    @Test("queryItems with page")
    func queryItemsWithPage() {
        let request = PersonChangesListRequest(page: 2)

        #expect(request.queryItems == ["page": "2"])
    }

    @Test("queryItems contains all parameters when provided")
    func queryItemsContainsAllParameters() {
        let startDate = Date(timeIntervalSince1970: 1_704_067_200)
        let endDate = Date(timeIntervalSince1970: 1_704_153_600)
        let request = PersonChangesListRequest(
            startDate: startDate, endDate: endDate, page: 2
        )

        #expect(request.queryItems.count == 3)
        #expect(request.queryItems["start_date"] == "2024-01-01")
        #expect(request.queryItems["end_date"] == "2024-01-02")
        #expect(request.queryItems["page"] == "2")
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = PersonChangesListRequest()

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = PersonChangesListRequest()

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = PersonChangesListRequest()

        #expect(request.body == nil)
    }

}
