//
//  TrendingServiceConvenienceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
import TMDb
import TMDbTesting

///
/// Pins the zero-defaulted-argument conveniences on ``TrendingService``.
///
/// Each convenience drops its parameters rather than defaulting them, so that
/// its signature cannot witness the requirement it forwards to. These tests
/// assert the other half of that contract: the convenience still reaches the
/// requirement, passing each omitted parameter's default.
///
/// Where a requirement has more than one droppable parameter there is one
/// overload per proper subset of them, and one test per *site* drives the whole
/// set: it calls every overload in turn and checks the recorded call straight
/// after each one. A test per overload would assert the same thing several
/// times over, since the mock records every call into one array.
///
/// They live in this target on purpose. `TMDbTesting`'s mocks implement the
/// *requirements* and never the conveniences, and this target imports through
/// the public API with no `@testable` — so the conformance exercised here is
/// exactly the one a third-party conformer has, which is the only population
/// the hazard can reach.
///
@Suite(.tags(.testingSupport, .mocks, .trending))
struct TrendingServiceConvenienceTests {

    var service: MockTrendingService

    init() {
        self.service = MockTrendingService()
    }

    ///
    /// `allTrending` is the one site whose generated overloads share argument
    /// labels with something else: the *synchronous* auto-pagination helper
    /// `allTrending(inTimeWindow:language:) -> PagedAsyncSequence<TrendingItem>`
    /// defaults both its parameters, so it is callable as `allTrending()`,
    /// `(inTimeWindow:)`, `(language:)` and `(inTimeWindow:language:)` — all four
    /// of which the power set also provides as `async` overloads.
    ///
    /// The pair coexisted before this change too, but the ranking inputs moved:
    /// the async candidate used to be reached by filling defaults and is now an
    /// exact match. These two tests pin the *synchronous* side, which nothing
    /// else covers at these label sets, by binding the result to an explicit
    /// type — if resolution ever flips, they stop compiling rather than
    /// silently changing which API a caller gets.
    ///
    @Test("the zero-argument form still resolves to the paginating sequence")
    func zeroArgumentAllTrendingResolvesToPagedSequence() async throws {
        let sequence: PagedAsyncSequence<TrendingItem> = service.allTrending()

        var count = 0
        for try await _ in sequence {
            count += 1
            if count == 1 { break }
        }

        #expect(count == 1)
    }

    @Test("the two-argument form still resolves to the paginating sequence")
    func twoArgumentAllTrendingResolvesToPagedSequence() async throws {
        let sequence: PagedAsyncSequence<TrendingItem> = service.allTrending(
            inTimeWindow: .week,
            language: "en-GB"
        )

        var count = 0
        for try await _ in sequence {
            count += 1
            if count == 1 { break }
        }

        #expect(count == 1)
    }

    @Test("allTrending(inTimeWindow:page:language:) dropping one parameter")
    func allTrendingDroppingOneForwardsTheRest() async throws {
        _ = try await service.allTrending(inTimeWindow: .week, page: 3)
        var call = try #require(service.allTrendingCalls.last)
        #expect(call.timeWindow == .week)
        #expect(call.page == 3)
        #expect(call.language == nil)

        _ = try await service.allTrending(inTimeWindow: .week, language: "en-GB")
        call = try #require(service.allTrendingCalls.last)
        #expect(call.timeWindow == .week)
        #expect(call.page == nil)
        #expect(call.language == "en-GB")

        _ = try await service.allTrending(page: 3, language: "en-GB")
        call = try #require(service.allTrendingCalls.last)
        #expect(call.timeWindow == .day)
        #expect(call.page == 3)
        #expect(call.language == "en-GB")

        #expect(service.allTrendingCalls.count == 3)
    }

    @Test("allTrending(inTimeWindow:page:language:) dropping two parameters")
    func allTrendingDroppingTwoForwardsTheRest() async throws {
        _ = try await service.allTrending(inTimeWindow: .week)
        var call = try #require(service.allTrendingCalls.last)
        #expect(call.timeWindow == .week)
        #expect(call.page == nil)
        #expect(call.language == nil)

        _ = try await service.allTrending(page: 3)
        call = try #require(service.allTrendingCalls.last)
        #expect(call.timeWindow == .day)
        #expect(call.page == 3)
        #expect(call.language == nil)

        _ = try await service.allTrending(language: "en-GB")
        call = try #require(service.allTrendingCalls.last)
        #expect(call.timeWindow == .day)
        #expect(call.page == nil)
        #expect(call.language == "en-GB")

        #expect(service.allTrendingCalls.count == 3)
    }

    @Test("allTrending(inTimeWindow:page:language:) dropping three parameters")
    func allTrendingDroppingThreeForwardsTheRest() async throws {
        _ = try await service.allTrending()
        let call = try #require(service.allTrendingCalls.last)
        #expect(call.timeWindow == .day)
        #expect(call.page == nil)
        #expect(call.language == nil)

        #expect(service.allTrendingCalls.count == 1)
    }

    @Test("movies(inTimeWindow:page:language:) dropping one parameter")
    func moviesDroppingOneForwardsTheRest() async throws {
        _ = try await service.movies(inTimeWindow: .week, page: 3)
        var call = try #require(service.moviesCalls.last)
        #expect(call.timeWindow == .week)
        #expect(call.page == 3)
        #expect(call.language == nil)

        _ = try await service.movies(inTimeWindow: .week, language: "en-GB")
        call = try #require(service.moviesCalls.last)
        #expect(call.timeWindow == .week)
        #expect(call.page == nil)
        #expect(call.language == "en-GB")

        _ = try await service.movies(page: 3, language: "en-GB")
        call = try #require(service.moviesCalls.last)
        #expect(call.timeWindow == .day)
        #expect(call.page == 3)
        #expect(call.language == "en-GB")

        #expect(service.moviesCalls.count == 3)
    }

    @Test("movies(inTimeWindow:page:language:) dropping two parameters")
    func moviesDroppingTwoForwardsTheRest() async throws {
        _ = try await service.movies(inTimeWindow: .week)
        var call = try #require(service.moviesCalls.last)
        #expect(call.timeWindow == .week)
        #expect(call.page == nil)
        #expect(call.language == nil)

        _ = try await service.movies(page: 3)
        call = try #require(service.moviesCalls.last)
        #expect(call.timeWindow == .day)
        #expect(call.page == 3)
        #expect(call.language == nil)

        _ = try await service.movies(language: "en-GB")
        call = try #require(service.moviesCalls.last)
        #expect(call.timeWindow == .day)
        #expect(call.page == nil)
        #expect(call.language == "en-GB")

        #expect(service.moviesCalls.count == 3)
    }

    @Test("movies(inTimeWindow:page:language:) dropping three parameters")
    func moviesDroppingThreeForwardsTheRest() async throws {
        _ = try await service.movies()
        let call = try #require(service.moviesCalls.last)
        #expect(call.timeWindow == .day)
        #expect(call.page == nil)
        #expect(call.language == nil)

        #expect(service.moviesCalls.count == 1)
    }

    @Test("people(inTimeWindow:page:language:) dropping one parameter")
    func peopleDroppingOneForwardsTheRest() async throws {
        _ = try await service.people(inTimeWindow: .week, page: 3)
        var call = try #require(service.peopleCalls.last)
        #expect(call.timeWindow == .week)
        #expect(call.page == 3)
        #expect(call.language == nil)

        _ = try await service.people(inTimeWindow: .week, language: "en-GB")
        call = try #require(service.peopleCalls.last)
        #expect(call.timeWindow == .week)
        #expect(call.page == nil)
        #expect(call.language == "en-GB")

        _ = try await service.people(page: 3, language: "en-GB")
        call = try #require(service.peopleCalls.last)
        #expect(call.timeWindow == .day)
        #expect(call.page == 3)
        #expect(call.language == "en-GB")

        #expect(service.peopleCalls.count == 3)
    }

    @Test("people(inTimeWindow:page:language:) dropping two parameters")
    func peopleDroppingTwoForwardsTheRest() async throws {
        _ = try await service.people(inTimeWindow: .week)
        var call = try #require(service.peopleCalls.last)
        #expect(call.timeWindow == .week)
        #expect(call.page == nil)
        #expect(call.language == nil)

        _ = try await service.people(page: 3)
        call = try #require(service.peopleCalls.last)
        #expect(call.timeWindow == .day)
        #expect(call.page == 3)
        #expect(call.language == nil)

        _ = try await service.people(language: "en-GB")
        call = try #require(service.peopleCalls.last)
        #expect(call.timeWindow == .day)
        #expect(call.page == nil)
        #expect(call.language == "en-GB")

        #expect(service.peopleCalls.count == 3)
    }

    @Test("people(inTimeWindow:page:language:) dropping three parameters")
    func peopleDroppingThreeForwardsTheRest() async throws {
        _ = try await service.people()
        let call = try #require(service.peopleCalls.last)
        #expect(call.timeWindow == .day)
        #expect(call.page == nil)
        #expect(call.language == nil)

        #expect(service.peopleCalls.count == 1)
    }

    @Test("tvSeries(inTimeWindow:page:language:) dropping one parameter")
    func tvSeriesDroppingOneForwardsTheRest() async throws {
        _ = try await service.tvSeries(inTimeWindow: .week, page: 3)
        var call = try #require(service.tvSeriesCalls.last)
        #expect(call.timeWindow == .week)
        #expect(call.page == 3)
        #expect(call.language == nil)

        _ = try await service.tvSeries(inTimeWindow: .week, language: "en-GB")
        call = try #require(service.tvSeriesCalls.last)
        #expect(call.timeWindow == .week)
        #expect(call.page == nil)
        #expect(call.language == "en-GB")

        _ = try await service.tvSeries(page: 3, language: "en-GB")
        call = try #require(service.tvSeriesCalls.last)
        #expect(call.timeWindow == .day)
        #expect(call.page == 3)
        #expect(call.language == "en-GB")

        #expect(service.tvSeriesCalls.count == 3)
    }

    @Test("tvSeries(inTimeWindow:page:language:) dropping two parameters")
    func tvSeriesDroppingTwoForwardsTheRest() async throws {
        _ = try await service.tvSeries(inTimeWindow: .week)
        var call = try #require(service.tvSeriesCalls.last)
        #expect(call.timeWindow == .week)
        #expect(call.page == nil)
        #expect(call.language == nil)

        _ = try await service.tvSeries(page: 3)
        call = try #require(service.tvSeriesCalls.last)
        #expect(call.timeWindow == .day)
        #expect(call.page == 3)
        #expect(call.language == nil)

        _ = try await service.tvSeries(language: "en-GB")
        call = try #require(service.tvSeriesCalls.last)
        #expect(call.timeWindow == .day)
        #expect(call.page == nil)
        #expect(call.language == "en-GB")

        #expect(service.tvSeriesCalls.count == 3)
    }

    @Test("tvSeries(inTimeWindow:page:language:) dropping three parameters")
    func tvSeriesDroppingThreeForwardsTheRest() async throws {
        _ = try await service.tvSeries()
        let call = try #require(service.tvSeriesCalls.last)
        #expect(call.timeWindow == .day)
        #expect(call.page == nil)
        #expect(call.language == nil)

        #expect(service.tvSeriesCalls.count == 1)
    }

}
