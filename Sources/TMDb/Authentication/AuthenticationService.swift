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
/// Provides an interface for authenticating with TMDb.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public final class AuthenticationService {

    private let apiClient: any APIClient

    ///
    /// Creates an authentication service object.
    ///
    public convenience init() {
        self.init(
            apiClient: TMDbFactory.authAPIClient
        )
    }

    init(apiClient: some APIClient) {
        self.apiClient = apiClient
    }

    ///
    /// Creates a guest session with TMDb.
    ///
    /// Guest sessions are a special kind of session that give you some of the
    /// functionality of an account, but not all. For example, some of the
    /// things you can do with a guest session are; maintain a rated list, a
    /// watchlist and a favourite list.
    ///
    /// Guest sessions will automatically be deleted if they are not used
    /// within 60 minutes of it being issued.
    ///
    /// [TMDb API - Authentication: Create Guest Session](https://developer.themoviedb.org/reference/certifications-tv-list)
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A guest session.
    ///
    public func createGuestSession() async throws -> GuestSession {
        let session: GuestSession
        do {
            session = try await apiClient.get(endpoint: AuthenticationEndpoint.createGuestSession)
        } catch let error {
            throw TMDbError(error: error)
        }

        return session
    }

}
