//
//  Credential.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a user's TMDb username and password.
///
public struct Credential: Sendable {

    ///
    /// User's username.
    ///
    public let username: String

    ///
    /// User's password.
    ///
    public let password: String

    ///
    /// Creates a user credential object.
    ///
    /// - Parameters:
    ///   - username: User's username.
    ///   - password: User's password.
    ///
    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }

}
