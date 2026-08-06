//
//  TMDbServiceDependencies.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

/// Plumbing primitives shared by `TMDbClient` when wiring its services.
///
/// `authAPIClient` (a separate `APIClient` configured with the auth-token
/// JSON serialiser) and `authenticateURLBuilder` exist solely for
/// `TMDbAuthenticationService`; every other v3 service uses `apiClient`.
///
/// `v4APIClient` differs from `apiClient` only in its base URL — it targets
/// the v4 API rather than v3 — and, with `v4AuthenticateURLBuilder`, serves
/// `TMDbV4AuthenticationService`.
struct TMDbServiceDependencies {

    let apiClient: any APIClient
    let authAPIClient: any APIClient
    let v4APIClient: any APIClient
    let authenticateURLBuilder: any AuthenticateURLBuilding
    let v4AuthenticateURLBuilder: any V4AuthenticateURLBuilding

}
