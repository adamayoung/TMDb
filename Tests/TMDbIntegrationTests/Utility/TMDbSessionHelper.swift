//
//  TMDbSessionHelper.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

actor TMDbSessionHelper {

    static let shared = TMDbSessionHelper()

    private let credentialHelper: CredentialHelper

    private init(credentialHelper: CredentialHelper = .shared) {
        self.credentialHelper = credentialHelper
    }

    func createSession() async throws -> Session {
        let apiKey = CredentialHelper.shared.tmdbAPIKey
        let tmdbClient = TMDbClient(apiKey: apiKey)
        let credential = credentialHelper.tmdbCredential

        return try await tmdbClient.authentication.createSession(withCredential: credential)
    }

    func delete(session: Session) async throws {
        let apiKey = CredentialHelper.shared.tmdbAPIKey
        let tmdbClient = TMDbClient(apiKey: apiKey)

        try await tmdbClient.authentication.deleteSession(session)
    }

}
