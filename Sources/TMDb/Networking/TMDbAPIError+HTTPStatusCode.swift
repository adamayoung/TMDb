//
//  TMDbAPIError+HTTPStatusCode.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

extension TMDbAPIError {

    ///
    /// Creates an API error from response context, choosing the case from the
    /// context's HTTP status code.
    ///
    /// A status code without a dedicated case falls back by range so the context
    /// is never lost: any other `4xx` becomes ``badRequest(_:)`` and any other
    /// `5xx` becomes ``internalServerError(_:)``. A missing or non-`4xx`/`5xx`
    /// status becomes ``unknown``.
    ///
    /// - Parameter context: The context describing the failed response.
    ///
    init(context: TMDbErrorContext) {
        guard let statusCode = context.httpStatusCode else {
            self = .unknown
            return
        }

        switch statusCode {
        case 400:
            self = .badRequest(context)

        case 401:
            self = .unauthorised(context)

        case 403:
            self = .forbidden(context)

        case 404:
            self = .notFound(context)

        case 405:
            self = .methodNotAllowed(context)

        case 406:
            self = .notAcceptable(context)

        case 422:
            self = .unprocessableContent(context)

        case 429:
            self = .tooManyRequests(context)

        case 500:
            self = .internalServerError(context)

        case 501:
            self = .notImplemented(context)

        case 502:
            self = .badGateway(context)

        case 503:
            self = .serviceUnavailable(context)

        case 504:
            self = .gatewayTimeout(context)

        case 400 ... 499:
            self = .badRequest(context)

        case 500 ... 599:
            self = .internalServerError(context)

        default:
            self = .unknown
        }
    }

}
