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

    /// A **user** access token — the credential v4 writes require.
    ///
    /// Distinct from ``tmdbAccessToken``: that is the *application's* API Read
    /// Access Token, which can read public data but cannot touch a user's
    /// lists. This one is minted through the request-token → approve →
    /// access-token flow and identifies a person.
    ///
    /// Read from `TMDB_API_USER_TOKEN`.
    let tmdbUserAccessToken: String

    var hasAccessToken: Bool {
        !tmdbAccessToken.isEmpty
    }

    var hasUserAccessToken: Bool {
        !tmdbUserAccessToken.isEmpty
    }

    /// The account object id the user token belongs to, read from its JWT
    /// `sub` claim.
    ///
    /// Taken from the token rather than a separate secret, so there is one
    /// fewer credential to configure and no way for the two to disagree.
    /// Returns `nil` if the token is absent or not a decodable JWT, and the
    /// suites that need it skip rather than fail.
    var v4AccountObjectID: String? {
        Self.subjectClaim(ofJWT: tmdbUserAccessToken)
    }

    static func subjectClaim(ofJWT token: String) -> String? {
        let segments = token.split(separator: ".")
        guard segments.count >= 2 else {
            return nil
        }

        var base64 = String(segments[1])
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        base64 += String(repeating: "=", count: (4 - base64.count % 4) % 4)

        guard
            let data = Data(base64Encoded: base64),
            let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
            let subject = json["sub"] as? String
        else {
            return nil
        }

        return subject
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
        self.tmdbUserAccessToken = processInfo.environment["TMDB_API_USER_TOKEN"] ?? ""
    }

}
