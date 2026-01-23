//
//  Token.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing an internediate request token.
///
public struct Token: Codable, Equatable, Hashable, Sendable {

    ///
    /// Was token creation successful.
    ///
    public let success: Bool

    ///
    /// An intermediate request token.
    ///
    public let requestToken: String

    ///
    /// Date of token expiry.
    ///
    public let expiresAt: Date

    ///
    /// Creates an internediate request token object.
    ///
    /// - Parameters:
    ///   - success: Was token creation successful.
    ///   - requestToken: An intermediate request token.
    ///   - expiresAt: Date of token expiry.
    ///
    public init(success: Bool, requestToken: String, expiresAt: Date) {
        self.success = success
        self.requestToken = requestToken
        self.expiresAt = expiresAt
    }

}
