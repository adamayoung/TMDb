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
    ) async throws(TMDbError) -> TVEpisodeGroup {
        try Self.validate(id: id)
        let request = TVEpisodeGroupRequest(id: id)

        return try await apiClient.perform(request)
    }

}

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
extension TMDbTVEpisodeGroupService {

    private static func validate(id: TVEpisodeGroup.ID) throws(TMDbError) {
        try id.validateNotEmpty(message: "TV episode group ID must not be empty")
    }

}
