//
//  TMDbTVEpisodeService+Account.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
extension TMDbTVEpisodeService {

    func accountStates(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        session: Session
    ) async throws(TMDbError) -> AccountStates {
        let request = TVEpisodeAccountStatesRequest(
            episodeNumber: episodeNumber,
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            sessionID: session.sessionID
        )

        return try await apiClient.perform(request)
    }

    func addRating(
        _ rating: Double,
        toEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        session: Session
    ) async throws(TMDbError) {
        try rating.validateAsRating()

        let request = TVEpisodeAddRatingRequest(
            rating: rating,
            episodeNumber: episodeNumber,
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            sessionID: session.sessionID
        )

        _ = try await apiClient.perform(request)
    }

    func deleteRating(
        forEpisode episodeNumber: Int,
        inSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        session: Session
    ) async throws(TMDbError) {
        let request = TVEpisodeDeleteRatingRequest(
            episodeNumber: episodeNumber,
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            sessionID: session.sessionID
        )

        _ = try await apiClient.perform(request)
    }

}
