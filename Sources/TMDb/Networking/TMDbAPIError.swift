//
//  TMDbAPIError.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a TMDb API error.
///
enum TMDbAPIError: Error, Equatable {

    ///
    /// Invalid URL.
    ///
    case invalidURL(String)

    ///
    /// Network error.
    ///
    case network(Error)

    ///
    /// Bad request.
    ///
    case badRequest(TMDbErrorContext)

    ///
    /// Unauthorised.
    ///
    case unauthorised(TMDbErrorContext)

    ///
    /// Forbidden.
    ///
    case forbidden(TMDbErrorContext)

    ///
    /// Not found.
    ///
    case notFound(TMDbErrorContext)

    ///
    /// Method not allowed.
    ///
    case methodNotAllowed(TMDbErrorContext)

    ///
    /// Not acceptable.
    ///
    case notAcceptable(TMDbErrorContext)

    ///
    /// Unprocessable content.
    ///
    case unprocessableContent(TMDbErrorContext)

    ///
    /// Too many requests.
    ///
    case tooManyRequests(TMDbErrorContext)

    ///
    /// Internal server error.
    ///
    case internalServerError(TMDbErrorContext)

    ///
    /// Not implemented.
    ///
    case notImplemented(TMDbErrorContext)

    ///
    /// Bad gateway.
    ///
    case badGateway(TMDbErrorContext)

    ///
    /// Service unavailable.
    ///
    case serviceUnavailable(TMDbErrorContext)

    ///
    /// Gateway timeout.
    ///
    case gatewayTimeout(TMDbErrorContext)

    ///
    /// Data encode error.
    ///
    case encode(Error)

    ///
    /// Data decode error.
    ///
    case decode(Error)

    ///
    /// Unknown error.
    ///
    case unknown

    static func == (lhs: TMDbAPIError, rhs: TMDbAPIError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL(let l), .invalidURL(let r)):
            l == r

        case (.network, .network):
            true

        case (.badRequest(let l), .badRequest(let r)):
            l == r

        case (.unauthorised(let l), .unauthorised(let r)):
            l == r

        case (.forbidden(let l), .forbidden(let r)):
            l == r

        case (.notFound(let l), .notFound(let r)):
            l == r

        case (.methodNotAllowed(let l), .methodNotAllowed(let r)):
            l == r

        case (.notAcceptable(let l), .notAcceptable(let r)):
            l == r

        case (.unprocessableContent(let l), .unprocessableContent(let r)):
            l == r

        case (.tooManyRequests(let l), .tooManyRequests(let r)):
            l == r

        case (.internalServerError(let l), .internalServerError(let r)):
            l == r

        case (.notImplemented(let l), .notImplemented(let r)):
            l == r

        case (.badGateway(let l), .badGateway(let r)):
            l == r

        case (.serviceUnavailable(let l), .serviceUnavailable(let r)):
            l == r

        case (.gatewayTimeout(let l), .gatewayTimeout(let r)):
            l == r

        case (.encode, .encode):
            true

        case (.decode, .decode):
            true

        case (.unknown, .unknown):
            true

        default:
            false
        }
    }

}
