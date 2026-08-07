//
//  V4AuthenticateURLBuilding.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

/// Builds the URL at which a TMDb user approves a v4 request token.
///
/// Unlike the v3 builder there is no `redirectURL` variant: v4 carries
/// `redirect_to` on the create-request-token request body, not on the
/// approval URL.
protocol V4AuthenticateURLBuilding: Sendable {

    func authenticateURL(with requestToken: String) -> URL

}
