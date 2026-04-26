//
//  GuestSessionIntegrationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(
    .serialized,
    .tags(.guestSession),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct GuestSessionIntegrationTests {

    var client: TMDbClient!

    init() {
        let apiKey = CredentialHelper.shared.tmdbAPIKey
        self.client = TMDbClient(apiKey: apiKey)
    }

    @Test(
        "rated movies for guest session",
        .disabled("TMDb guest_session/rated/movies endpoint returns HTTP 500")
    )
    func ratedMoviesForGuestSession() async throws {
        let guestSession =
            try await client.authentication.guestSession()
        let guestSessionID =
            guestSession.guestSessionID

        do {
            let movieList =
                try await client.guestSessions.ratedMovies(
                    guestSessionID: guestSessionID
                )
            #expect(movieList.results.isEmpty)
        } catch let error as TMDbError {
            guard case .notFound = error else {
                throw error
            }
            // TMDb API returns 404 for guest sessions
            // with no rated content, which is expected.
        }
    }

    @Test(
        "rated TV series for guest session",
        .disabled("TMDb guest_session/rated/tv endpoint returns HTTP 500")
    )
    func ratedTVSeriesForGuestSession() async throws {
        let guestSession =
            try await client.authentication.guestSession()
        let guestSessionID =
            guestSession.guestSessionID

        do {
            let tvSeriesList =
                try await client.guestSessions.ratedTVSeries(
                    guestSessionID: guestSessionID
                )
            #expect(tvSeriesList.results.isEmpty)
        } catch let error as TMDbError {
            guard case .notFound = error else {
                throw error
            }
            // TMDb API returns 404 for guest sessions
            // with no rated content, which is expected.
        }
    }

    @Test(
        "rated TV episodes for guest session",
        .disabled("TMDb guest_session/rated/tv/episodes endpoint returns HTTP 500")
    )
    func ratedTVEpisodesForGuestSession() async throws {
        let guestSession =
            try await client.authentication.guestSession()
        let guestSessionID =
            guestSession.guestSessionID

        do {
            let tvEpisodeList =
                try await client.guestSessions.ratedTVEpisodes(
                    guestSessionID: guestSessionID
                )
            #expect(tvEpisodeList.results.isEmpty)
        } catch let error as TMDbError {
            guard case .notFound = error else {
                throw error
            }
            // TMDb API returns 404 for guest sessions
            // with no rated content, which is expected.
        }
    }

}
