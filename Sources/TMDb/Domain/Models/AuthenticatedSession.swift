//
//  AuthenticatedSession.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing an authenticated TMDb user — a user's account
/// identifier paired with the session that authorises requests on their behalf.
///
/// Many ``AccountService`` methods need both the account identifier and the
/// session. Bundling them into a single value removes the need to thread the
/// two through every call and keeps them from being mismatched. Obtain one with
/// ``AccountService/authenticatedSession(for:)``, or construct it directly when
/// the account identifier is already known.
///
/// - Important: ``session`` carries the user's session identifier, which is a
///   credential. Persisting an `AuthenticatedSession` is the caller's
///   responsibility and should use appropriately secure storage.
///
public struct AuthenticatedSession: Equatable, Hashable, Sendable {

    /// The user's account identifier.
    public let accountID: Int

    /// The user's TMDb session.
    public let session: Session

    ///
    /// Creates an authenticated session.
    ///
    /// - Parameters:
    ///   - accountID: The user's account identifier.
    ///   - session: The user's TMDb session.
    ///
    public init(accountID: Int, session: Session) {
        self.accountID = accountID
        self.session = session
    }

}
