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

    func details(forNetwork id: Network.ID) async throws -> Network {
        let request = NetworkRequest(id: id)

        let network: Network
        do {
            network = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return network
    }

    func alternativeNames(forNetwork id: Network.ID) async throws -> [NetworkAlternativeName] {
        let request = NetworkAlternativeNamesRequest(id: id)

        let result: NetworkAlternativeNamesResponse
        do {
            result = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return result.results
    }

    func images(forNetwork id: Network.ID) async throws -> [NetworkLogo] {
        let request = NetworkImagesRequest(id: id)

        let result: NetworkLogosResponse
        do {
            result = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return result.logos
    }

}
