//
//  GuestSessionRatedTVSeriesRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .guestSession))
struct GuestSessionRatedTVSeriesRequestTests {

    @Test("path is correct")
    func path() {
        let request = GuestSessionRatedTVSeriesRequest(
            guestSessionID: "abc123"
        )

        #expect(
            request.path
                == "/guest_session/abc123/rated/tv"
        )
    }

    @Test("queryItems is empty when no sort or page")
    func queryItemsIsEmptyWhenNoSortOrPage() {
        let request = GuestSessionRatedTVSeriesRequest(
            guestSessionID: "abc123"
        )

        #expect(request.queryItems.isEmpty)
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = GuestSessionRatedTVSeriesRequest(
            guestSessionID: "abc123"
        )

        #expect(request.method == .get)
    }

}
