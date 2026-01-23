//
//  HTTPClient.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// An interface for performing network tasks.
///
public protocol HTTPClient: Sendable {

    ///
    /// Performs an HTTP request.
    ///
    /// - Parameter request: The HTTP request.
    ///
    /// - Throws: `Error`.
    ///
    /// - Returns: An HTTP response object.
    ///
    func perform(request: HTTPRequest) async throws -> HTTPResponse

}
