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

    /// The API Read Access Token — the *application* bearer credential.
    ///
    /// This is not the v3 API key: the v4 endpoints authenticate with a bearer
    /// token and reject an `api_key`, so suites exercising them need this.
    ///
    /// Read from `TMDB_ACCESS_TOKEN`, falling back to
    /// `TMDB_API_READ_ONLY_TOKEN` — the name TMDb itself uses on the settings
    /// page. They are the same credential, so either may be set.
    let tmdbAccessToken: String

    var hasCredential: Bool {
        !tmdbCredential.username.isEmpty && !tmdbCredential.password.isEmpty
    }

    var hasAPIKey: Bool {
        !tmdbAPIKey.isEmpty
    }

    var hasAccessToken: Bool {
        !tmdbAccessToken.isEmpty
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
        self.tmdbAccessToken =
            processInfo.environment["TMDB_ACCESS_TOKEN"]
                ?? processInfo.environment["TMDB_API_READ_ONLY_TOKEN"]
                ?? ""
    }

}
