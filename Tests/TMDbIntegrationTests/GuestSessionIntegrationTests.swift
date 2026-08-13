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
    .integrationGate,
    .serialized,
    .tags(.guestSession),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct GuestSessionIntegrationTests {

    var client: TMDbClient!

    init() {
        self.client = CredentialHelper.shared.makeClient()
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
        } catch {
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
        } catch {
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
        } catch {
            guard case .notFound = error else {
                throw error
            }
            // TMDb API returns 404 for guest sessions
            // with no rated content, which is expected.
        }
    }

    /// The guest session id is a bearer-like credential, so a traversal here
    /// would have re-pointed a credentialed request at another endpoint. Both of
    /// these are refused on-device, before any request is sent.
    @Test("ratedMovies with an empty guest session ID is refused")
    func ratedMoviesWithEmptyGuestSessionIDIsRefused() async throws {
        let client = CredentialHelper.shared.makeClient()

        await #expect(throws: TMDbError.self) {
            _ = try await client.guestSessions.ratedMovies(guestSessionID: "")
        }
    }

    @Test("ratedMovies with a traversal guest session ID is refused")
    func ratedMoviesWithTraversalGuestSessionIDIsRefused() async throws {
        let client = CredentialHelper.shared.makeClient()

        await #expect(throws: TMDbError.self) {
            _ = try await client.guestSessions.ratedMovies(guestSessionID: "x/../../movie/550")
        }
    }

}
