//
//  V4RequestToken.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing an intermediate TMDb v4 request token.
///
/// A request token is a temporary credential that must be approved by the user
/// in a web browser before it can be exchanged for a ``V4AccessToken``. Take
/// the user to the URL built by
/// ``V4AuthenticationService/authenticateURL(for:)`` to obtain that approval.
///
/// Request tokens expire 15 minutes after they are issued.
///
public struct V4RequestToken: Codable, Equatable, Hashable, Sendable {

    ///
    /// Was request token creation successful.
    ///
    public let success: Bool

    ///
    /// An intermediate request token, pending user approval.
    ///
    public let requestToken: String

    ///
    /// Creates an intermediate TMDb v4 request token object.
    ///
    /// - Parameters:
    ///   - success: Was request token creation successful.
    ///   - requestToken: An intermediate request token, pending user approval.
    ///
    public init(success: Bool, requestToken: String) {
        self.success = success
        self.requestToken = requestToken
    }

}
