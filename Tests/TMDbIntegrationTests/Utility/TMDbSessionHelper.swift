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

    private var sessionCache: CacheEntry?

    private init(credentialHelper: CredentialHelper = .shared) {
        self.credentialHelper = credentialHelper
    }

    //    func session() async throws -> Session {
    //        if let sessionCache {
    //            switch sessionCache {
    //            case .ready(let session):
    //                return session
    //
    //            case .inProgress(let task):
    //                return try await task.value
    //            }
    //        }
    //
    //        let apiKey = CredentialHelper.shared.tmdbAPIKey
    //        let tmdbClient = TMDbClient(apiKey: apiKey)
    //        let credential = credentialHelper.tmdbCredential
    //
    //        let task = Task {
    //            try await tmdbClient.authentication.createSession(withCredential: credential)
    //        }
    //
    //        sessionCache = .inProgress(task)
    //
    //        do {
    //            let session = try await task.value
    //            sessionCache = .ready(session)
    //            return session
    //        } catch {
    //            sessionCache = nil
    //            throw error
    //        }
    //    }

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

extension TMDbSessionHelper {

    private enum CacheEntry {
        case inProgress(Task<Session, Error>)
        case ready(Session)
    }

}
