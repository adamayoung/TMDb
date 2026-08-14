//
//  TVEpisodeServiceConvenienceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
import TMDb
import TMDbTesting

///
/// Pins the zero-defaulted-argument conveniences on ``TVEpisodeService``.
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
@Suite(.tags(.testingSupport, .mocks, .tvEpisode))
struct TVEpisodeServiceConvenienceTests {

    var service: MockTVEpisodeService

    init() {
        self.service = MockTVEpisodeService()
    }

    @Test("details(forEpisode:inSeason:inTVSeries:) forwards a nil language to the requirement")
    func detailsForwardsNilLanguage() async throws {
        _ = try await service.details(forEpisode: 1, inSeason: 1, inTVSeries: 1399)

        #expect(service.detailsCalls.count == 1)
        let call = try #require(service.detailsCalls.first)
        #expect(call.language == nil)
        #expect(call.episodeNumber == 1)
        #expect(call.tvSeriesID == 1399)
    }

    @Test("details(forEpisode:inSeason:inTVSeries:appending:) forwards a nil language to the requirement")
    func detailsAppendingForwardsNilLanguage() async throws {
        _ = try await service.details(forEpisode: 1, inSeason: 1, inTVSeries: 1399, appending: .credits)

        #expect(service.detailsAppendingCalls.count == 1)
        let call = try #require(service.detailsAppendingCalls.first)
        #expect(call.language == nil)
        #expect(call.episodeNumber == 1)
        #expect(call.appending == .credits)
    }

    @Test("credits(forEpisode:inSeason:inTVSeries:) forwards a nil language to the requirement")
    func creditsForwardsNilLanguage() async throws {
        _ = try await service.credits(forEpisode: 1, inSeason: 1, inTVSeries: 1399)

        #expect(service.creditsCalls.count == 1)
        let call = try #require(service.creditsCalls.first)
        #expect(call.language == nil)
        #expect(call.episodeNumber == 1)
    }

    @Test("images(forEpisode:inSeason:inTVSeries:) forwards a nil filter to the requirement")
    func imagesForwardsNilFilter() async throws {
        _ = try await service.images(forEpisode: 1, inSeason: 1, inTVSeries: 1399)

        #expect(service.imagesCalls.count == 1)
        let call = try #require(service.imagesCalls.first)
        #expect(call.filter == nil)
        #expect(call.episodeNumber == 1)
    }

    @Test("videos(forEpisode:inSeason:inTVSeries:) forwards a nil filter to the requirement")
    func videosForwardsNilFilter() async throws {
        _ = try await service.videos(forEpisode: 1, inSeason: 1, inTVSeries: 1399)

        #expect(service.videosCalls.count == 1)
        let call = try #require(service.videosCalls.first)
        #expect(call.filter == nil)
        #expect(call.episodeNumber == 1)
    }

    @Test("every changes(forEpisode:startDate:endDate:page:) overload forwards the parameters it omits")
    func changesOverloadsForwardOmittedParameters() async throws {
        _ = try await service.changes(
            forEpisode: 1,
            startDate: Date(timeIntervalSince1970: 1_000_000),
            endDate: Date(timeIntervalSince1970: 2_000_000)
        )
        var call = try #require(service.changesCalls.last)
        #expect(call.episodeID == 1)
        #expect(call.startDate == Date(timeIntervalSince1970: 1_000_000))
        #expect(call.endDate == Date(timeIntervalSince1970: 2_000_000))
        #expect(call.page == nil)

        _ = try await service.changes(forEpisode: 1, startDate: Date(timeIntervalSince1970: 1_000_000), page: 3)
        call = try #require(service.changesCalls.last)
        #expect(call.episodeID == 1)
        #expect(call.startDate == Date(timeIntervalSince1970: 1_000_000))
        #expect(call.endDate == nil)
        #expect(call.page == 3)

        _ = try await service.changes(forEpisode: 1, endDate: Date(timeIntervalSince1970: 2_000_000), page: 3)
        call = try #require(service.changesCalls.last)
        #expect(call.episodeID == 1)
        #expect(call.startDate == nil)
        #expect(call.endDate == Date(timeIntervalSince1970: 2_000_000))
        #expect(call.page == 3)

        _ = try await service.changes(forEpisode: 1, startDate: Date(timeIntervalSince1970: 1_000_000))
        call = try #require(service.changesCalls.last)
        #expect(call.episodeID == 1)
        #expect(call.startDate == Date(timeIntervalSince1970: 1_000_000))
        #expect(call.endDate == nil)
        #expect(call.page == nil)

        _ = try await service.changes(forEpisode: 1, endDate: Date(timeIntervalSince1970: 2_000_000))
        call = try #require(service.changesCalls.last)
        #expect(call.episodeID == 1)
        #expect(call.startDate == nil)
        #expect(call.endDate == Date(timeIntervalSince1970: 2_000_000))
        #expect(call.page == nil)

        _ = try await service.changes(forEpisode: 1, page: 3)
        call = try #require(service.changesCalls.last)
        #expect(call.episodeID == 1)
        #expect(call.startDate == nil)
        #expect(call.endDate == nil)
        #expect(call.page == 3)

        _ = try await service.changes(forEpisode: 1)
        call = try #require(service.changesCalls.last)
        #expect(call.episodeID == 1)
        #expect(call.startDate == nil)
        #expect(call.endDate == nil)
        #expect(call.page == nil)

        #expect(service.changesCalls.count == 7)
    }

}
