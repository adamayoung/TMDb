//
//  TMDbAPIErrorTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.networking))
struct TMDbAPIErrorTests {

    @Test("invalidURL errors equal")
    func invalidURLErrorsEqual() {
        let error1 = TMDbAPIError.invalidURL("message")
        let error2 = TMDbAPIError.invalidURL("message")

        #expect(error1 == error2)
    }

    @Test("network errors equal")
    func networkErrorsEqual() {
        let error1 = TMDbAPIError.network(MockError(message: "message"))
        let error2 = TMDbAPIError.network(MockError(message: "message"))

        #expect(error1 == error2)
    }

    @Test("badRequest errors equal")
    func badRequestErrorsEqual() {
        let error1 = TMDbAPIError.badRequest("message")
        let error2 = TMDbAPIError.badRequest("message")

        #expect(error1 == error2)
    }

    @Test("unauthorised errors equal")
    func unauthorisedErrorsEqual() {
        let error1 = TMDbAPIError.unauthorised("message")
        let error2 = TMDbAPIError.unauthorised("message")

        #expect(error1 == error2)
    }

    @Test("forbidden errors equal")
    func forbiddenErrorsEqual() {
        let error1 = TMDbAPIError.forbidden("message")
        let error2 = TMDbAPIError.forbidden("message")

        #expect(error1 == error2)
    }

    @Test("notFound errors equal")
    func notFoundErrorsEqual() {
        let error1 = TMDbAPIError.notFound("message")
        let error2 = TMDbAPIError.notFound("message")

        #expect(error1 == error2)
    }

    @Test("methodNotAllowed errors equal")
    func methodNotAllowedErrorsEqual() {
        let error1 = TMDbAPIError.methodNotAllowed("message")
        let error2 = TMDbAPIError.methodNotAllowed("message")

        #expect(error1 == error2)
    }

    @Test("notAcceptable errors equal")
    func notAcceptableErrorsEqual() {
        let error1 = TMDbAPIError.notAcceptable("message")
        let error2 = TMDbAPIError.notAcceptable("message")

        #expect(error1 == error2)
    }

    @Test("unprocessableContent errors equal")
    func unprocessableContentErrorsEqual() {
        let error1 = TMDbAPIError.unprocessableContent("message")
        let error2 = TMDbAPIError.unprocessableContent("message")

        #expect(error1 == error2)
    }

    @Test("tooManyRequests errors equal")
    func tooManyRequestsErrorsEqual() {
        let error1 = TMDbAPIError.tooManyRequests("message")
        let error2 = TMDbAPIError.tooManyRequests("message")

        #expect(error1 == error2)
    }

    @Test("internalServerError errors equal")
    func internalServerErrorErrorsEqual() {
        let error1 = TMDbAPIError.internalServerError("message")
        let error2 = TMDbAPIError.internalServerError("message")

        #expect(error1 == error2)
    }

    @Test("notImplemented errors equal")
    func notImplementedErrorsEqual() {
        let error1 = TMDbAPIError.notImplemented("message")
        let error2 = TMDbAPIError.notImplemented("message")

        #expect(error1 == error2)
    }

    @Test("badGateway errors equal")
    func badGatewayErrorsEqual() {
        let error1 = TMDbAPIError.badGateway("message")
        let error2 = TMDbAPIError.badGateway("message")

        #expect(error1 == error2)
    }

    @Test("serviceUnavailable errors equal")
    func serviceUnavailableErrorsEqual() {
        let error1 = TMDbAPIError.serviceUnavailable("message")
        let error2 = TMDbAPIError.serviceUnavailable("message")

        #expect(error1 == error2)
    }

    @Test("gatewayTimeout errors equal")
    func gatewayTimeoutErrorsEqual() {
        let error1 = TMDbAPIError.gatewayTimeout("message")
        let error2 = TMDbAPIError.gatewayTimeout("message")

        #expect(error1 == error2)
    }

    @Test("encode errors equal")
    func encodeErrorsEqual() {
        let error1 = TMDbAPIError.encode(MockError(message: "message"))
        let error2 = TMDbAPIError.encode(MockError(message: "message"))

        #expect(error1 == error2)
    }

    @Test("decode errors equal")
    func decodeErrorsEqual() {
        let error1 = TMDbAPIError.decode(MockError(message: "message"))
        let error2 = TMDbAPIError.decode(MockError(message: "message"))

        #expect(error1 == error2)
    }

    @Test("unknown errors equal")
    func unknownErrorsEqual() {
        let error1 = TMDbAPIError.unknown
        let error2 = TMDbAPIError.unknown

        #expect(error1 == error2)
    }

    @Test("encode and decode errors do not equal")
    func encodeAndDecodeErrorsDoNotEqual() {
        let error1 = TMDbAPIError.encode(MockError(message: "message 1"))
        let error2 = TMDbAPIError.decode(MockError(message: "message 2"))

        #expect(error1 != error2)
    }

}

extension TMDbAPIErrorTests {

    struct MockError: Error {
        let message: String

        init(message: String = "some message") {
            self.message = message
        }
    }

}
