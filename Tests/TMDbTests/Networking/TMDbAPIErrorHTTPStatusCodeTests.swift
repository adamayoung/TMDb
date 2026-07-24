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

    @Test("init(context:) selects the error case from the HTTP status code")
    func initSelectsCaseFromStatusCode() {
        let expectations: [(Int, (TMDbErrorContext) -> TMDbAPIError)] = [
            (400, TMDbAPIError.badRequest),
            (401, TMDbAPIError.unauthorised),
            (403, TMDbAPIError.forbidden),
            (404, TMDbAPIError.notFound),
            (405, TMDbAPIError.methodNotAllowed),
            (406, TMDbAPIError.notAcceptable),
            (422, TMDbAPIError.unprocessableContent),
            (429, TMDbAPIError.tooManyRequests),
            (500, TMDbAPIError.internalServerError),
            (501, TMDbAPIError.notImplemented),
            (502, TMDbAPIError.badGateway),
            (503, TMDbAPIError.serviceUnavailable),
            (504, TMDbAPIError.gatewayTimeout)
        ]

        for (statusCode, makeExpected) in expectations {
            let context = TMDbErrorContext(httpStatusCode: statusCode)

            #expect(TMDbAPIError(context: context) == makeExpected(context))
        }
    }

    @Test("init(context:) carries the full context through")
    func initCarriesContext() {
        let context = TMDbErrorContext(
            httpStatusCode: 404,
            tmdbStatusCode: .resourceNotFound,
            statusMessage: "The resource you requested could not be found.",
            endpointPath: "/movie/999",
            retryAfter: nil
        )

        #expect(TMDbAPIError(context: context) == .notFound(context))
    }

    @Test("init(context:) falls back by range for an unmapped 4xx status")
    func initFallsBackToBadRequestForUnmapped4xx() {
        let context = TMDbErrorContext(httpStatusCode: 418)

        #expect(TMDbAPIError(context: context) == .badRequest(context))
    }

    @Test("init(context:) falls back by range for an unmapped 5xx status")
    func initFallsBackToServerErrorForUnmapped5xx() {
        let context = TMDbErrorContext(httpStatusCode: 599)

        #expect(TMDbAPIError(context: context) == .internalServerError(context))
    }

    @Test("init(context:) is unknown when the status is missing")
    func initIsUnknownWhenStatusMissing() {
        #expect(TMDbAPIError(context: TMDbErrorContext()) == .unknown)
    }

    @Test("init(context:) is unknown for a non-4xx/5xx status")
    func initIsUnknownForNon4xx5xxStatus() {
        #expect(TMDbAPIError(context: TMDbErrorContext(httpStatusCode: 301)) == .unknown)
    }

}
