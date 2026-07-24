//
//  ToolErrorMapperTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.languageModelTools))
struct ToolErrorMapperTests {

    private struct DummyError: Error {}

    @Test("not found maps to a message naming the entity and id")
    func notFoundWithEntityAndID() {
        let message = ToolErrorMapper.message(for: .notFound(), entity: "movie", id: 5)
        #expect(message == "No TMDb movie with id 5 found.")
    }

    @Test("not found without context maps to a generic message")
    func notFoundWithoutContext() {
        let message = ToolErrorMapper.message(for: .notFound())
        #expect(message == "No TMDb result found.")
    }

    @Test("bad request maps to a message including the underlying detail")
    func badRequest() {
        let context = TMDbErrorContext(statusMessage: "invalid country")
        let message = ToolErrorMapper.message(for: .badRequest(context))
        #expect(message?.contains("Invalid request: invalid country") == true)
    }

    @Test("too many requests maps to a rate-limit message")
    func tooManyRequests() {
        let message = ToolErrorMapper.message(for: .tooManyRequests())
        #expect(message?.contains("rate limiting") == true)
    }

    @Test("unauthorised and forbidden map to an access-denied message")
    func accessDenied() {
        #expect(ToolErrorMapper.message(for: .unauthorised()) == "TMDb access was denied (check the API key).")
        #expect(ToolErrorMapper.message(for: .forbidden()) == "TMDb access was denied (check the API key).")
    }

    @Test("infrastructure errors return nil so they are rethrown")
    func infrastructureErrorsAreRethrown() {
        #expect(ToolErrorMapper.message(for: .network(DummyError())) == nil)
        #expect(ToolErrorMapper.message(for: .serverError()) == nil)
        #expect(ToolErrorMapper.message(for: .decode(DummyError())) == nil)
        #expect(ToolErrorMapper.message(for: .encode(DummyError())) == nil)
        #expect(ToolErrorMapper.message(for: .invalidURL("/movie/1")) == nil)
        #expect(ToolErrorMapper.message(for: .invalidRating) == nil)
        #expect(ToolErrorMapper.message(for: .unknown) == nil)
    }

}
