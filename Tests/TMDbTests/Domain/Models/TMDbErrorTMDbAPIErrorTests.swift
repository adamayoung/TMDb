//
//  TMDbErrorTMDbAPIErrorTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct TMDbErrorTMDbAPIErrorTests {

    @Test("init when error is not a TMDbAPIError returns unknown error")
    func initWithNonTMDbAPIErrorReturnsUnknownError() {
        let error = NSError(domain: "test", code: -1)

        let tmdbError = TMDbError(error: error)

        #expect(tmdbError == .unknown)
    }

    @Test("init when error is a TMDbAPIError.badRequest preserves the context")
    func initWithBadRequestTMDbAPIErrorReturnsBadRequestError() {
        let context = TMDbErrorContext(httpStatusCode: 400, statusMessage: "Bad request message")
        let error = TMDbAPIError.badRequest(context)

        let tmdbError = TMDbError(error: error)

        #expect(tmdbError == .badRequest(context))
    }

    @Test("init when error is a TMDbAPIError.unauthorised preserves the context")
    func initWithUnauthorisedTMDbAPIErrorReturnsUnauthorisedError() {
        let context = TMDbErrorContext(httpStatusCode: 401, statusMessage: "Unauthorised message")
        let error = TMDbAPIError.unauthorised(context)

        let tmdbError = TMDbError(error: error)

        #expect(tmdbError == .unauthorised(context))
    }

    @Test("init when error is a TMDbAPIError.forbidden preserves the context")
    func initWithForbiddenTMDbAPIErrorReturnsForbiddenError() {
        let context = TMDbErrorContext(httpStatusCode: 403, statusMessage: "Forbidden message")
        let error = TMDbAPIError.forbidden(context)

        let tmdbError = TMDbError(error: error)

        #expect(tmdbError == .forbidden(context))
    }

    @Test("init when error is a TMDbAPIError.notFound preserves the context")
    func initWithNotFoundTMDbAPIErrorReturnsNotFoundError() {
        let context = TMDbErrorContext(httpStatusCode: 404, statusMessage: "Not found message")
        let error = TMDbAPIError.notFound(context)

        let tmdbError = TMDbError(error: error)

        #expect(tmdbError == .notFound(context))
    }

    @Test("init when error is a TMDbAPIError.tooManyRequests preserves the context")
    func initWithTooManyRequestsTMDbAPIErrorReturnsTooManyRequestsError() {
        let context = TMDbErrorContext(httpStatusCode: 429, retryAfter: .seconds(5))
        let error = TMDbAPIError.tooManyRequests(context)

        let tmdbError = TMDbError(error: error)

        #expect(tmdbError == .tooManyRequests(context))
    }

    @Test("init when error is a TMDbAPIError.internalServerError returns serverError with context")
    func initWithInternalServerErrorTMDbAPIErrorReturnsServerError() {
        let context = TMDbErrorContext(httpStatusCode: 500, statusMessage: "Internal server error")
        let error = TMDbAPIError.internalServerError(context)

        let tmdbError = TMDbError(error: error)

        #expect(tmdbError == .serverError(context))
    }

    @Test("init when error is a TMDbAPIError.badGateway returns serverError with 502 context")
    func initWithBadGatewayTMDbAPIErrorReturnsServerError() {
        let context = TMDbErrorContext(httpStatusCode: 502, statusMessage: "Bad gateway message")
        let error = TMDbAPIError.badGateway(context)

        let tmdbError = TMDbError(error: error)

        #expect(tmdbError == .serverError(context))
        #expect(tmdbError == .serverError(TMDbErrorContext(httpStatusCode: 502, statusMessage: "Bad gateway message")))
    }

    @Test("init when error is a TMDbAPIError.gatewayTimeout returns serverError with context")
    func initWithGatewayTimeoutTMDbAPIErrorReturnsServerError() {
        let context = TMDbErrorContext(httpStatusCode: 504, statusMessage: "Gateway timeout message")
        let error = TMDbAPIError.gatewayTimeout(context)

        let tmdbError = TMDbError(error: error)

        #expect(tmdbError == .serverError(context))
    }

    @Test("init when error is a TMDbAPIError.methodNotAllowed returns badRequest with context")
    func initWithMethodNotAllowedTMDbAPIErrorReturnsBadRequestError() {
        let context = TMDbErrorContext(httpStatusCode: 405, statusMessage: "Method not allowed")
        let error = TMDbAPIError.methodNotAllowed(context)

        let tmdbError = TMDbError(error: error)

        #expect(tmdbError == .badRequest(context))
    }

    @Test("init when error is a TMDbAPIError.unprocessableContent returns badRequest with context")
    func initWithUnprocessableContentTMDbAPIErrorReturnsBadRequestError() {
        let context = TMDbErrorContext(httpStatusCode: 422, statusMessage: "Unprocessable content")
        let error = TMDbAPIError.unprocessableContent(context)

        let tmdbError = TMDbError(error: error)

        #expect(tmdbError == .badRequest(context))
    }

    @Test("init when error is a TMDbAPIError.invalidURL returns invalidURL error")
    func initWithInvalidURLTMDbAPIErrorReturnsInvalidURLError() {
        let url = "https://invalid-url.example.com"
        let error = TMDbAPIError.invalidURL(url)

        let tmdbError = TMDbError(error: error)

        #expect(tmdbError == .invalidURL(url))
    }

    @Test("init when error is a TMDbAPIError.network returns network error")
    func initWithNetworkTMDbAPIErrorReturnsNetworkError() {
        let networkError = NSError(domain: "test", code: -1)
        let error = TMDbAPIError.network(networkError)

        let tmdbError = TMDbError(error: error)

        #expect(tmdbError == .network(networkError))
    }

    @Test("init when error is a TMDbAPIError.decode returns decode error")
    func initWithDecodeTMDbAPIErrorReturnsDecodeError() {
        let decodeError = NSError(domain: "decode", code: -1)
        let error = TMDbAPIError.decode(decodeError)

        let tmdbError = TMDbError(error: error)

        #expect(tmdbError == .decode(decodeError))
    }

    @Test("init when error is a TMDbAPIError.encode returns encode error")
    func initWithEncodeTMDbAPIErrorReturnsEncodeError() {
        let encodeError = NSError(domain: "encode", code: -1)
        let error = TMDbAPIError.encode(encodeError)

        let tmdbError = TMDbError(error: error)

        #expect(tmdbError == .encode(encodeError))
    }

    @Test("init when error is a TMDbAPIError.unknown returns unknown error")
    func initWithUnknownTMDbAPIErrorReturnsUnknownError() {
        let error = TMDbAPIError.unknown

        let tmdbError = TMDbError(error: error)

        #expect(tmdbError == .unknown)
    }

}
