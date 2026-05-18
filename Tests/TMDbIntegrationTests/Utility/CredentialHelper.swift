//
//  CredentialHelper.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

final class CredentialHelper: Sendable {

    static let shared = CredentialHelper()

    let tmdbCredential: Credential
    let tmdbAPIKey: String

    var hasCredential: Bool {
        !tmdbCredential.username.isEmpty && !tmdbCredential.password.isEmpty
    }

    var hasAPIKey: Bool {
        !tmdbAPIKey.isEmpty
    }

    /// Returns a `TMDbClient` configured with the integration-test API key
    /// and automatic retry on rate-limit and server errors.
    ///
    /// Integration suites hitting the live TMDb API should use this factory
    /// so transient HTTP 429 / 5xx responses are retried with backoff that
    /// honours `Retry-After`.
    func makeClient(
        configuration: TMDbConfiguration = TMDbConfiguration(retry: .default)
    ) -> TMDbClient {
        TMDbClient(apiKey: tmdbAPIKey, configuration: configuration)
    }

    private init(processInfo: ProcessInfo = ProcessInfo.processInfo) {
        let username = processInfo.environment["TMDB_USERNAME"] ?? ""
        let password = processInfo.environment["TMDB_PASSWORD"] ?? ""
        self.tmdbCredential = Credential(username: username, password: password)

        self.tmdbAPIKey = processInfo.environment["TMDB_API_KEY"] ?? ""
    }

}
