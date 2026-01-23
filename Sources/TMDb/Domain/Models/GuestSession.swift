//
//  GuestSession.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a guest session.
///
public struct GuestSession: Codable, Equatable, Hashable, Sendable {

    ///
    /// Was session creation successful.
    ///
    public let success: Bool

    ///
    /// The identifier of this session.
    ///
    public let guestSessionID: String

    ///
    /// Date of session expiry.
    ///
    public let expiresAt: Date

}

extension GuestSession {

    private enum CodingKeys: String, CodingKey {

        case success
        case guestSessionID = "guestSessionId"
        case expiresAt

    }

}
