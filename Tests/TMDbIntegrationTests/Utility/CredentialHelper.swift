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

    private init(processInfo: ProcessInfo = ProcessInfo.processInfo) {
        let username = processInfo.environment["TMDB_USERNAME"] ?? ""
        let password = processInfo.environment["TMDB_PASSWORD"] ?? ""
        self.tmdbCredential = Credential(username: username, password: password)

        self.tmdbAPIKey = processInfo.environment["TMDB_API_KEY"] ?? ""
    }

}
