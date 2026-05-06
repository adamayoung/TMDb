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
/// `TMDbAuthenticationService`; every other service uses `apiClient`.
struct TMDbServiceDependencies {

    let apiClient: any APIClient
    let authAPIClient: any APIClient
    let authenticateURLBuilder: any AuthenticateURLBuilding

}
