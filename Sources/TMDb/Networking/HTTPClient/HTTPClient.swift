//
//  HTTPClient.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

import Foundation

///
/// An interface for performing network tasks.
///
public protocol HTTPClient {

    ///
    /// Performs an HTTP GET request.
    ///
    /// - Parameters:
    ///   - url: The URL to use for the request.
    ///   - headers: Additional HTTP headers to use in the request.
    ///
    /// - Returns: An HTTP response object.
    ///
    func get(url: URL, headers: [String: String]) async throws -> HTTPResponse

}
