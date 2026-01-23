//
//  TMDbNetworkService.swift
//  TMDb
//
//  Copyright © 2025 Adam Young.
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
