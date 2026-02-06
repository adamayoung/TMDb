//
//  TMDbTVEpisodeGroupService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
final class TMDbTVEpisodeGroupService: TVEpisodeGroupService {

    private let apiClient: any APIClient

    init(apiClient: some APIClient) {
        self.apiClient = apiClient
    }

    func details(
        forTVEpisodeGroup id: TVEpisodeGroup.ID
    ) async throws -> TVEpisodeGroup {
        let request = TVEpisodeGroupRequest(id: id)

        let tvEpisodeGroup: TVEpisodeGroup
        do {
            tvEpisodeGroup = try await apiClient.perform(
                request
            )
        } catch let error {
            throw TMDbError(error: error)
        }

        return tvEpisodeGroup
    }

}
