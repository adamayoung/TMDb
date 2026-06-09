//
//  ErrorMappingAPIClient.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// An ``APIClient`` decorator that maps any error thrown by the wrapped
/// ``UnmappedAPIClient`` into the public ``TMDbError``.
///
/// This is the single place where ``TMDbAPIError`` (and any other error) is
/// translated into `TMDbError`, so services depend on an `APIClient` that
/// already throws `TMDbError`.
///
final class ErrorMappingAPIClient: APIClient {

    private let apiClient: any UnmappedAPIClient

    init(apiClient: some UnmappedAPIClient) {
        self.apiClient = apiClient
    }

    func perform<Request: APIRequest>(
        _ request: Request
    ) async throws(TMDbError) -> Request.Response {
        do {
            return try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }
    }

}
