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

    private let context = TMDbErrorContext(statusMessage: "message")

    @Test("invalidURL errors equal")
    func invalidURLErrorsEqual() {
        #expect(TMDbAPIError.invalidURL("message") == TMDbAPIError.invalidURL("message"))
    }

    @Test("network errors equal")
    func networkErrorsEqual() {
        let error1 = TMDbAPIError.network(MockError(message: "message"))
        let error2 = TMDbAPIError.network(MockError(message: "message"))

        #expect(error1 == error2)
    }

    @Test("badRequest errors with equal context equal")
    func badRequestErrorsEqual() {
        #expect(TMDbAPIError.badRequest(context) == TMDbAPIError.badRequest(context))
    }

    @Test("unauthorised errors with equal context equal")
    func unauthorisedErrorsEqual() {
        #expect(TMDbAPIError.unauthorised(context) == TMDbAPIError.unauthorised(context))
    }

    @Test("forbidden errors with equal context equal")
    func forbiddenErrorsEqual() {
        #expect(TMDbAPIError.forbidden(context) == TMDbAPIError.forbidden(context))
    }

    @Test("notFound errors with equal context equal")
    func notFoundErrorsEqual() {
        #expect(TMDbAPIError.notFound(context) == TMDbAPIError.notFound(context))
    }

    @Test("methodNotAllowed errors with equal context equal")
    func methodNotAllowedErrorsEqual() {
        #expect(TMDbAPIError.methodNotAllowed(context) == TMDbAPIError.methodNotAllowed(context))
    }

    @Test("notAcceptable errors with equal context equal")
    func notAcceptableErrorsEqual() {
        #expect(TMDbAPIError.notAcceptable(context) == TMDbAPIError.notAcceptable(context))
    }

    @Test("unprocessableContent errors with equal context equal")
    func unprocessableContentErrorsEqual() {
        #expect(TMDbAPIError.unprocessableContent(context) == TMDbAPIError.unprocessableContent(context))
    }

    @Test("tooManyRequests errors with equal context equal")
    func tooManyRequestsErrorsEqual() {
        #expect(TMDbAPIError.tooManyRequests(context) == TMDbAPIError.tooManyRequests(context))
    }

    @Test("internalServerError errors with equal context equal")
    func internalServerErrorErrorsEqual() {
        #expect(TMDbAPIError.internalServerError(context) == TMDbAPIError.internalServerError(context))
    }

    @Test("notImplemented errors with equal context equal")
    func notImplementedErrorsEqual() {
        #expect(TMDbAPIError.notImplemented(context) == TMDbAPIError.notImplemented(context))
    }

    @Test("badGateway errors with equal context equal")
    func badGatewayErrorsEqual() {
        #expect(TMDbAPIError.badGateway(context) == TMDbAPIError.badGateway(context))
    }

    @Test("serviceUnavailable errors with equal context equal")
    func serviceUnavailableErrorsEqual() {
        #expect(TMDbAPIError.serviceUnavailable(context) == TMDbAPIError.serviceUnavailable(context))
    }

    @Test("gatewayTimeout errors with equal context equal")
    func gatewayTimeoutErrorsEqual() {
        #expect(TMDbAPIError.gatewayTimeout(context) == TMDbAPIError.gatewayTimeout(context))
    }

    @Test("errors with different context do not equal")
    func errorsWithDifferentContextDoNotEqual() {
        let lhs = TMDbAPIError.notFound(TMDbErrorContext(httpStatusCode: 404))
        let rhs = TMDbAPIError.notFound(TMDbErrorContext(httpStatusCode: 400))

        #expect(lhs != rhs)
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
        #expect(TMDbAPIError.unknown == TMDbAPIError.unknown)
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
