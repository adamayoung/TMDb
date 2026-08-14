//
//  AccountServiceConvenienceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
import TMDb
import TMDbTesting

///
/// Pins the zero-defaulted-argument conveniences on ``AccountService``.
///
/// Each convenience drops a parameter rather than defaulting it, so that its
/// signature cannot witness the requirement it forwards to. These tests assert
/// the other half of that contract: the convenience still reaches the
/// requirement, passing `nil` for the parameter it omits.
///
/// They live in this target on purpose. `TMDbTesting`'s mocks implement the
/// *requirements* and never the conveniences, and this target imports through
/// the public API with no `@testable` — so the conformance exercised here is
/// exactly the one a third-party conformer has, which is the only population
/// the hazard can reach.
///
@Suite(.tags(.testingSupport, .mocks, .account))
struct AccountServiceConvenienceTests {

    var service: MockAccountService

    init() {
        self.service = MockAccountService()
    }

    @Test("lists(accountID:session:) forwards a nil page to the requirement")
    func listsForwardsNilPage() async throws {
        _ = try await service.lists(accountID: 42, session: .sample)

        #expect(service.listsCalls.count == 1)
        let call = try #require(service.listsCalls.first)
        #expect(call.page == nil)
        #expect(call.accountID == 42)
        #expect(call.session == .sample)
    }

    @Test("every favouriteMovies(sortedBy:page:accountID:session:) overload forwards the parameters it omits")
    func favouriteMoviesOverloadsForwardOmittedParameters() async throws {
        _ = try await service.favouriteMovies(sortedBy: .createdAt(descending: true), accountID: 550, session: .sample)
        var call = try #require(service.favouriteMoviesCalls.last)
        #expect(call.sortedBy?.description == "created_at.desc")
        #expect(call.page == nil)
        #expect(call.accountID == 550)
        #expect(call.session == .sample)

        _ = try await service.favouriteMovies(page: 3, accountID: 550, session: .sample)
        call = try #require(service.favouriteMoviesCalls.last)
        #expect(call.sortedBy == nil)
        #expect(call.page == 3)
        #expect(call.accountID == 550)
        #expect(call.session == .sample)

        _ = try await service.favouriteMovies(accountID: 550, session: .sample)
        call = try #require(service.favouriteMoviesCalls.last)
        #expect(call.sortedBy == nil)
        #expect(call.page == nil)
        #expect(call.accountID == 550)
        #expect(call.session == .sample)

        #expect(service.favouriteMoviesCalls.count == 3)
    }

    @Test("every favouriteTVSeries(sortedBy:page:accountID:session:) overload forwards the parameters it omits")
    func favouriteTVSeriesOverloadsForwardOmittedParameters() async throws {
        _ = try await service.favouriteTVSeries(
            sortedBy: .createdAt(descending: true),
            accountID: 550,
            session: .sample
        )
        var call = try #require(service.favouriteTVSeriesCalls.last)
        #expect(call.sortedBy?.description == "created_at.desc")
        #expect(call.page == nil)
        #expect(call.accountID == 550)
        #expect(call.session == .sample)

        _ = try await service.favouriteTVSeries(page: 3, accountID: 550, session: .sample)
        call = try #require(service.favouriteTVSeriesCalls.last)
        #expect(call.sortedBy == nil)
        #expect(call.page == 3)
        #expect(call.accountID == 550)
        #expect(call.session == .sample)

        _ = try await service.favouriteTVSeries(accountID: 550, session: .sample)
        call = try #require(service.favouriteTVSeriesCalls.last)
        #expect(call.sortedBy == nil)
        #expect(call.page == nil)
        #expect(call.accountID == 550)
        #expect(call.session == .sample)

        #expect(service.favouriteTVSeriesCalls.count == 3)
    }

    @Test("every movieWatchlist(sortedBy:page:accountID:session:) overload forwards the parameters it omits")
    func movieWatchlistOverloadsForwardOmittedParameters() async throws {
        _ = try await service.movieWatchlist(sortedBy: .createdAt(descending: true), accountID: 550, session: .sample)
        var call = try #require(service.movieWatchlistCalls.last)
        #expect(call.sortedBy?.description == "created_at.desc")
        #expect(call.page == nil)
        #expect(call.accountID == 550)
        #expect(call.session == .sample)

        _ = try await service.movieWatchlist(page: 3, accountID: 550, session: .sample)
        call = try #require(service.movieWatchlistCalls.last)
        #expect(call.sortedBy == nil)
        #expect(call.page == 3)
        #expect(call.accountID == 550)
        #expect(call.session == .sample)

        _ = try await service.movieWatchlist(accountID: 550, session: .sample)
        call = try #require(service.movieWatchlistCalls.last)
        #expect(call.sortedBy == nil)
        #expect(call.page == nil)
        #expect(call.accountID == 550)
        #expect(call.session == .sample)

        #expect(service.movieWatchlistCalls.count == 3)
    }

    @Test("every ratedMovies(sortedBy:page:accountID:session:) overload forwards the parameters it omits")
    func ratedMoviesOverloadsForwardOmittedParameters() async throws {
        _ = try await service.ratedMovies(sortedBy: .createdAt(descending: true), accountID: 550, session: .sample)
        var call = try #require(service.ratedMoviesCalls.last)
        #expect(call.sortedBy?.description == "created_at.desc")
        #expect(call.page == nil)
        #expect(call.accountID == 550)
        #expect(call.session == .sample)

        _ = try await service.ratedMovies(page: 3, accountID: 550, session: .sample)
        call = try #require(service.ratedMoviesCalls.last)
        #expect(call.sortedBy == nil)
        #expect(call.page == 3)
        #expect(call.accountID == 550)
        #expect(call.session == .sample)

        _ = try await service.ratedMovies(accountID: 550, session: .sample)
        call = try #require(service.ratedMoviesCalls.last)
        #expect(call.sortedBy == nil)
        #expect(call.page == nil)
        #expect(call.accountID == 550)
        #expect(call.session == .sample)

        #expect(service.ratedMoviesCalls.count == 3)
    }

    @Test("every ratedTVEpisodes(sortedBy:page:accountID:session:) overload forwards the parameters it omits")
    func ratedTVEpisodesOverloadsForwardOmittedParameters() async throws {
        _ = try await service.ratedTVEpisodes(sortedBy: .createdAt(descending: true), accountID: 550, session: .sample)
        var call = try #require(service.ratedTVEpisodesCalls.last)
        #expect(call.sortedBy?.description == "created_at.desc")
        #expect(call.page == nil)
        #expect(call.accountID == 550)
        #expect(call.session == .sample)

        _ = try await service.ratedTVEpisodes(page: 3, accountID: 550, session: .sample)
        call = try #require(service.ratedTVEpisodesCalls.last)
        #expect(call.sortedBy == nil)
        #expect(call.page == 3)
        #expect(call.accountID == 550)
        #expect(call.session == .sample)

        _ = try await service.ratedTVEpisodes(accountID: 550, session: .sample)
        call = try #require(service.ratedTVEpisodesCalls.last)
        #expect(call.sortedBy == nil)
        #expect(call.page == nil)
        #expect(call.accountID == 550)
        #expect(call.session == .sample)

        #expect(service.ratedTVEpisodesCalls.count == 3)
    }

    @Test("every ratedTVSeries(sortedBy:page:accountID:session:) overload forwards the parameters it omits")
    func ratedTVSeriesOverloadsForwardOmittedParameters() async throws {
        _ = try await service.ratedTVSeries(sortedBy: .createdAt(descending: true), accountID: 550, session: .sample)
        var call = try #require(service.ratedTVSeriesCalls.last)
        #expect(call.sortedBy?.description == "created_at.desc")
        #expect(call.page == nil)
        #expect(call.accountID == 550)
        #expect(call.session == .sample)

        _ = try await service.ratedTVSeries(page: 3, accountID: 550, session: .sample)
        call = try #require(service.ratedTVSeriesCalls.last)
        #expect(call.sortedBy == nil)
        #expect(call.page == 3)
        #expect(call.accountID == 550)
        #expect(call.session == .sample)

        _ = try await service.ratedTVSeries(accountID: 550, session: .sample)
        call = try #require(service.ratedTVSeriesCalls.last)
        #expect(call.sortedBy == nil)
        #expect(call.page == nil)
        #expect(call.accountID == 550)
        #expect(call.session == .sample)

        #expect(service.ratedTVSeriesCalls.count == 3)
    }

    @Test("every tvSeriesWatchlist(sortedBy:page:accountID:session:) overload forwards the parameters it omits")
    func tvSeriesWatchlistOverloadsForwardOmittedParameters() async throws {
        _ = try await service.tvSeriesWatchlist(
            sortedBy: .createdAt(descending: true),
            accountID: 550,
            session: .sample
        )
        var call = try #require(service.tvSeriesWatchlistCalls.last)
        #expect(call.sortedBy?.description == "created_at.desc")
        #expect(call.page == nil)
        #expect(call.accountID == 550)
        #expect(call.session == .sample)

        _ = try await service.tvSeriesWatchlist(page: 3, accountID: 550, session: .sample)
        call = try #require(service.tvSeriesWatchlistCalls.last)
        #expect(call.sortedBy == nil)
        #expect(call.page == 3)
        #expect(call.accountID == 550)
        #expect(call.session == .sample)

        _ = try await service.tvSeriesWatchlist(accountID: 550, session: .sample)
        call = try #require(service.tvSeriesWatchlistCalls.last)
        #expect(call.sortedBy == nil)
        #expect(call.page == nil)
        #expect(call.accountID == 550)
        #expect(call.session == .sample)

        #expect(service.tvSeriesWatchlistCalls.count == 3)
    }

}
