//
//  File.swift
//  
//
//  Created by Adam Young on 08/03/2024.
//

import Foundation

///
/// Provides an interface for obtaining account data from TMDb.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public final class AccountService {

    private let apiClient: any APIClient

    ///
    /// Creates an account service object.
    ///
    public convenience init() {
        self.init(
            apiClient: TMDbFactory.apiClient
        )
    }

    init(apiClient: some APIClient) {
        self.apiClient = apiClient
    }


    ///
    /// Returns the TMDb user's account details..
    ///
    /// - Parameter session: The user's TMDb session.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The user's account details.
    ///
    public func details(session: Session) async throws -> AccountDetails {
        let accountDetails: AccountDetails
        do {
            accountDetails = try await apiClient.get(endpoint: AccountEndpoint.details(session: session))
        } catch let error {
            throw TMDbError(error: error)
        }

        return accountDetails
    }

}
