//
//  TMDbFindService.swift
//  TMDb
//
//  Created by MLabs on 23/06/2025.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
final class TMDbFindService: FindService {
    
    private let apiClient: any APIClient

    init(apiClient: some APIClient) {
        self.apiClient = apiClient
    }
    
    
    func findId(_ sourceId: String, type: FindServiceType) async throws -> FindResponse {
        let request = FindRequest(id: sourceId, externalSource: type)

        let findResponse: FindResponse
        do {
            findResponse = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return findResponse
    }
}
