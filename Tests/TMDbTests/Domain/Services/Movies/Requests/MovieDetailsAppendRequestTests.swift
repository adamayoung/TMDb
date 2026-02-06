//
//  MovieDetailsAppendRequestTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .movie))
struct MovieDetailsAppendRequestTests {

    @Test("path is correct")
    func path() {
        let request = MovieDetailsAppendRequest(
            id: 550,
            appendToResponse: .credits
        )

        #expect(request.path == "/movie/550")
    }

    @Test("queryItems with single option")
    func queryItemsWithSingleOption() throws {
        let request = MovieDetailsAppendRequest(
            id: 550,
            appendToResponse: .credits
        )

        let value = try #require(request.queryItems["append_to_response"])
        #expect(value == "credits")
    }

    @Test("queryItems with multiple options")
    func queryItemsWithMultipleOptions() throws {
        let request = MovieDetailsAppendRequest(
            id: 550,
            appendToResponse: [.credits, .images]
        )

        let value = try #require(request.queryItems["append_to_response"])
        let components = Set(value.split(separator: ",").map(String.init))
        #expect(components == ["credits", "images"])
    }

    @Test("queryItems with language")
    func queryItemsWithLanguage() throws {
        let request = MovieDetailsAppendRequest(
            id: 550,
            appendToResponse: .credits,
            language: "en"
        )

        let appendValue = try #require(
            request.queryItems["append_to_response"]
        )
        #expect(appendValue == "credits")
        #expect(request.queryItems["language"] == "en")
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = MovieDetailsAppendRequest(
            id: 550,
            appendToResponse: .credits
        )

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = MovieDetailsAppendRequest(
            id: 550,
            appendToResponse: .credits
        )

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = MovieDetailsAppendRequest(
            id: 550,
            appendToResponse: .credits
        )

        #expect(request.body == nil)
    }

}
