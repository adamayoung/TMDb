//
//  TMDbTVSeriesService+Changes.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
extension TMDbTVSeriesService {

    func changes(
        forTVSeries tvSeriesID: TVSeries.ID,
        startDate: Date? = nil,
        endDate: Date? = nil,
        page: Int? = nil
    ) async throws(TMDbError) -> ChangeCollection {
        let request = TVSeriesChangesRequest(
            id: tvSeriesID,
            startDate: startDate,
            endDate: endDate,
            page: page
        )

        return try await apiClient.perform(request)
    }

    func latest() async throws(TMDbError) -> TVSeries {
        let request = LatestTVSeriesRequest()

        return try await apiClient.perform(request)
    }

    func changes(
        startDate: Date? = nil,
        endDate: Date? = nil,
        page: Int? = nil
    ) async throws(TMDbError) -> ChangedIDCollection {
        let request = TVSeriesChangesListRequest(
            startDate: startDate,
            endDate: endDate,
            page: page
        )

        return try await apiClient.perform(request)
    }

}
