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
public protocol AuthenticationService: Sendable {

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
    func guestSession() async throws -> GuestSession

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
    func requestToken() async throws -> Token

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
    func authenticateURL(for token: Token, redirectURL: URL?) -> URL

    ///
    /// Creates a TMDb session with a valid request token.
    ///
    /// - Note: Ensure this request token has been authorised in a web browser by taking the user to the URL generated
    /// by ``authenticateURL(for:redirectURL:)``.
    ///
    /// - Parameter token: An authorised request token.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A TMDb session.
    ///
    func createSession(withToken token: Token) async throws -> Session

    ///
    /// Creates a TMDb session using a user's username and password.
    ///
    /// - Parameter credential: The user's TMDb credential.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A TMDb session.
    ///
    func createSession(withCredential credential: Credential) async throws -> Session

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
    func deleteSession(_ session: Session) async throws -> Bool

    ///
    /// Validates the configured API key.
    ///
    /// - Returns: Whether or not the API key is valid.
    ///
    func validateKey() async throws -> Bool

}

extension AuthenticationService {

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
        authenticateURL(for: token, redirectURL: redirectURL)
    }

}
