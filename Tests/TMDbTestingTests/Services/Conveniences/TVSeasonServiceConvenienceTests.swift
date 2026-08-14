//
//  TVSeasonServiceConvenienceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
import TMDb
import TMDbTesting

///
/// Pins the zero-defaulted-argument conveniences on ``TVSeasonService``.
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
/// times over, since the mock records every call into one array. Sites with
/// three or more droppable parameters are split a tier at a time, by how many
/// parameters the overload drops.
///
/// They live in this target on purpose. `TMDbTesting`'s mocks implement the
/// *requirements* and never the conveniences, and this target imports through
/// the public API with no `@testable` — so the conformance exercised here is
/// exactly the one a third-party conformer has, which is the only population
/// the hazard can reach.
///
@Suite(.tags(.testingSupport, .mocks, .tvSeason))
struct TVSeasonServiceConvenienceTests {

    var service: MockTVSeasonService

    init() {
        self.service = MockTVSeasonService()
    }

    @Test("details(forSeason:inTVSeries:) forwards a nil language to the requirement")
    func detailsForwardsNilLanguage() async throws {
        _ = try await service.details(forSeason: 1, inTVSeries: 1399)

        #expect(service.detailsCalls.count == 1)
        let call = try #require(service.detailsCalls.first)
        #expect(call.language == nil)
        #expect(call.seasonNumber == 1)
        #expect(call.tvSeriesID == 1399)
    }

    @Test("details(forSeason:inTVSeries:appending:) forwards a nil language to the requirement")
    func detailsAppendingForwardsNilLanguage() async throws {
        _ = try await service.details(forSeason: 1, inTVSeries: 1399, appending: .credits)

        #expect(service.detailsAppendingCalls.count == 1)
        let call = try #require(service.detailsAppendingCalls.first)
        #expect(call.language == nil)
        #expect(call.seasonNumber == 1)
        #expect(call.appending == .credits)
    }

    @Test("aggregateCredits(forSeason:inTVSeries:) forwards a nil language to the requirement")
    func aggregateCreditsForwardsNilLanguage() async throws {
        _ = try await service.aggregateCredits(forSeason: 1, inTVSeries: 1399)

        #expect(service.aggregateCreditsCalls.count == 1)
        let call = try #require(service.aggregateCreditsCalls.first)
        #expect(call.language == nil)
        #expect(call.seasonNumber == 1)
    }

    @Test("credits(forSeason:inTVSeries:) forwards a nil language to the requirement")
    func creditsForwardsNilLanguage() async throws {
        _ = try await service.credits(forSeason: 1, inTVSeries: 1399)

        #expect(service.creditsCalls.count == 1)
        let call = try #require(service.creditsCalls.first)
        #expect(call.language == nil)
        #expect(call.seasonNumber == 1)
    }

    @Test("images(forSeason:inTVSeries:) forwards a nil filter to the requirement")
    func imagesForwardsNilFilter() async throws {
        _ = try await service.images(forSeason: 1, inTVSeries: 1399)

        #expect(service.imagesCalls.count == 1)
        let call = try #require(service.imagesCalls.first)
        #expect(call.filter == nil)
        #expect(call.seasonNumber == 1)
    }

    @Test("videos(forSeason:inTVSeries:) forwards a nil filter to the requirement")
    func videosForwardsNilFilter() async throws {
        _ = try await service.videos(forSeason: 1, inTVSeries: 1399)

        #expect(service.videosCalls.count == 1)
        let call = try #require(service.videosCalls.first)
        #expect(call.filter == nil)
        #expect(call.seasonNumber == 1)
    }

    @Test("changes(forSeason:startDate:endDate:page:) dropping one parameter")
    func changesDroppingOneForwardsTheRest() async throws {
        _ = try await service.changes(
            forSeason: 1,
            startDate: Date(timeIntervalSince1970: 1_000_000),
            endDate: Date(timeIntervalSince1970: 2_000_000)
        )
        var call = try #require(service.changesCalls.last)
        #expect(call.seasonID == 1)
        #expect(call.startDate == Date(timeIntervalSince1970: 1_000_000))
        #expect(call.endDate == Date(timeIntervalSince1970: 2_000_000))
        #expect(call.page == nil)

        _ = try await service.changes(forSeason: 1, startDate: Date(timeIntervalSince1970: 1_000_000), page: 3)
        call = try #require(service.changesCalls.last)
        #expect(call.seasonID == 1)
        #expect(call.startDate == Date(timeIntervalSince1970: 1_000_000))
        #expect(call.endDate == nil)
        #expect(call.page == 3)

        _ = try await service.changes(forSeason: 1, endDate: Date(timeIntervalSince1970: 2_000_000), page: 3)
        call = try #require(service.changesCalls.last)
        #expect(call.seasonID == 1)
        #expect(call.startDate == nil)
        #expect(call.endDate == Date(timeIntervalSince1970: 2_000_000))
        #expect(call.page == 3)

        #expect(service.changesCalls.count == 3)
    }

    @Test("changes(forSeason:startDate:endDate:page:) dropping two parameters")
    func changesDroppingTwoForwardsTheRest() async throws {
        _ = try await service.changes(forSeason: 1, startDate: Date(timeIntervalSince1970: 1_000_000))
        var call = try #require(service.changesCalls.last)
        #expect(call.seasonID == 1)
        #expect(call.startDate == Date(timeIntervalSince1970: 1_000_000))
        #expect(call.endDate == nil)
        #expect(call.page == nil)

        _ = try await service.changes(forSeason: 1, endDate: Date(timeIntervalSince1970: 2_000_000))
        call = try #require(service.changesCalls.last)
        #expect(call.seasonID == 1)
        #expect(call.startDate == nil)
        #expect(call.endDate == Date(timeIntervalSince1970: 2_000_000))
        #expect(call.page == nil)

        _ = try await service.changes(forSeason: 1, page: 3)
        call = try #require(service.changesCalls.last)
        #expect(call.seasonID == 1)
        #expect(call.startDate == nil)
        #expect(call.endDate == nil)
        #expect(call.page == 3)

        #expect(service.changesCalls.count == 3)
    }

    @Test("changes(forSeason:startDate:endDate:page:) dropping three parameters")
    func changesDroppingThreeForwardsTheRest() async throws {
        _ = try await service.changes(forSeason: 1)
        let call = try #require(service.changesCalls.last)
        #expect(call.seasonID == 1)
        #expect(call.startDate == nil)
        #expect(call.endDate == nil)
        #expect(call.page == nil)

        #expect(service.changesCalls.count == 1)
    }

}
