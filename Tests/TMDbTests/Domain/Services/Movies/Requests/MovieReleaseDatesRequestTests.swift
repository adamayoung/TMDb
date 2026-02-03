//
//  MovieReleaseDatesRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .movie))
struct MovieReleaseDatesRequestTests {

    @Test("path is correct")
    func path() {
        let request = MovieReleaseDatesRequest(id: 550)

        #expect(request.path == "/movie/550/release_dates")
    }

    @Test("queryItems is empty")
    func queryItemsIsEmpty() {
        let request = MovieReleaseDatesRequest(id: 550)

        #expect(request.queryItems.isEmpty)
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = MovieReleaseDatesRequest(id: 550)

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = MovieReleaseDatesRequest(id: 550)

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = MovieReleaseDatesRequest(id: 550)

        #expect(request.body == nil)
    }

}
