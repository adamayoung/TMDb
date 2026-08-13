//
//  TMDbGuestSessionService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
final class TMDbGuestSessionService: GuestSessionService {

    private let apiClient: any APIClient

    init(apiClient: some APIClient) {
        self.apiClient = apiClient
    }

    func ratedMovies(
        sortedBy: RatedSort?,
        page: Int?,
        guestSessionID: String
    ) async throws(TMDbError) -> MoviePageableList {
        try Self.validate(guestSessionID: guestSessionID)

        let request = GuestSessionRatedMoviesRequest(
            sortedBy: sortedBy,
            page: page,
            guestSessionID: guestSessionID
        )

        return try await apiClient.perform(request)
    }

    func ratedTVSeries(
        sortedBy: RatedSort?,
        page: Int?,
        guestSessionID: String
    ) async throws(TMDbError) -> TVSeriesPageableList {
        try Self.validate(guestSessionID: guestSessionID)

        let request = GuestSessionRatedTVSeriesRequest(
            sortedBy: sortedBy,
            page: page,
            guestSessionID: guestSessionID
        )

        return try await apiClient.perform(request)
    }

    func ratedTVEpisodes(
        sortedBy: RatedSort?,
        page: Int?,
        guestSessionID: String
    ) async throws(TMDbError) -> TVEpisodePageableList {
        try Self.validate(guestSessionID: guestSessionID)

        let request = GuestSessionRatedTVEpisodesRequest(
            sortedBy: sortedBy,
            page: page,
            guestSessionID: guestSessionID
        )

        return try await apiClient.perform(request)
    }

}

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
extension TMDbGuestSessionService {

    private static func validate(guestSessionID: String) throws(TMDbError) {
        try guestSessionID.validateNotEmpty(message: "Guest session ID must not be empty")
    }

}
