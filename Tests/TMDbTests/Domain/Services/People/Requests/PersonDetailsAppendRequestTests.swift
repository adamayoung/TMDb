//
//  PersonDetailsAppendRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .people))
struct PersonDetailsAppendRequestTests {

    @Test("path is correct")
    func path() {
        let request = PersonDetailsAppendRequest(
            id: 287,
            appendToResponse: .movieCredits
        )

        #expect(request.path == "/person/287")
    }

    @Test("queryItems with single option")
    func queryItemsWithSingleOption() throws {
        let request = PersonDetailsAppendRequest(
            id: 287,
            appendToResponse: .movieCredits
        )

        let value = try #require(request.queryItems["append_to_response"])
        #expect(value == "movie_credits")
    }

    @Test("queryItems with multiple options")
    func queryItemsWithMultipleOptions() throws {
        let request = PersonDetailsAppendRequest(
            id: 287,
            appendToResponse: [.movieCredits, .images]
        )

        let value = try #require(request.queryItems["append_to_response"])
        let components = Set(value.split(separator: ",").map(String.init))
        #expect(components == ["movie_credits", "images"])
    }

    @Test("queryItems with language")
    func queryItemsWithLanguage() throws {
        let request = PersonDetailsAppendRequest(
            id: 287,
            appendToResponse: .movieCredits,
            language: "en"
        )

        let appendValue = try #require(
            request.queryItems["append_to_response"]
        )
        #expect(appendValue == "movie_credits")
        #expect(request.queryItems["language"] == "en")
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = PersonDetailsAppendRequest(
            id: 287,
            appendToResponse: .movieCredits
        )

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = PersonDetailsAppendRequest(
            id: 287,
            appendToResponse: .movieCredits
        )

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = PersonDetailsAppendRequest(
            id: 287,
            appendToResponse: .movieCredits
        )

        #expect(request.body == nil)
    }

}
