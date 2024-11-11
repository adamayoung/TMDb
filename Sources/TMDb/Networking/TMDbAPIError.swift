//
//  TMDbAPIError.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
    case badRequest(String?)

    ///
    /// Unauthorised.
    ///
    case unauthorised(String?)

    ///
    /// Forbidden.
    ///
    case forbidden(String?)

    ///
    /// Not found.
    ///
    case notFound(String?)

    ///
    /// Method not allowed.
    ///
    case methodNotAllowed(String?)

    ///
    /// Not acceptable.
    ///
    case notAcceptable(String?)

    ///
    /// Unprocessable content.
    ///
    case unprocessableContent(String?)

    ///
    /// Too many requests.
    ///
    case tooManyRequests(String?)

    ///
    /// Internal server error.
    ///
    case internalServerError(String?)

    ///
    /// Not implemented.
    ///
    case notImplemented(String?)

    ///
    /// Bad gateway.
    ///
    case badGateway(String?)

    ///
    /// Service unavailable.
    ///
    case serviceUnavailable(String?)

    ///
    /// Gateway timeout.
    ///
    case gatewayTimeout(String?)

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
