//
//  TMDbAPIError+HTTPStatusCode.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

import Foundation

extension TMDbAPIError {

    init(statusCode: Int, message: String?) {
        switch statusCode {
        case 400:
            self = .badRequest(message)

        case 401:
            self = .unauthorised(message)

        case 403:
            self = .forbidden(message)

        case 404:
            self = .notFound(message)

        case 405:
            self = .methodNotAllowed(message)

        case 406:
            self = .notAcceptable(message)

        case 422:
            self = .unprocessableContent(message)

        case 429:
            self = .tooManyRequests(message)

        case 500:
            self = .internalServerError(message)

        case 501:
            self = .notImplemented(message)

        case 502:
            self = .badGateway(message)

        case 503:
            self = .serviceUnavailable(message)

        case 504:
            self = .gatewayTimeout(message)

        default:
            self = .unknown
        }
    }

}
