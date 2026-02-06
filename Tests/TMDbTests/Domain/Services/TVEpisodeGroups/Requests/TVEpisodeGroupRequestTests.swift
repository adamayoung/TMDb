//
//  TVEpisodeGroupRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .tvEpisodeGroup))
struct TVEpisodeGroupRequestTests {

    var request: TVEpisodeGroupRequest!

    init() {
        self.request = TVEpisodeGroupRequest(
            id: "5acf93e60e0a26346d0000ce"
        )
    }

    @Test("path is correct")
    func path() {
        #expect(
            request.path
                == "/tv/episode_group/5acf93e60e0a26346d0000ce"
        )
    }

    @Test("queryItems is empty")
    func queryItemsIsEmpty() {
        #expect(request.queryItems.isEmpty)
    }

    @Test("method is GET")
    func methodIsGet() {
        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        #expect(request.body == nil)
    }

}
