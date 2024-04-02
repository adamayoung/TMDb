//
//  AuthenticationService.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

///
/// Provides an interface for authenticating and generating session IDs with TMDb.
///
/// Details of generating session IDs for TMDb can be found at
/// [TMDb API - How do I generate a session ID?](https://developer.themoviedb.org/reference/authentication-how-do-i-generate-a-session-id)
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public final class AuthenticationService: @unchecked Sendable {

    private let apiClient: any APIClient
    private let authenticateURLBuilder: any AuthenticateURLBuilding

    ///
    /// Creates an authentication service object.
    ///
    public convenience init() {
        self.init(
            apiClient: TMDbFactory.authAPIClient,
            authenticateURLBuilder: TMDbFactory.authenticateURLBuilder
        )
    }

    init(
        apiClient: some APIClient,
        authenticateURLBuilder: some AuthenticateURLBuilding
    ) {
        self.apiClient = apiClient
        self.authenticateURLBuilder = authenticateURLBuilder
    }

    ///
    /// Creates a guest session with TMDb.
    ///
    /// Guest sessions are a special kind of session that give you some of the functionality of an account, but not
    /// all. For example, some of the things you can do with a guest session are; maintain a rated list, a watchlist
    /// and a favourite list.
    ///
    /// Guest sessions will automatically be deleted if they are not used within 60 minutes of it being issued.
    ///
    /// [TMDb API - Authentication: Create Guest Session](https://developer.themoviedb.org/reference/authentication-create-guest-session)
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A guest session.
    ///
    public func guestSession() async throws -> GuestSession {
        let session: GuestSession
        do {
            session = try await apiClient.get(endpoint: AuthenticationEndpoint.createGuestSession)
        } catch let error {
            throw TMDbError(error: error)
        }

        return session
    }

    ///
    /// Creates an intermediate request token that can be used to validate a TMDb user login.
    ///
    /// This is a temporary token that is required to ask the user for permission to access their account. This token
    /// will auto expire after 60 minutes if it's not used.
    ///
    /// [TMDb API - Authentication: Create Request Token](https://developer.themoviedb.org/reference/authentication-create-request-token)
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: An intermediate request token.
    ///
    public func requestToken() async throws -> Token {
        let token: Token
        do {
            token = try await apiClient.get(endpoint: AuthenticationEndpoint.createRequestToken)
        } catch let error {
            throw TMDbError(error: error)
        }

        return token
    }

    ///
    /// Builds the URL used for the user to authenticate with after requesting an intermediate request token.
    ///
    /// An internediate request token can be generated by calling ``requestToken()``.
    ///
    /// - Parameters:
    ///   - token: An intermediate request token.
    ///   - redirectURL: Optional URL to redirect to once the user has authenticated.
    ///
    /// - Returns: An authenticate URL.
    ///
    public func authenticateURL(for token: Token, redirectURL: URL? = nil) -> URL {
        let url = authenticateURLBuilder.authenticateURL(with: token.requestToken, redirectURL: redirectURL)

        return url
    }

    ///
    /// Creates a TMDb session with a valid request token.
    ///
    /// - Note: Ensure this request token has been authorised in a web browser by taking the user to the URL generated
    /// by ``authenticateURL(for:redirectURL:)``.
    ///
    /// - Parameter requestToken: An authorised request token.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A TMDb session.
    ///
    public func createSession(withToken token: Token) async throws -> Session {
        let body = CreateSessionRequestBody(requestToken: token.requestToken)

        let session: Session
        do {
            session = try await apiClient.post(endpoint: AuthenticationEndpoint.createSession, body: body)
        } catch let error {
            throw TMDbError(error: error)
        }

        return session
    }

    ///
    /// Creates a TMDb session using a user's username and password.
    ///
    /// - Parameters:
    ///   - credential: The user's TMDb credential.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A TMDb session.
    ///
    public func createSession(withCredential credential: Credential) async throws -> Session {
        let token = try await requestToken()

        let body = CreateSessionWithLoginRequestBody(
            username: credential.username,
            password: credential.password,
            requestToken: token.requestToken
        )

        let validatedToken: Token
        do {
            validatedToken = try await apiClient.post(
                endpoint: AuthenticationEndpoint.validateRequestTokenWithLogin,
                body: body
            ) as Token
        } catch let error {
            throw TMDbError(error: error)
        }

        let session = try await createSession(withToken: validatedToken)

        return session
    }

    ///
    /// Deletes a user's session on TMDb.
    ///
    /// - Parameter session: The user's session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Whether or not the session was successfully delete.
    ///
    @discardableResult
    public func deleteSession(_ session: Session) async throws -> Bool {
        let body = DeleteSessionRequestBody(sessionID: session.sessionID)

        let result: SuccessResult
        do {
            result = try await apiClient.delete(endpoint: AuthenticationEndpoint.deleteSession, body: body)
        } catch let error {
            throw TMDbError(error: error)
        }

        return result.success
    }

    ///
    /// Validates the configured API key.
    ///
    /// - Returns: Whether or not the API key is valid.
    ///
    public func validateKey() async throws -> Bool {
        let result: SuccessResult
        do {
            result = try await apiClient.get(endpoint: AuthenticationEndpoint.validateKey)
        } catch {
            return false
        }

        return result.success
    }

}
