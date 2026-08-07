//
//  V4AuthorizationHeaders.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

extension [String: String] {

    ///
    /// The headers carrying a v4 user access token, if one was supplied.
    ///
    /// Setting `Authorization` on the request is what makes `TMDbAPIClient`
    /// treat the call as the *user's* rather than the application's: it then
    /// withholds the client credential and marks the request user-specific, so
    /// neither cache stores the response.
    ///
    /// - Parameter accessToken: The user's v4 access token, or `nil` to
    ///   authenticate with the client's own credential.
    ///
    /// - Returns: The headers for the request.
    ///
    static func v4Authorization(_ accessToken: String?) -> [String: String] {
        guard let accessToken else {
            return [:]
        }

        return ["Authorization": "Bearer \(accessToken)"]
    }

}
