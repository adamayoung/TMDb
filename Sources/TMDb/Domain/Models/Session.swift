//
//  Session.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a TMDb session.
///
public struct Session: Codable, Equatable, Hashable, Sendable {

    ///
    /// Was session creation successful.
    ///
    public let success: Bool

    ///
    /// The session identifier.
    ///
    public let sessionID: String

    ///
    /// Creates a TMDb session object..
    ///
    /// - Parameters:
    ///   - success: Was token creation successful.
    ///   - sessionID: The session identifier.
    ///
    public init(success: Bool, sessionID: String) {
        self.success = success
        self.sessionID = sessionID
    }

}

extension Session {

    private enum CodingKeys: String, CodingKey {
        case success
        case sessionID = "sessionId"
    }

}
