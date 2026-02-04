//
//  TMDbTVSeriesService+Account.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
extension TMDbTVSeriesService {

    func accountStates(forTVSeries tvSeriesID: TVSeries.ID, session: Session) async throws
    -> AccountStates {
        let request = TVSeriesAccountStatesRequest(id: tvSeriesID, sessionID: session.sessionID)

        let accountStates: AccountStates
        do {
            accountStates = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return accountStates
    }

    func addRating(
        _ rating: Double,
        toTVSeries tvSeriesID: TVSeries.ID,
        session: Session
    ) async throws {
        guard (0.5 ... 10.0).contains(rating), rating.truncatingRemainder(dividingBy: 0.5) == 0 else {
            throw TMDbError.invalidRating
        }

        let request = TVSeriesAddRatingRequest(
            rating: rating,
            tvSeriesID: tvSeriesID,
            sessionID: session.sessionID
        )

        do {
            _ = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }
    }

    func deleteRating(forTVSeries tvSeriesID: TVSeries.ID, session: Session) async throws {
        let request = TVSeriesDeleteRatingRequest(tvSeriesID: tvSeriesID, sessionID: session.sessionID)

        do {
            _ = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }
    }

}
