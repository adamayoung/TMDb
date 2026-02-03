//
//  TMDbAPIErrorHTTPStatusCodeTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.networking))
struct TMDbAPIErrorHTTPStatusCodeTests {

    @Test("Bad request")
    func badRequest() {
        let statusCode = 400
        let message = "Some error message"
        let expectedError = TMDbAPIError.badRequest(message)

        let error = TMDbAPIError(statusCode: statusCode, message: message)

        #expect(error == expectedError)
    }

    @Test("Unauthorised")
    func testUnauthorised() {
        let statusCode = 401
        let message = "Some error message"
        let expectedError = TMDbAPIError.unauthorised(message)

        let error = TMDbAPIError(statusCode: statusCode, message: message)

        #expect(error == expectedError)
    }

    @Test("Forbidden")
    func forbidden() {
        let statusCode = 403
        let message = "Some error message"
        let expectedError = TMDbAPIError.forbidden(message)

        let error = TMDbAPIError(statusCode: statusCode, message: message)

        #expect(error == expectedError)
    }

    @Test("Not found")
    func notFound() {
        let statusCode = 404
        let message = "Some error message"
        let expectedError = TMDbAPIError.notFound(message)

        let error = TMDbAPIError(statusCode: statusCode, message: message)

        #expect(error == expectedError)
    }

    @Test("Method not allowed")
    func methodNotAllowed() {
        let statusCode = 405
        let message = "Some error message"
        let expectedError = TMDbAPIError.methodNotAllowed(message)

        let error = TMDbAPIError(statusCode: statusCode, message: message)

        #expect(error == expectedError)
    }

    @Test("Not acceptable")
    func notAcceptable() {
        let statusCode = 406
        let message = "Some error message"
        let expectedError = TMDbAPIError.notAcceptable(message)

        let error = TMDbAPIError(statusCode: statusCode, message: message)

        #expect(error == expectedError)
    }

    @Test("Unprocessable content")
    func unprocessableContent() {
        let statusCode = 422
        let message = "Some error message"
        let expectedError = TMDbAPIError.unprocessableContent(message)

        let error = TMDbAPIError(statusCode: statusCode, message: message)

        #expect(error == expectedError)
    }

    @Test("Too many requests")
    func tooManyRequests() {
        let statusCode = 429
        let message = "Some error message"
        let expectedError = TMDbAPIError.tooManyRequests(message)

        let error = TMDbAPIError(statusCode: statusCode, message: message)

        #expect(error == expectedError)
    }

    @Test("Internal server error")
    func internalServerError() {
        let statusCode = 500
        let message = "Some error message"
        let expectedError = TMDbAPIError.internalServerError(message)

        let error = TMDbAPIError(statusCode: statusCode, message: message)

        #expect(error == expectedError)
    }

    @Test("Not implemented")
    func notImplemented() {
        let statusCode = 501
        let message = "Some error message"
        let expectedError = TMDbAPIError.notImplemented(message)

        let error = TMDbAPIError(statusCode: statusCode, message: message)

        #expect(error == expectedError)
    }

    @Test("Bad gateway")
    func badGateway() {
        let statusCode = 502
        let message = "Some error message"
        let expectedError = TMDbAPIError.badGateway(message)

        let error = TMDbAPIError(statusCode: statusCode, message: message)

        #expect(error == expectedError)
    }

    @Test("Service unavailable")
    func serviceUnavailable() {
        let statusCode = 503
        let message = "Some error message"
        let expectedError = TMDbAPIError.serviceUnavailable(message)

        let error = TMDbAPIError(statusCode: statusCode, message: message)

        #expect(error == expectedError)
    }

    @Test("Gateway timeout")
    func gatewayTimeout() {
        let statusCode = 504
        let message = "Some error message"
        let expectedError = TMDbAPIError.gatewayTimeout(message)

        let error = TMDbAPIError(statusCode: statusCode, message: message)

        #expect(error == expectedError)
    }

    @Test("Unknown")
    func unknown() {
        let statusCode = 999
        let expectedError = TMDbAPIError.unknown

        let error = TMDbAPIError(statusCode: statusCode, message: nil)

        #expect(error == expectedError)
    }

}
