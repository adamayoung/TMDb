//
//  HTTPRequest.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
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

public extension HTTPRequest {

    ///
    /// An enumeration representing HTTP methods.
    ///
    enum Method: String, Sendable {

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
