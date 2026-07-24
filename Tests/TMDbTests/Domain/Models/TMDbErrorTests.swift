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

    @Test("errors with equal context equal")
    func errorsWithEqualContextEqual() {
        let context = TMDbErrorContext(httpStatusCode: 404, statusMessage: "Message 1")

        #expect(TMDbError.badRequest(context) == TMDbError.badRequest(context))
        #expect(TMDbError.unauthorised(context) == TMDbError.unauthorised(context))
        #expect(TMDbError.forbidden(context) == TMDbError.forbidden(context))
        #expect(TMDbError.notFound(context) == TMDbError.notFound(context))
        #expect(TMDbError.tooManyRequests(context) == TMDbError.tooManyRequests(context))
        #expect(TMDbError.serverError(context) == TMDbError.serverError(context))
    }

    @Test("errors with different context do not equal")
    func errorsWithDifferentContextDoNotEqual() {
        let lhs = TMDbError.badRequest(TMDbErrorContext(statusMessage: "Message 1"))
        let rhs = TMDbError.badRequest(TMDbErrorContext(statusMessage: "Message 2"))

        #expect(lhs != rhs)
    }

    @Test("errors differing only by http status code do not equal")
    func errorsDifferingByHTTPStatusCodeDoNotEqual() {
        let lhs = TMDbError.serverError(TMDbErrorContext(httpStatusCode: 502))
        let rhs = TMDbError.serverError(TMDbErrorContext(httpStatusCode: 503))

        #expect(lhs != rhs)
    }

    @Test("invalidURL errors with same value equal")
    func invalidURLErrorsWithSameValueEqual() {
        #expect(TMDbError.invalidURL("/movie/1") == TMDbError.invalidURL("/movie/1"))
        #expect(TMDbError.invalidURL("/movie/1") != TMDbError.invalidURL("/movie/2"))
    }

    @Test("network errors equal")
    func networkErrorsEqual() {
        #expect(TMDbError.network(MockError.test) == TMDbError.network(MockError.test))
    }

    @Test("decode errors equal")
    func decodeErrorsEqual() {
        #expect(TMDbError.decode(MockError.test) == TMDbError.decode(MockError.test))
    }

    @Test("encode errors equal")
    func encodeErrorsEqual() {
        #expect(TMDbError.encode(MockError.test) == TMDbError.encode(MockError.test))
    }

    @Test("invalidRating errors equal")
    func invalidRatingErrorsEqual() {
        #expect(TMDbError.invalidRating == TMDbError.invalidRating)
    }

    @Test("unknown errors equal")
    func unknownErrorsEqual() {
        #expect(TMDbError.unknown == TMDbError.unknown)
    }

    @Test("different cases do not equal")
    func differentCasesDoNotEqual() {
        #expect(TMDbError.notFound() != TMDbError.unknown)
        #expect(TMDbError.encode(MockError.test) != TMDbError.network(MockError.test))
    }

    @Test(
        "error description falls back to the case default without a message",
        arguments: [
            (TMDbError.badRequest(), "Bad request"),
            (TMDbError.unauthorised(), "Unauthorised"),
            (TMDbError.forbidden(), "Forbidden"),
            (TMDbError.notFound(), "Not found"),
            (TMDbError.tooManyRequests(), "Too many requests"),
            (TMDbError.serverError(), "Server error"),
            (TMDbError.network(MockError.test), "Network error"),
            (TMDbError.decode(MockError.test), "Decode error"),
            (TMDbError.encode(MockError.test), "Encode error"),
            (TMDbError.unknown, "Unknown")
        ]
    )
    func errorDescriptionFallsBackToDefault(error: TMDbError, expected: String) {
        #expect(error.errorDescription == expected)
    }

    @Test("error description uses the status message when present")
    func errorDescriptionUsesStatusMessage() {
        let context = TMDbErrorContext(statusMessage: "Invalid API key")

        #expect(TMDbError.unauthorised(context).errorDescription == "Invalid API key")
        #expect(TMDbError.badRequest(context).errorDescription == "Invalid API key")
    }

    @Test("invalidURL error description includes the url")
    func invalidURLErrorDescriptionIncludesURL() {
        #expect(TMDbError.invalidURL("/movie/1").errorDescription == "Invalid URL: /movie/1")
    }

    @Test("invalidRating error description is correct")
    func invalidRatingErrorDescriptionIsCorrect() {
        let description = TMDbError.invalidRating.errorDescription

        #expect(description == "Invalid rating (must be between 0.5 and 10.0, in increments of 0.5)")
    }

}

private extension TMDbErrorTests {

    enum MockError: Error {
        case test
        case test2
    }

}
