//
//  TVSeriesServiceConvenienceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

// swiftlint:disable file_length type_body_length

import Foundation
import Testing
import TMDb
import TMDbTesting

///
/// Pins the zero-defaulted-argument conveniences on ``TVSeriesService``.
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
@Suite(.tags(.testingSupport, .mocks, .tvSeries))
struct TVSeriesServiceConvenienceTests {

    var service: MockTVSeriesService

    init() {
        self.service = MockTVSeriesService()
    }

    @Test("details(forTVSeries:) forwards a nil language to the requirement")
    func detailsForwardsNilLanguage() async throws {
        _ = try await service.details(forTVSeries: 1399)

        #expect(service.detailsCalls.count == 1)
        let call = try #require(service.detailsCalls.first)
        #expect(call.language == nil)
        #expect(call.tvSeriesID == 1399)
    }

    @Test("details(forTVSeries:appending:) forwards a nil language to the requirement")
    func detailsAppendingForwardsNilLanguage() async throws {
        _ = try await service.details(forTVSeries: 1399, appending: .credits)

        #expect(service.detailsAppendingCalls.count == 1)
        let call = try #require(service.detailsAppendingCalls.first)
        #expect(call.language == nil)
        #expect(call.tvSeriesID == 1399)
        #expect(call.appending == .credits)
    }

    @Test("credits(forTVSeries:) forwards a nil language to the requirement")
    func creditsForwardsNilLanguage() async throws {
        _ = try await service.credits(forTVSeries: 1399)

        #expect(service.creditsCalls.count == 1)
        let call = try #require(service.creditsCalls.first)
        #expect(call.language == nil)
        #expect(call.tvSeriesID == 1399)
    }

    @Test("aggregateCredits(forTVSeries:) forwards a nil language to the requirement")
    func aggregateCreditsForwardsNilLanguage() async throws {
        _ = try await service.aggregateCredits(forTVSeries: 1399)

        #expect(service.aggregateCreditsCalls.count == 1)
        let call = try #require(service.aggregateCreditsCalls.first)
        #expect(call.language == nil)
        #expect(call.tvSeriesID == 1399)
    }

    @Test("images(forTVSeries:) forwards a nil filter to the requirement")
    func imagesForwardsNilFilter() async throws {
        _ = try await service.images(forTVSeries: 1399)

        #expect(service.imagesCalls.count == 1)
        let call = try #require(service.imagesCalls.first)
        #expect(call.filter == nil)
        #expect(call.tvSeriesID == 1399)
    }

    @Test("videos(forTVSeries:) forwards a nil filter to the requirement")
    func videosForwardsNilFilter() async throws {
        _ = try await service.videos(forTVSeries: 1399)

        #expect(service.videosCalls.count == 1)
        let call = try #require(service.videosCalls.first)
        #expect(call.filter == nil)
        #expect(call.tvSeriesID == 1399)
    }

    @Test("airingToday(page:timezone:language:) dropping one parameter")
    func airingTodayDroppingOneForwardsTheRest() async throws {
        _ = try await service.airingToday(page: 3, timezone: "Europe/London")
        var call = try #require(service.airingTodayCalls.last)
        #expect(call.page == 3)
        #expect(call.timezone == "Europe/London")
        #expect(call.language == nil)

        _ = try await service.airingToday(page: 3, language: "en-GB")
        call = try #require(service.airingTodayCalls.last)
        #expect(call.page == 3)
        #expect(call.timezone == nil)
        #expect(call.language == "en-GB")

        _ = try await service.airingToday(timezone: "Europe/London", language: "en-GB")
        call = try #require(service.airingTodayCalls.last)
        #expect(call.page == nil)
        #expect(call.timezone == "Europe/London")
        #expect(call.language == "en-GB")

        #expect(service.airingTodayCalls.count == 3)
    }

    @Test("airingToday(page:timezone:language:) dropping two parameters")
    func airingTodayDroppingTwoForwardsTheRest() async throws {
        _ = try await service.airingToday(page: 3)
        var call = try #require(service.airingTodayCalls.last)
        #expect(call.page == 3)
        #expect(call.timezone == nil)
        #expect(call.language == nil)

        _ = try await service.airingToday(timezone: "Europe/London")
        call = try #require(service.airingTodayCalls.last)
        #expect(call.page == nil)
        #expect(call.timezone == "Europe/London")
        #expect(call.language == nil)

        _ = try await service.airingToday(language: "en-GB")
        call = try #require(service.airingTodayCalls.last)
        #expect(call.page == nil)
        #expect(call.timezone == nil)
        #expect(call.language == "en-GB")

        #expect(service.airingTodayCalls.count == 3)
    }

    @Test("airingToday(page:timezone:language:) dropping three parameters")
    func airingTodayDroppingThreeForwardsTheRest() async throws {
        _ = try await service.airingToday()
        let call = try #require(service.airingTodayCalls.last)
        #expect(call.page == nil)
        #expect(call.timezone == nil)
        #expect(call.language == nil)

        #expect(service.airingTodayCalls.count == 1)
    }

    @Test("changes(forTVSeries:startDate:endDate:page:) dropping one parameter")
    func changesForTVSeriesDroppingOneForwardsTheRest() async throws {
        _ = try await service.changes(
            forTVSeries: 1399,
            startDate: Date(timeIntervalSince1970: 1_000_000),
            endDate: Date(timeIntervalSince1970: 2_000_000)
        )
        var call = try #require(service.changesForTVSeriesCalls.last)
        #expect(call.tvSeriesID == 1399)
        #expect(call.startDate == Date(timeIntervalSince1970: 1_000_000))
        #expect(call.endDate == Date(timeIntervalSince1970: 2_000_000))
        #expect(call.page == nil)

        _ = try await service.changes(forTVSeries: 1399, startDate: Date(timeIntervalSince1970: 1_000_000), page: 3)
        call = try #require(service.changesForTVSeriesCalls.last)
        #expect(call.tvSeriesID == 1399)
        #expect(call.startDate == Date(timeIntervalSince1970: 1_000_000))
        #expect(call.endDate == nil)
        #expect(call.page == 3)

        _ = try await service.changes(forTVSeries: 1399, endDate: Date(timeIntervalSince1970: 2_000_000), page: 3)
        call = try #require(service.changesForTVSeriesCalls.last)
        #expect(call.tvSeriesID == 1399)
        #expect(call.startDate == nil)
        #expect(call.endDate == Date(timeIntervalSince1970: 2_000_000))
        #expect(call.page == 3)

        #expect(service.changesForTVSeriesCalls.count == 3)
    }

    @Test("changes(forTVSeries:startDate:endDate:page:) dropping two parameters")
    func changesForTVSeriesDroppingTwoForwardsTheRest() async throws {
        _ = try await service.changes(forTVSeries: 1399, startDate: Date(timeIntervalSince1970: 1_000_000))
        var call = try #require(service.changesForTVSeriesCalls.last)
        #expect(call.tvSeriesID == 1399)
        #expect(call.startDate == Date(timeIntervalSince1970: 1_000_000))
        #expect(call.endDate == nil)
        #expect(call.page == nil)

        _ = try await service.changes(forTVSeries: 1399, endDate: Date(timeIntervalSince1970: 2_000_000))
        call = try #require(service.changesForTVSeriesCalls.last)
        #expect(call.tvSeriesID == 1399)
        #expect(call.startDate == nil)
        #expect(call.endDate == Date(timeIntervalSince1970: 2_000_000))
        #expect(call.page == nil)

        _ = try await service.changes(forTVSeries: 1399, page: 3)
        call = try #require(service.changesForTVSeriesCalls.last)
        #expect(call.tvSeriesID == 1399)
        #expect(call.startDate == nil)
        #expect(call.endDate == nil)
        #expect(call.page == 3)

        #expect(service.changesForTVSeriesCalls.count == 3)
    }

    @Test("changes(forTVSeries:startDate:endDate:page:) dropping three parameters")
    func changesForTVSeriesDroppingThreeForwardsTheRest() async throws {
        _ = try await service.changes(forTVSeries: 1399)
        let call = try #require(service.changesForTVSeriesCalls.last)
        #expect(call.tvSeriesID == 1399)
        #expect(call.startDate == nil)
        #expect(call.endDate == nil)
        #expect(call.page == nil)

        #expect(service.changesForTVSeriesCalls.count == 1)
    }

    @Test("changes(startDate:endDate:page:) dropping one parameter")
    func changesStartDateDroppingOneForwardsTheRest() async throws {
        _ = try await service.changes(
            startDate: Date(timeIntervalSince1970: 1_000_000),
            endDate: Date(timeIntervalSince1970: 2_000_000)
        )
        var call = try #require(service.changesCalls.last)
        #expect(call.startDate == Date(timeIntervalSince1970: 1_000_000))
        #expect(call.endDate == Date(timeIntervalSince1970: 2_000_000))
        #expect(call.page == nil)

        _ = try await service.changes(startDate: Date(timeIntervalSince1970: 1_000_000), page: 3)
        call = try #require(service.changesCalls.last)
        #expect(call.startDate == Date(timeIntervalSince1970: 1_000_000))
        #expect(call.endDate == nil)
        #expect(call.page == 3)

        _ = try await service.changes(endDate: Date(timeIntervalSince1970: 2_000_000), page: 3)
        call = try #require(service.changesCalls.last)
        #expect(call.startDate == nil)
        #expect(call.endDate == Date(timeIntervalSince1970: 2_000_000))
        #expect(call.page == 3)

        #expect(service.changesCalls.count == 3)
    }

    @Test("changes(startDate:endDate:page:) dropping two parameters")
    func changesStartDateDroppingTwoForwardsTheRest() async throws {
        _ = try await service.changes(startDate: Date(timeIntervalSince1970: 1_000_000))
        var call = try #require(service.changesCalls.last)
        #expect(call.startDate == Date(timeIntervalSince1970: 1_000_000))
        #expect(call.endDate == nil)
        #expect(call.page == nil)

        _ = try await service.changes(endDate: Date(timeIntervalSince1970: 2_000_000))
        call = try #require(service.changesCalls.last)
        #expect(call.startDate == nil)
        #expect(call.endDate == Date(timeIntervalSince1970: 2_000_000))
        #expect(call.page == nil)

        _ = try await service.changes(page: 3)
        call = try #require(service.changesCalls.last)
        #expect(call.startDate == nil)
        #expect(call.endDate == nil)
        #expect(call.page == 3)

        #expect(service.changesCalls.count == 3)
    }

    @Test("changes(startDate:endDate:page:) dropping three parameters")
    func changesStartDateDroppingThreeForwardsTheRest() async throws {
        _ = try await service.changes()
        let call = try #require(service.changesCalls.last)
        #expect(call.startDate == nil)
        #expect(call.endDate == nil)
        #expect(call.page == nil)

        #expect(service.changesCalls.count == 1)
    }

    @Test("lists(forTVSeries:page:language:) conveniences forward the parameters they omit")
    func listsOverloadsForwardOmittedParameters() async throws {
        _ = try await service.lists(forTVSeries: 1399, page: 3)
        var call = try #require(service.listsCalls.last)
        #expect(call.tvSeriesID == 1399)
        #expect(call.page == 3)
        #expect(call.language == nil)

        _ = try await service.lists(forTVSeries: 1399, language: "en-GB")
        call = try #require(service.listsCalls.last)
        #expect(call.tvSeriesID == 1399)
        #expect(call.page == nil)
        #expect(call.language == "en-GB")

        _ = try await service.lists(forTVSeries: 1399)
        call = try #require(service.listsCalls.last)
        #expect(call.tvSeriesID == 1399)
        #expect(call.page == nil)
        #expect(call.language == nil)

        #expect(service.listsCalls.count == 3)
    }

    @Test("onTheAir(page:timezone:language:) dropping one parameter")
    func onTheAirDroppingOneForwardsTheRest() async throws {
        _ = try await service.onTheAir(page: 3, timezone: "Europe/London")
        var call = try #require(service.onTheAirCalls.last)
        #expect(call.page == 3)
        #expect(call.timezone == "Europe/London")
        #expect(call.language == nil)

        _ = try await service.onTheAir(page: 3, language: "en-GB")
        call = try #require(service.onTheAirCalls.last)
        #expect(call.page == 3)
        #expect(call.timezone == nil)
        #expect(call.language == "en-GB")

        _ = try await service.onTheAir(timezone: "Europe/London", language: "en-GB")
        call = try #require(service.onTheAirCalls.last)
        #expect(call.page == nil)
        #expect(call.timezone == "Europe/London")
        #expect(call.language == "en-GB")

        #expect(service.onTheAirCalls.count == 3)
    }

    @Test("onTheAir(page:timezone:language:) dropping two parameters")
    func onTheAirDroppingTwoForwardsTheRest() async throws {
        _ = try await service.onTheAir(page: 3)
        var call = try #require(service.onTheAirCalls.last)
        #expect(call.page == 3)
        #expect(call.timezone == nil)
        #expect(call.language == nil)

        _ = try await service.onTheAir(timezone: "Europe/London")
        call = try #require(service.onTheAirCalls.last)
        #expect(call.page == nil)
        #expect(call.timezone == "Europe/London")
        #expect(call.language == nil)

        _ = try await service.onTheAir(language: "en-GB")
        call = try #require(service.onTheAirCalls.last)
        #expect(call.page == nil)
        #expect(call.timezone == nil)
        #expect(call.language == "en-GB")

        #expect(service.onTheAirCalls.count == 3)
    }

    @Test("onTheAir(page:timezone:language:) dropping three parameters")
    func onTheAirDroppingThreeForwardsTheRest() async throws {
        _ = try await service.onTheAir()
        let call = try #require(service.onTheAirCalls.last)
        #expect(call.page == nil)
        #expect(call.timezone == nil)
        #expect(call.language == nil)

        #expect(service.onTheAirCalls.count == 1)
    }

    @Test("popular(page:language:) conveniences forward the parameters they omit")
    func popularOverloadsForwardOmittedParameters() async throws {
        _ = try await service.popular(page: 3)
        var call = try #require(service.popularCalls.last)
        #expect(call.page == 3)
        #expect(call.language == nil)

        _ = try await service.popular(language: "en-GB")
        call = try #require(service.popularCalls.last)
        #expect(call.page == nil)
        #expect(call.language == "en-GB")

        _ = try await service.popular()
        call = try #require(service.popularCalls.last)
        #expect(call.page == nil)
        #expect(call.language == nil)

        #expect(service.popularCalls.count == 3)
    }

    @Test("recommendations(forTVSeries:page:language:) conveniences forward the parameters they omit")
    func recommendationsOverloadsForwardOmittedParameters() async throws {
        _ = try await service.recommendations(forTVSeries: 1399, page: 3)
        var call = try #require(service.recommendationsCalls.last)
        #expect(call.tvSeriesID == 1399)
        #expect(call.page == 3)
        #expect(call.language == nil)

        _ = try await service.recommendations(forTVSeries: 1399, language: "en-GB")
        call = try #require(service.recommendationsCalls.last)
        #expect(call.tvSeriesID == 1399)
        #expect(call.page == nil)
        #expect(call.language == "en-GB")

        _ = try await service.recommendations(forTVSeries: 1399)
        call = try #require(service.recommendationsCalls.last)
        #expect(call.tvSeriesID == 1399)
        #expect(call.page == nil)
        #expect(call.language == nil)

        #expect(service.recommendationsCalls.count == 3)
    }

    @Test("reviews(forTVSeries:page:language:) conveniences forward the parameters they omit")
    func reviewsOverloadsForwardOmittedParameters() async throws {
        _ = try await service.reviews(forTVSeries: 1399, page: 3)
        var call = try #require(service.reviewsCalls.last)
        #expect(call.tvSeriesID == 1399)
        #expect(call.page == 3)
        #expect(call.language == nil)

        _ = try await service.reviews(forTVSeries: 1399, language: "en-GB")
        call = try #require(service.reviewsCalls.last)
        #expect(call.tvSeriesID == 1399)
        #expect(call.page == nil)
        #expect(call.language == "en-GB")

        _ = try await service.reviews(forTVSeries: 1399)
        call = try #require(service.reviewsCalls.last)
        #expect(call.tvSeriesID == 1399)
        #expect(call.page == nil)
        #expect(call.language == nil)

        #expect(service.reviewsCalls.count == 3)
    }

    @Test("similar(toTVSeries:page:language:) conveniences forward the parameters they omit")
    func similarOverloadsForwardOmittedParameters() async throws {
        _ = try await service.similar(toTVSeries: 1399, page: 3)
        var call = try #require(service.similarCalls.last)
        #expect(call.tvSeriesID == 1399)
        #expect(call.page == 3)
        #expect(call.language == nil)

        _ = try await service.similar(toTVSeries: 1399, language: "en-GB")
        call = try #require(service.similarCalls.last)
        #expect(call.tvSeriesID == 1399)
        #expect(call.page == nil)
        #expect(call.language == "en-GB")

        _ = try await service.similar(toTVSeries: 1399)
        call = try #require(service.similarCalls.last)
        #expect(call.tvSeriesID == 1399)
        #expect(call.page == nil)
        #expect(call.language == nil)

        #expect(service.similarCalls.count == 3)
    }

    @Test("topRated(page:language:) conveniences forward the parameters they omit")
    func topRatedOverloadsForwardOmittedParameters() async throws {
        _ = try await service.topRated(page: 3)
        var call = try #require(service.topRatedCalls.last)
        #expect(call.page == 3)
        #expect(call.language == nil)

        _ = try await service.topRated(language: "en-GB")
        call = try #require(service.topRatedCalls.last)
        #expect(call.page == nil)
        #expect(call.language == "en-GB")

        _ = try await service.topRated()
        call = try #require(service.topRatedCalls.last)
        #expect(call.page == nil)
        #expect(call.language == nil)

        #expect(service.topRatedCalls.count == 3)
    }

}

// swiftlint:enable type_body_length
