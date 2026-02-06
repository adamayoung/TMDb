//
//  TVSeriesEpisodeGroupsRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .tvSeries))
struct TVSeriesEpisodeGroupsRequestTests {

    @Test("path is correct")
    func path() {
        let request = TVSeriesEpisodeGroupsRequest(id: 1)

        #expect(request.path == "/tv/1/episode_groups")
    }

    @Test("queryItems is empty")
    func queryItemsIsEmpty() {
        let request = TVSeriesEpisodeGroupsRequest(id: 1)

        #expect(request.queryItems.isEmpty)
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = TVSeriesEpisodeGroupsRequest(id: 1)

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = TVSeriesEpisodeGroupsRequest(id: 1)

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = TVSeriesEpisodeGroupsRequest(id: 1)

        #expect(request.body == nil)
    }

}
