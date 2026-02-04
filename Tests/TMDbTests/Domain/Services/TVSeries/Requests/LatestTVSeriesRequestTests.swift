//
//  LatestTVSeriesRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .tvSeries))
struct LatestTVSeriesRequestTests {

    @Test("path is correct")
    func path() {
        let request = LatestTVSeriesRequest()

        #expect(request.path == "/tv/latest")
    }

    @Test("queryItems is empty")
    func queryItemsIsEmpty() {
        let request = LatestTVSeriesRequest()

        #expect(request.queryItems.isEmpty)
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = LatestTVSeriesRequest()

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = LatestTVSeriesRequest()

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = LatestTVSeriesRequest()

        #expect(request.body == nil)
    }

}
