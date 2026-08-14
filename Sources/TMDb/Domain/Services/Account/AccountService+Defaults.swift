//
//  AccountService+Defaults.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public extension AccountService {

    ///
    /// Returns a list of the user's custom lists.
    ///
    /// - Parameters:
    ///   - accountID: The user's account identifier.
    ///   - session: The user's TMDb session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A list of the user's custom lists.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that
    /// its signature stays distinct from the requirement it forwards to. A
    /// defaulted overload would instead become that requirement's default
    /// implementation.
    ///
    func lists(
        accountID: Int,
        session: Session
    ) async throws(TMDbError) -> MediaListSummaryPageableList {
        try await lists(
            page: nil,
            accountID: accountID,
            session: session
        )
    }

}
