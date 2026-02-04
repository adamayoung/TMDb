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

    @Test("init when error is a TMDbAPIError.badRequest returns badRequest error")
    func initWithBadRequestTMDbAPIErrorReturnsBadRequestError() {
        let message = "Bad request message"
        let error = TMDbAPIError.badRequest(message)

        let tmdbError = TMDbError(error: error)

        #expect(tmdbError == .badRequest(message))
    }

    @Test("init when error is a TMDbAPIError.unauthorised returns unauthorised error")
    func initWithUnauthorisedTMDbAPIErrorReturnsUnauthorisedError() {
        let message = "Unauthorised message"
        let error = TMDbAPIError.unauthorised(message)

        let tmdbError = TMDbError(error: error)

        #expect(tmdbError == .unauthorised(message))
    }

    @Test("init when error is a TMDbAPIError.forbidden returns forbidden error")
    func initWithForbiddenTMDbAPIErrorReturnsForbiddenError() {
        let message = "Forbidden message"
        let error = TMDbAPIError.forbidden(message)

        let tmdbError = TMDbError(error: error)

        #expect(tmdbError == .forbidden(message))
    }

    @Test("init when error is a TMDbAPIError.notFound returns notFound error")
    func initWithNotFoundTMDbAPIErrorReturnsNotFoundError() {
        let message = "Not found message"
        let error = TMDbAPIError.notFound(message)

        let tmdbError = TMDbError(error: error)

        #expect(tmdbError == .notFound(message))
    }

    @Test("init when error is a TMDbAPIError.tooManyRequests returns tooManyRequests error")
    func initWithTooManyRequestsTMDbAPIErrorReturnsTooManyRequestsError() {
        let message = "Too many requests message"
        let error = TMDbAPIError.tooManyRequests(message)

        let tmdbError = TMDbError(error: error)

        #expect(tmdbError == .tooManyRequests(message))
    }

    @Test("init when error is a TMDbAPIError.internalServerError returns serverError error")
    func initWithInternalServerErrorTMDbAPIErrorReturnsServerError() {
        let message = "Internal server error message"
        let error = TMDbAPIError.internalServerError(message)

        let tmdbError = TMDbError(error: error)

        #expect(tmdbError == .serverError(message))
    }

    @Test("init when error is a TMDbAPIError.notImplemented returns serverError error")
    func initWithNotImplementedTMDbAPIErrorReturnsServerError() {
        let message = "Not implemented message"
        let error = TMDbAPIError.notImplemented(message)

        let tmdbError = TMDbError(error: error)

        #expect(tmdbError == .serverError(message))
    }

    @Test("init when error is a TMDbAPIError.badGateway returns serverError error")
    func initWithBadGatewayTMDbAPIErrorReturnsServerError() {
        let message = "Bad gateway message"
        let error = TMDbAPIError.badGateway(message)

        let tmdbError = TMDbError(error: error)

        #expect(tmdbError == .serverError(message))
    }

    @Test("init when error is a TMDbAPIError.serviceUnavailable returns serverError error")
    func initWithServiceUnavailableTMDbAPIErrorReturnsServerError() {
        let message = "Service unavailable message"
        let error = TMDbAPIError.serviceUnavailable(message)

        let tmdbError = TMDbError(error: error)

        #expect(tmdbError == .serverError(message))
    }

    @Test("init when error is a TMDbAPIError.gatewayTimeout returns serverError error")
    func initWithGatewayTimeoutTMDbAPIErrorReturnsServerError() {
        let message = "Gateway timeout message"
        let error = TMDbAPIError.gatewayTimeout(message)

        let tmdbError = TMDbError(error: error)

        #expect(tmdbError == .serverError(message))
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

    @Test("init when error is a TMDbAPIError.unknown returns unknown error")
    func initWithUnknownTMDbAPIErrorReturnsUnknownError() {
        let error = TMDbAPIError.unknown

        let tmdbError = TMDbError(error: error)

        #expect(tmdbError == .unknown)
    }

    @Test("init when error is a TMDbAPIError.methodNotAllowed returns badRequest error")
    func initWithMethodNotAllowedTMDbAPIErrorReturnsBadRequestError() {
        let message = "Method not allowed message"
        let error = TMDbAPIError.methodNotAllowed(message)

        let tmdbError = TMDbError(error: error)

        #expect(tmdbError == .badRequest(message))
    }

    @Test("init when error is a TMDbAPIError.notAcceptable returns badRequest error")
    func initWithNotAcceptableTMDbAPIErrorReturnsBadRequestError() {
        let message = "Not acceptable message"
        let error = TMDbAPIError.notAcceptable(message)

        let tmdbError = TMDbError(error: error)

        #expect(tmdbError == .badRequest(message))
    }

    @Test("init when error is a TMDbAPIError.unprocessableContent returns badRequest error")
    func initWithUnprocessableContentTMDbAPIErrorReturnsBadRequestError() {
        let message = "Unprocessable content message"
        let error = TMDbAPIError.unprocessableContent(message)

        let tmdbError = TMDbError(error: error)

        #expect(tmdbError == .badRequest(message))
    }

    @Test("init when error is a TMDbAPIError.invalidURL returns badRequest error")
    func initWithInvalidURLTMDbAPIErrorReturnsBadRequestError() {
        let url = "https://invalid-url.example.com"
        let error = TMDbAPIError.invalidURL(url)

        let tmdbError = TMDbError(error: error)

        #expect(tmdbError == .badRequest("Invalid URL: \(url)"))
    }

    @Test("init when error is a TMDbAPIError.encode returns network error")
    func initWithEncodeTMDbAPIErrorReturnsNetworkError() {
        let encodeError = NSError(domain: "encode", code: -1)
        let error = TMDbAPIError.encode(encodeError)

        let tmdbError = TMDbError(error: error)

        #expect(tmdbError == .network(encodeError))
    }

}
