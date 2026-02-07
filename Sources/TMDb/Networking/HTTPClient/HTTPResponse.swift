//
//  HTTPResponse.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing an HTTP response.
///
public struct HTTPResponse: Sendable {

    ///
    /// The HTTP status code of the response.
    ///
    public let statusCode: Int

    ///
    /// Data returned in the response body.
    ///
    public let data: Data?

    ///
    /// HTTP response headers.
    ///
    public let headers: [String: String]

    ///
    /// Creates an HTTP response object.
    ///
    /// - Parameters:
    ///   - statusCode: The HTTP status code of the response.
    ///   - data: Data returned in the response body.
    ///   - headers: HTTP response headers.
    ///
    public init(statusCode: Int = 200, data: Data? = nil, headers: [String: String] = [:]) {
        self.statusCode = statusCode
        self.data = data
        self.headers = headers
    }

    ///
    /// The `Retry-After` header value as a `Duration`, if present and valid.
    ///
    /// Parses the `Retry-After` header using a case-insensitive key lookup.
    /// Only supports the `delta-seconds` format (integer number of seconds).
    /// The HTTP-date format is not supported and will return `nil`.
    ///
    public var retryAfterDuration: Duration? {
        let value = headers.first { $0.key.lowercased() == "retry-after" }?.value
        guard let value, let seconds = Int(value) else {
            return nil
        }

        return .seconds(seconds)
    }

}
