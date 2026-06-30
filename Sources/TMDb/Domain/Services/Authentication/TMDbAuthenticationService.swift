//
//  TMDbAuthenticationService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
final class TMDbAuthenticationService: AuthenticationService {

    private let apiClient: any APIClient
    private let authenticateURLBuilder: any AuthenticateURLBuilding

    init(
        apiClient: some APIClient,
        authenticateURLBuilder: some AuthenticateURLBuilding
    ) {
        self.apiClient = apiClient
        self.authenticateURLBuilder = authenticateURLBuilder
    }

    func guestSession() async throws(TMDbError) -> GuestSession {
        let request = CreateGuestSessionRequest()

        return try await apiClient.perform(request)
    }

    func requestToken() async throws(TMDbError) -> Token {
        let request = CreateRequestTokenRequest()

        return try await apiClient.perform(request)
    }

    func authenticateURL(for token: Token, redirectURL: URL? = nil) -> URL {
        authenticateURLBuilder.authenticateURL(
            with: token.requestToken, redirectURL: redirectURL
        )
    }

    func createSession(withToken token: Token) async throws(TMDbError) -> Session {
        let request = CreateSessionRequest(requestToken: token.requestToken)

        return try await apiClient.perform(request)
    }

    func createSession(withV4AccessToken v4AccessToken: String) async throws(TMDbError) -> Session {
        try Self.validate(accessToken: v4AccessToken)
        let request = CreateSessionFromV4AccessTokenRequest(
            accessToken: v4AccessToken
        )

        return try await apiClient.perform(request)
    }

    func createSession(withCredential credential: Credential) async throws(TMDbError) -> Session {
        try Self.validate(credential: credential)
        let token = try await requestToken()

        let request = ValidateTokenWithLoginRequest(
            username: credential.username,
            password: credential.password,
            requestToken: token.requestToken
        )

        let validatedToken = try await apiClient.perform(request)

        return try await createSession(withToken: validatedToken)
    }

    @discardableResult
    func deleteSession(_ session: Session) async throws(TMDbError) -> Bool {
        let request = DeleteSessionRequest(sessionID: session.sessionID)

        return try await apiClient.perform(request).success
    }

    func validateKey() async throws(TMDbError) -> Bool {
        let request = ValidateKeyRequest()

        return try await apiClient.perform(request).success
    }

}

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
extension TMDbAuthenticationService {

    private static func validate(accessToken: String) throws(TMDbError) {
        try accessToken.validateNotEmpty(message: "Access token must not be empty")
    }

    private static func validate(credential: Credential) throws(TMDbError) {
        try credential.username.validateNotEmpty(message: "Username must not be empty")
        try credential.password.validateNotEmpty(message: "Password must not be empty")
    }

}
