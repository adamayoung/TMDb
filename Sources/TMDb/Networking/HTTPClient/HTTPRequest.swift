//
//  HTTPRequest.swift
//  TMDb
//
//  Copyright © 2025 Adam Young.
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
/// A model representing an HTTP request.
///
public struct HTTPRequest: Sendable {

    ///
    /// Request's URL.
    ///
    public let url: URL

    ///
    /// HTTP method.
    ///
    public let method: HTTPRequest.Method

    ///
    /// HTTP headers.
    ///
    public let headers: [String: String]

    ///
    /// Body data.
    ///
    public let body: Data?

    ///
    /// Create an HTTP request object.
    ///
    /// - Parameters:
    ///   - url: Request's URL.
    ///   - method: HTTP method.
    ///   - headers: HTTP headers.
    ///   - body: Body data.
    public init(
        url: URL,
        method: HTTPRequest.Method = .get,
        headers: [String: String] = [:],
        body: Data? = nil
    ) {
        self.url = url
        self.method = method
        self.headers = headers
        self.body = body
    }

}

extension HTTPRequest {

    ///
    /// An enumeration representing HTTP methods.
    ///
    public enum Method: String, Sendable {

        ///
        /// HTTP GET method.
        ///
        case get = "GET"

        ///
        /// HTTP POST method.
        ///
        case post = "POST"

        ///
        /// HTTP DELETE method.
        ///
        case delete = "DELETE"

    }

}
