//
//  TMDbNetworkService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
final class TMDbNetworkService: NetworkService {

    private let apiClient: any APIClient

    init(apiClient: some APIClient) {
        self.apiClient = apiClient
    }

    func details(forNetwork id: Network.ID) async throws(TMDbError) -> Network {
        let request = NetworkRequest(id: id)

        return try await apiClient.perform(request)
    }

    func alternativeNames(
        forNetwork id: Network.ID
    ) async throws(TMDbError) -> [NetworkAlternativeName] {
        let request = NetworkAlternativeNamesRequest(id: id)

        let result: NetworkAlternativeNamesResponse = try await apiClient.perform(request)

        return result.results
    }

    func images(forNetwork id: Network.ID) async throws(TMDbError) -> [NetworkLogo] {
        let request = NetworkImagesRequest(id: id)

        let result: NetworkLogosResponse = try await apiClient.perform(request)

        return result.logos
    }

}
