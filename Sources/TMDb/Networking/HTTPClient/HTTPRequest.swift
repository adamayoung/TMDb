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
    /// Whether this request is authenticated as a specific user, rather than as
    /// the application.
    ///
    /// A custom ``HTTPClient`` **must not cache, store or log the response to a
    /// request where this is `true`**. Such a response is private to one user,
    /// yet its URL is identical for every user — the credential travels in a
    /// header — so caching it by URL would serve one user's data to another.
    ///
    /// This cannot be inferred from the presence of an `Authorization` header: a
    /// client created with ``TMDbClient/init(bearerToken:configuration:)`` sends
    /// one on every request, including entirely public ones.
    ///
    public let isUserSpecific: Bool

    ///
    /// Create an HTTP request object.
    ///
    /// - Parameters:
    ///   - url: Request's URL.
    ///   - method: HTTP method.
    ///   - headers: HTTP headers.
    ///   - body: Body data.
    ///   - isUserSpecific: Whether the request is authenticated as a specific
    ///     user. Defaults to `false`.
    public init(
        url: URL,
        method: HTTPRequest.Method = .get,
        headers: [String: String] = [:],
        body: Data? = nil,
        isUserSpecific: Bool = false
    ) {
        self.url = url
        self.method = method
        self.headers = headers
        self.body = body
        self.isUserSpecific = isUserSpecific
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

        ///
        /// HTTP PUT method.
        ///
        case put = "PUT"

    }

}
