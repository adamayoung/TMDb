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

    func guestSession() async throws -> GuestSession {
        let request = CreateGuestSessionRequest()

        let session: GuestSession
        do {
            session = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return session
    }

    func requestToken() async throws -> Token {
        let request = CreateRequestTokenRequest()

        let token: Token
        do {
            token = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return token
    }

    func authenticateURL(for token: Token, redirectURL: URL? = nil) -> URL {
        let url = authenticateURLBuilder.authenticateURL(
            with: token.requestToken, redirectURL: redirectURL
        )

        return url
    }

    func createSession(withToken token: Token) async throws -> Session {
        let request = CreateSessionRequest(requestToken: token.requestToken)

        let session: Session
        do {
            session = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return session
    }

    func createSession(withCredential credential: Credential) async throws -> Session {
        let token = try await requestToken()

        let request = ValidateTokenWithLoginRequest(
            username: credential.username,
            password: credential.password,
            requestToken: token.requestToken
        )

        let validatedToken: Token
        do {
            validatedToken = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        let session = try await createSession(withToken: validatedToken)

        return session
    }

    @discardableResult
    func deleteSession(_ session: Session) async throws -> Bool {
        let request = DeleteSessionRequest(sessionID: session.sessionID)

        let result: SuccessResult
        do {
            result = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return result.success
    }

    func validateKey() async throws -> Bool {
        let request = ValidateKeyRequest()

        let result: SuccessResult
        do {
            result = try await apiClient.perform(request)
        } catch {
            return false
        }

        return result.success
    }

}
