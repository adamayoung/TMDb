//
//  TMDbTVSeasonService+Account.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
extension TMDbTVSeasonService {

    func accountStates(
        forSeason seasonNumber: Int,
        inTVSeries tvSeriesID: TVSeries.ID,
        session: Session
    ) async throws(TMDbError) -> AccountStates {
        let request = TVSeasonAccountStatesRequest(
            seasonNumber: seasonNumber,
            tvSeriesID: tvSeriesID,
            sessionID: session.sessionID
        )

        return try await apiClient.perform(request)
    }

}
