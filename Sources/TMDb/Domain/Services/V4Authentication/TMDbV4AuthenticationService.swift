//
//  TMDbV4AuthenticationService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
final class TMDbV4AuthenticationService: V4AuthenticationService {

    private let apiClient: any APIClient
    private let authenticateURLBuilder: any V4AuthenticateURLBuilding

    init(
        apiClient: some APIClient,
        authenticateURLBuilder: some V4AuthenticateURLBuilding
    ) {
        self.apiClient = apiClient
        self.authenticateURLBuilder = authenticateURLBuilder
    }

    func requestToken(redirectURL: URL?) async throws(TMDbError) -> V4RequestToken {
        let request = CreateV4RequestTokenRequest(redirectURL: redirectURL)

        return try await apiClient.perform(request)
    }

    func authenticateURL(for requestToken: V4RequestToken) -> URL {
        authenticateURLBuilder.authenticateURL(with: requestToken.requestToken)
    }

    func createAccessToken(
        withRequestToken requestToken: V4RequestToken
    ) async throws(TMDbError) -> V4AccessToken {
        try Self.validate(requestToken: requestToken.requestToken)
        let request = CreateV4AccessTokenRequest(requestToken: requestToken.requestToken)

        return try await apiClient.perform(request)
    }

    @discardableResult
    func deleteAccessToken(_ accessToken: String) async throws(TMDbError) -> Bool {
        try Self.validate(accessToken: accessToken)
        let request = DeleteV4AccessTokenRequest(accessToken: accessToken)

        return try await apiClient.perform(request).success
    }

}

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
extension TMDbV4AuthenticationService {

    private static func validate(requestToken: String) throws(TMDbError) {
        try requestToken.validateNotEmpty(message: "Request token must not be empty")
    }

    private static func validate(accessToken: String) throws(TMDbError) {
        try accessToken.validateNotEmpty(message: "Access token must not be empty")
    }

}
