//
//  TMDbError+TMDbAPIError.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

extension TMDbError {

    init(error: some Error) {
        guard let apiError = error as? TMDbAPIError else {
            self = .unknown
            return
        }

        switch apiError {
        case .badRequest(let message):
            self = .badRequest(message)

        case .unauthorised(let message):
            self = .unauthorised(message)

        case .forbidden(let message):
            self = .forbidden(message)

        case .notFound(let message):
            self = .notFound(message)

        case .tooManyRequests(let message):
            self = .tooManyRequests(message)

        case .internalServerError(let message),
             .notImplemented(let message),
             .badGateway(let message),
             .serviceUnavailable(let message),
             .gatewayTimeout(let message):
            self = .serverError(message)

        case .network(let error):
            self = .network(error)

        case .decode(let error):
            self = .decode(error)

        default:
            self = .unknown
        }
    }

}
