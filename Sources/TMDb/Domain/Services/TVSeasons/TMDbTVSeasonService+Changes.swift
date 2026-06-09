//
//  TMDbTVSeasonService+Changes.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
extension TMDbTVSeasonService {

    func changes(
        forSeason seasonID: Int,
        startDate: Date? = nil,
        endDate: Date? = nil,
        page: Int? = nil
    ) async throws(TMDbError) -> ChangeCollection {
        let request = TVSeasonChangesRequest(
            seasonID: seasonID,
            startDate: startDate,
            endDate: endDate,
            page: page
        )

        return try await apiClient.perform(request)
    }

}
