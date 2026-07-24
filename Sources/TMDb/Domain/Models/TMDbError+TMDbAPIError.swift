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
        case .badRequest(let context):
            self = .badRequest(context)

        case .unauthorised(let context):
            self = .unauthorised(context)

        case .forbidden(let context):
            self = .forbidden(context)

        case .notFound(let context):
            self = .notFound(context)

        case .tooManyRequests(let context):
            self = .tooManyRequests(context)

        case .internalServerError(let context),
             .notImplemented(let context),
             .badGateway(let context),
             .serviceUnavailable(let context),
             .gatewayTimeout(let context):
            self = .serverError(context)

        case .methodNotAllowed(let context),
             .notAcceptable(let context),
             .unprocessableContent(let context):
            self = .badRequest(context)

        case .invalidURL(let url):
            self = .invalidURL(url)

        case .network(let error):
            self = .network(error)

        case .decode(let error):
            self = .decode(error)

        case .encode(let error):
            self = .encode(error)

        case .unknown:
            self = .unknown
        }
    }

}
