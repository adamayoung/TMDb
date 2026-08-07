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
    /// Whether this request requires a specific user's credential, rather than
    /// the application's.
    ///
    /// A custom ``HTTPClient`` **must not cache, store or log the response to a
    /// request where this is `true`** — it is one user's private data.
    ///
    /// It is `true` for all three of TMDb's user-scoped mechanisms: a v4 user
    /// access token passed per call, a v3 `session_id`, and a guest session.
    /// Where the token travels in a header, two users' requests for the same
    /// resource have *identical* URLs, so a URL-keyed cache would serve one
    /// user's data to another; where it travels in the URL the keys differ, but
    /// the response is still private and must not be written to a shared store.
    ///
    /// It cannot be inferred from the presence of an `Authorization` header
    /// alone: a client created with ``TMDbClient/init(bearerToken:configuration:)``
    /// sends one on every request, including wholly public ones, and those
    /// remain cacheable.
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
