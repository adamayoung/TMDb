//
//  TMDbAPIError+HTTPStatusCode.swift
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
