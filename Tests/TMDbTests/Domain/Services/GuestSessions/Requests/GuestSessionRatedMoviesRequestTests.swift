//
//  GuestSessionRatedMoviesRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .guestSession))
struct GuestSessionRatedMoviesRequestTests {

    @Test("path is correct")
    func path() {
        let request = GuestSessionRatedMoviesRequest(
            guestSessionID: "abc123"
        )

        #expect(
            request.path
                == "/guest_session/abc123/rated/movies"
        )
    }

    @Test("queryItems is empty when no sort or page")
    func queryItemsIsEmptyWhenNoSortOrPage() {
        let request = GuestSessionRatedMoviesRequest(
            guestSessionID: "abc123"
        )

        #expect(request.queryItems.isEmpty)
    }

    @Test("queryItems contains sort_by when sorted")
    func queryItemsContainsSortBy() {
        let request = GuestSessionRatedMoviesRequest(
            sortedBy: .createdAt(descending: true),
            guestSessionID: "abc123"
        )

        #expect(request.queryItems.isEmpty == false)
    }

    @Test("queryItems contains page")
    func queryItemsContainsPage() {
        let request = GuestSessionRatedMoviesRequest(
            page: 2,
            guestSessionID: "abc123"
        )

        #expect(request.queryItems.isEmpty == false)
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = GuestSessionRatedMoviesRequest(
            guestSessionID: "abc123"
        )

        #expect(request.method == .get)
    }

}
