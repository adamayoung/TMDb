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
    ) async throws -> ChangeCollection {
        let request = TVSeriesChangesRequest(
            id: tvSeriesID,
            startDate: startDate,
            endDate: endDate,
            page: page
        )

        let changeCollection: ChangeCollection
        do {
            changeCollection = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return changeCollection
    }

    func latest() async throws -> TVSeries {
        let request = LatestTVSeriesRequest()

        let tvSeries: TVSeries
        do {
            tvSeries = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return tvSeries
    }

    func changes(
        startDate: Date? = nil,
        endDate: Date? = nil,
        page: Int? = nil
    ) async throws -> ChangedIDCollection {
        let request = TVSeriesChangesListRequest(
            startDate: startDate,
            endDate: endDate,
            page: page
        )

        let changedIDCollection: ChangedIDCollection
        do {
            changedIDCollection = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return changedIDCollection
    }

}
