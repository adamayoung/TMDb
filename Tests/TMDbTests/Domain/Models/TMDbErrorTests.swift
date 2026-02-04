//
//  TMDbErrorTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct TMDbErrorTests {

    @Test("bad request errors with same message equal")
    func badRequestErrorsWithSameMessageEqual() {
        let lhs = TMDbError.badRequest("Message 1")
        let rhs = TMDbError.badRequest("Message 1")

        #expect(lhs == rhs)
    }

    @Test("bad request errors with different messages do not equal")
    func badRequestErrorsWithDifferentMessagesDoNotEqual() {
        let lhs = TMDbError.badRequest("Message 1")
        let rhs = TMDbError.badRequest("Message 2")

        #expect(lhs != rhs)
    }

    @Test("unauthorised errors with same message equal")
    func unauthorisedErrorsWithSameMessageEqual() {
        let lhs = TMDbError.unauthorised("Message 1")
        let rhs = TMDbError.unauthorised("Message 1")

        #expect(lhs == rhs)
    }

    @Test("unauthorised errors with different messages do not equal")
    func unauthorisedErrorsWithDifferentMessagesDoNotEqual() {
        let lhs = TMDbError.unauthorised("Message 1")
        let rhs = TMDbError.unauthorised("Message 2")

        #expect(lhs != rhs)
    }

    @Test("forbidden errors with same message equal")
    func forbiddenErrorsWithSameMessageEqual() {
        let lhs = TMDbError.forbidden("Message 1")
        let rhs = TMDbError.forbidden("Message 1")

        #expect(lhs == rhs)
    }

    @Test("forbidden errors with different messages do not equal")
    func forbiddenErrorsWithDifferentMessagesDoNotEqual() {
        let lhs = TMDbError.forbidden("Message 1")
        let rhs = TMDbError.forbidden("Message 2")

        #expect(lhs != rhs)
    }

    @Test("not found errors with same message equal")
    func notFoundErrorsWithSameMessageEqual() {
        let lhs = TMDbError.notFound("Message 1")
        let rhs = TMDbError.notFound("Message 1")

        #expect(lhs == rhs)
    }

    @Test("not found errors with different messages do not equal")
    func notFoundErrorsWithDifferentMessagesDoNotEqual() {
        let lhs = TMDbError.notFound("Message 1")
        let rhs = TMDbError.notFound("Message 2")

        #expect(lhs != rhs)
    }

    @Test("too many requests errors with same message equal")
    func tooManyRequestsErrorsWithSameMessageEqual() {
        let lhs = TMDbError.tooManyRequests("Message 1")
        let rhs = TMDbError.tooManyRequests("Message 1")

        #expect(lhs == rhs)
    }

    @Test("too many requests errors with different messages do not equal")
    func tooManyRequestsErrorsWithDifferentMessagesDoNotEqual() {
        let lhs = TMDbError.tooManyRequests("Message 1")
        let rhs = TMDbError.tooManyRequests("Message 2")

        #expect(lhs != rhs)
    }

    @Test("server error errors with same message equal")
    func serverErrorErrorsWithSameMessageEqual() {
        let lhs = TMDbError.serverError("Message 1")
        let rhs = TMDbError.serverError("Message 1")

        #expect(lhs == rhs)
    }

    @Test("server error errors with different messages do not equal")
    func serverErrorErrorsWithDifferentMessagesDoNotEqual() {
        let lhs = TMDbError.serverError("Message 1")
        let rhs = TMDbError.serverError("Message 2")

        #expect(lhs != rhs)
    }

    @Test("network errors equal")
    func networkErrorsEqual() {
        let lhs = TMDbError.network(MockError.test)
        let rhs = TMDbError.network(MockError.test)

        #expect(lhs == rhs)
    }

    @Test("decode errors equal")
    func decodeErrorsEqual() {
        let lhs = TMDbError.decode(MockError.test)
        let rhs = TMDbError.decode(MockError.test)

        #expect(lhs == rhs)
    }

    @Test("unknown errors equal")
    func unknownErrorsEqual() {
        let lhs = TMDbError.unknown
        let rhs = TMDbError.unknown

        #expect(lhs == rhs)
    }

    @Test("not found and unknown errors do not equal")
    func notFoundAndUnknowErrorsDoNotEqual() {
        let lhs = TMDbError.notFound()
        let rhs = TMDbError.unknown

        #expect(lhs != rhs)
    }

    @Test("bad request error description is correct")
    func badRequestErrorDescriptionIsCorrect() {
        let description = TMDbError.badRequest().errorDescription

        #expect(description == "Bad request")
    }

    @Test("unauthorised error description is correct")
    func unauthorisedErrorDescriptionIsCorrect() {
        let description = TMDbError.unauthorised().errorDescription

        #expect(description == "Unauthorised")
    }

    @Test("forbidden error description is correct")
    func forbiddenErrorDescriptionIsCorrect() {
        let description = TMDbError.forbidden().errorDescription

        #expect(description == "Forbidden")
    }

    @Test("not found error description is correct")
    func notFoundErrorDescriptionIsCorrect() {
        let description = TMDbError.notFound().errorDescription

        #expect(description == "Not found")
    }

    @Test("too many requests error description is correct")
    func tooManyRequestsErrorDescriptionIsCorrect() {
        let description = TMDbError.tooManyRequests().errorDescription

        #expect(description == "Too many requests")
    }

    @Test("server error error description is correct")
    func serverErrorErrorDescriptionIsCorrect() {
        let description = TMDbError.serverError().errorDescription

        #expect(description == "Server error")
    }

    @Test("network error description is correct")
    func networkErrorDescriptionIsCorrect() {
        let description = TMDbError.network(MockError.test).errorDescription

        #expect(description == "Network error")
    }

    @Test("decode error description is correct")
    func decodeErrorDescriptionIsCorrect() {
        let description = TMDbError.decode(MockError.test).errorDescription

        #expect(description == "Decode error")
    }

    @Test("unknown error description is correct")
    func unknownErrorDescriptionIsCorrect() {
        let description = TMDbError.unknown.errorDescription

        #expect(description == "Unknown")
    }

    @Test("bad request error description with message includes message")
    func badRequestErrorDescriptionWithMessageIncludesMessage() {
        let description = TMDbError.badRequest("Invalid API key").errorDescription

        #expect(description == "Invalid API key")
    }

    @Test("unauthorised error description with message includes message")
    func unauthorisedErrorDescriptionWithMessageIncludesMessage() {
        let description = TMDbError.unauthorised("Authentication failed").errorDescription

        #expect(description == "Authentication failed")
    }

    @Test("forbidden error description with message includes message")
    func forbiddenErrorDescriptionWithMessageIncludesMessage() {
        let description = TMDbError.forbidden("Access denied").errorDescription

        #expect(description == "Access denied")
    }

    @Test("not found error description with message includes message")
    func notFoundErrorDescriptionWithMessageIncludesMessage() {
        let description = TMDbError.notFound("Resource not found").errorDescription

        #expect(description == "Resource not found")
    }

    @Test("too many requests error description with message includes message")
    func tooManyRequestsErrorDescriptionWithMessageIncludesMessage() {
        let description = TMDbError.tooManyRequests("Rate limit exceeded").errorDescription

        #expect(description == "Rate limit exceeded")
    }

    @Test("server error error description with message includes message")
    func serverErrorErrorDescriptionWithMessageIncludesMessage() {
        let description = TMDbError.serverError("Internal error").errorDescription

        #expect(description == "Internal error")
    }

}

private extension TMDbErrorTests {

    enum MockError: Error {
        case test
        case test2
    }

}
