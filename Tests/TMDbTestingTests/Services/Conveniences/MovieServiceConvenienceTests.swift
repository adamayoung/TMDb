//
//  MovieServiceConvenienceTests.swift
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
/// Pins the zero-defaulted-argument conveniences on ``MovieService``.
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
@Suite(.tags(.testingSupport, .mocks, .movie))
struct MovieServiceConvenienceTests {

    var service: MockMovieService

    init() {
        self.service = MockMovieService()
    }

    @Test("details(forMovie:) forwards a nil language to the requirement")
    func detailsForwardsNilLanguage() async throws {
        _ = try await service.details(forMovie: 550)

        #expect(service.detailsCalls.count == 1)
        let call = try #require(service.detailsCalls.first)
        #expect(call.language == nil)
        #expect(call.movieID == 550)
    }

    @Test("details(forMovie:appending:) forwards a nil language to the requirement")
    func detailsAppendingForwardsNilLanguage() async throws {
        _ = try await service.details(forMovie: 550, appending: .credits)

        #expect(service.detailsAppendingCalls.count == 1)
        let call = try #require(service.detailsAppendingCalls.first)
        #expect(call.language == nil)
        #expect(call.movieID == 550)
        #expect(call.appending == .credits)
    }

    @Test("credits(forMovie:) forwards a nil language to the requirement")
    func creditsForwardsNilLanguage() async throws {
        _ = try await service.credits(forMovie: 550)

        #expect(service.creditsCalls.count == 1)
        let call = try #require(service.creditsCalls.first)
        #expect(call.language == nil)
        #expect(call.movieID == 550)
    }

    @Test("images(forMovie:) forwards a nil filter to the requirement")
    func imagesForwardsNilFilter() async throws {
        _ = try await service.images(forMovie: 550)

        #expect(service.imagesCalls.count == 1)
        let call = try #require(service.imagesCalls.first)
        #expect(call.filter == nil)
        #expect(call.movieID == 550)
    }

    @Test("videos(forMovie:) forwards a nil filter to the requirement")
    func videosForwardsNilFilter() async throws {
        _ = try await service.videos(forMovie: 550)

        #expect(service.videosCalls.count == 1)
        let call = try #require(service.videosCalls.first)
        #expect(call.filter == nil)
        #expect(call.movieID == 550)
    }

    ///
    /// `releaseDates(forMovie:)` had a `public extension` twin with the *same*
    /// signature, whose body called itself. It was therefore the requirement's
    /// witness, so a conformer that omitted the requirement recursed until the
    /// stack overflowed instead of failing to compile. The twin is now deleted.
    ///
    /// This is a smoke test, **not** a regression pin, and no test can be one:
    /// `MockMovieService` declares `releaseDates(forMovie:)` concretely, and a
    /// concrete member always beats a protocol-extension member of the same
    /// signature — so this would stay green if the twin came back. The only
    /// conformer that recurses is one that *omits* the requirement, which must
    /// be a compile error and so cannot be written. Invariant 1 of
    /// `Scripts/check-defaulted-witnesses.py`, exercised by its `SELF_TEST`, is
    /// what actually guards this.
    ///
    @Test("releaseDates(forMovie:) reaches the requirement")
    func releaseDatesReachesRequirement() async throws {
        _ = try await service.releaseDates(forMovie: 550)

        #expect(service.releaseDatesCalls.count == 1)
        let call = try #require(service.releaseDatesCalls.first)
        #expect(call.movieID == 550)
    }

    @Test("alternativeTitles(forMovie:country:language:) conveniences forward the parameters they omit")
    func alternativeTitlesOverloadsForwardOmittedParameters() async throws {
        _ = try await service.alternativeTitles(forMovie: 550, country: "GB")
        var call = try #require(service.alternativeTitlesCalls.last)
        #expect(call.movieID == 550)
        #expect(call.country == "GB")
        #expect(call.language == nil)

        _ = try await service.alternativeTitles(forMovie: 550, language: "en-GB")
        call = try #require(service.alternativeTitlesCalls.last)
        #expect(call.movieID == 550)
        #expect(call.country == nil)
        #expect(call.language == "en-GB")

        _ = try await service.alternativeTitles(forMovie: 550)
        call = try #require(service.alternativeTitlesCalls.last)
        #expect(call.movieID == 550)
        #expect(call.country == nil)
        #expect(call.language == nil)

        #expect(service.alternativeTitlesCalls.count == 3)
    }

    @Test("changes(forMovie:startDate:endDate:page:) dropping one parameter")
    func changesForMovieDroppingOneForwardsTheRest() async throws {
        _ = try await service.changes(
            forMovie: 550,
            startDate: Date(timeIntervalSince1970: 1_000_000),
            endDate: Date(timeIntervalSince1970: 2_000_000)
        )
        var call = try #require(service.changesForMovieCalls.last)
        #expect(call.movieID == 550)
        #expect(call.startDate == Date(timeIntervalSince1970: 1_000_000))
        #expect(call.endDate == Date(timeIntervalSince1970: 2_000_000))
        #expect(call.page == nil)

        _ = try await service.changes(forMovie: 550, startDate: Date(timeIntervalSince1970: 1_000_000), page: 3)
        call = try #require(service.changesForMovieCalls.last)
        #expect(call.movieID == 550)
        #expect(call.startDate == Date(timeIntervalSince1970: 1_000_000))
        #expect(call.endDate == nil)
        #expect(call.page == 3)

        _ = try await service.changes(forMovie: 550, endDate: Date(timeIntervalSince1970: 2_000_000), page: 3)
        call = try #require(service.changesForMovieCalls.last)
        #expect(call.movieID == 550)
        #expect(call.startDate == nil)
        #expect(call.endDate == Date(timeIntervalSince1970: 2_000_000))
        #expect(call.page == 3)

        #expect(service.changesForMovieCalls.count == 3)
    }

    @Test("changes(forMovie:startDate:endDate:page:) dropping two parameters")
    func changesForMovieDroppingTwoForwardsTheRest() async throws {
        _ = try await service.changes(forMovie: 550, startDate: Date(timeIntervalSince1970: 1_000_000))
        var call = try #require(service.changesForMovieCalls.last)
        #expect(call.movieID == 550)
        #expect(call.startDate == Date(timeIntervalSince1970: 1_000_000))
        #expect(call.endDate == nil)
        #expect(call.page == nil)

        _ = try await service.changes(forMovie: 550, endDate: Date(timeIntervalSince1970: 2_000_000))
        call = try #require(service.changesForMovieCalls.last)
        #expect(call.movieID == 550)
        #expect(call.startDate == nil)
        #expect(call.endDate == Date(timeIntervalSince1970: 2_000_000))
        #expect(call.page == nil)

        _ = try await service.changes(forMovie: 550, page: 3)
        call = try #require(service.changesForMovieCalls.last)
        #expect(call.movieID == 550)
        #expect(call.startDate == nil)
        #expect(call.endDate == nil)
        #expect(call.page == 3)

        #expect(service.changesForMovieCalls.count == 3)
    }

    @Test("changes(forMovie:startDate:endDate:page:) dropping three parameters")
    func changesForMovieDroppingThreeForwardsTheRest() async throws {
        _ = try await service.changes(forMovie: 550)
        let call = try #require(service.changesForMovieCalls.last)
        #expect(call.movieID == 550)
        #expect(call.startDate == nil)
        #expect(call.endDate == nil)
        #expect(call.page == nil)

        #expect(service.changesForMovieCalls.count == 1)
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

    @Test("lists(forMovie:page:language:) conveniences forward the parameters they omit")
    func listsOverloadsForwardOmittedParameters() async throws {
        _ = try await service.lists(forMovie: 550, page: 3)
        var call = try #require(service.listsCalls.last)
        #expect(call.movieID == 550)
        #expect(call.page == 3)
        #expect(call.language == nil)

        _ = try await service.lists(forMovie: 550, language: "en-GB")
        call = try #require(service.listsCalls.last)
        #expect(call.movieID == 550)
        #expect(call.page == nil)
        #expect(call.language == "en-GB")

        _ = try await service.lists(forMovie: 550)
        call = try #require(service.listsCalls.last)
        #expect(call.movieID == 550)
        #expect(call.page == nil)
        #expect(call.language == nil)

        #expect(service.listsCalls.count == 3)
    }

    @Test("nowPlaying(page:country:language:) dropping one parameter")
    func nowPlayingDroppingOneForwardsTheRest() async throws {
        _ = try await service.nowPlaying(page: 3, country: "GB")
        var call = try #require(service.nowPlayingCalls.last)
        #expect(call.page == 3)
        #expect(call.country == "GB")
        #expect(call.language == nil)

        _ = try await service.nowPlaying(page: 3, language: "en-GB")
        call = try #require(service.nowPlayingCalls.last)
        #expect(call.page == 3)
        #expect(call.country == nil)
        #expect(call.language == "en-GB")

        _ = try await service.nowPlaying(country: "GB", language: "en-GB")
        call = try #require(service.nowPlayingCalls.last)
        #expect(call.page == nil)
        #expect(call.country == "GB")
        #expect(call.language == "en-GB")

        #expect(service.nowPlayingCalls.count == 3)
    }

    @Test("nowPlaying(page:country:language:) dropping two parameters")
    func nowPlayingDroppingTwoForwardsTheRest() async throws {
        _ = try await service.nowPlaying(page: 3)
        var call = try #require(service.nowPlayingCalls.last)
        #expect(call.page == 3)
        #expect(call.country == nil)
        #expect(call.language == nil)

        _ = try await service.nowPlaying(country: "GB")
        call = try #require(service.nowPlayingCalls.last)
        #expect(call.page == nil)
        #expect(call.country == "GB")
        #expect(call.language == nil)

        _ = try await service.nowPlaying(language: "en-GB")
        call = try #require(service.nowPlayingCalls.last)
        #expect(call.page == nil)
        #expect(call.country == nil)
        #expect(call.language == "en-GB")

        #expect(service.nowPlayingCalls.count == 3)
    }

    @Test("nowPlaying(page:country:language:) dropping three parameters")
    func nowPlayingDroppingThreeForwardsTheRest() async throws {
        _ = try await service.nowPlaying()
        let call = try #require(service.nowPlayingCalls.last)
        #expect(call.page == nil)
        #expect(call.country == nil)
        #expect(call.language == nil)

        #expect(service.nowPlayingCalls.count == 1)
    }

    @Test("popular(page:country:language:) dropping one parameter")
    func popularDroppingOneForwardsTheRest() async throws {
        _ = try await service.popular(page: 3, country: "GB")
        var call = try #require(service.popularCalls.last)
        #expect(call.page == 3)
        #expect(call.country == "GB")
        #expect(call.language == nil)

        _ = try await service.popular(page: 3, language: "en-GB")
        call = try #require(service.popularCalls.last)
        #expect(call.page == 3)
        #expect(call.country == nil)
        #expect(call.language == "en-GB")

        _ = try await service.popular(country: "GB", language: "en-GB")
        call = try #require(service.popularCalls.last)
        #expect(call.page == nil)
        #expect(call.country == "GB")
        #expect(call.language == "en-GB")

        #expect(service.popularCalls.count == 3)
    }

    @Test("popular(page:country:language:) dropping two parameters")
    func popularDroppingTwoForwardsTheRest() async throws {
        _ = try await service.popular(page: 3)
        var call = try #require(service.popularCalls.last)
        #expect(call.page == 3)
        #expect(call.country == nil)
        #expect(call.language == nil)

        _ = try await service.popular(country: "GB")
        call = try #require(service.popularCalls.last)
        #expect(call.page == nil)
        #expect(call.country == "GB")
        #expect(call.language == nil)

        _ = try await service.popular(language: "en-GB")
        call = try #require(service.popularCalls.last)
        #expect(call.page == nil)
        #expect(call.country == nil)
        #expect(call.language == "en-GB")

        #expect(service.popularCalls.count == 3)
    }

    @Test("popular(page:country:language:) dropping three parameters")
    func popularDroppingThreeForwardsTheRest() async throws {
        _ = try await service.popular()
        let call = try #require(service.popularCalls.last)
        #expect(call.page == nil)
        #expect(call.country == nil)
        #expect(call.language == nil)

        #expect(service.popularCalls.count == 1)
    }

    @Test("recommendations(forMovie:page:language:) conveniences forward the parameters they omit")
    func recommendationsOverloadsForwardOmittedParameters() async throws {
        _ = try await service.recommendations(forMovie: 550, page: 3)
        var call = try #require(service.recommendationsCalls.last)
        #expect(call.movieID == 550)
        #expect(call.page == 3)
        #expect(call.language == nil)

        _ = try await service.recommendations(forMovie: 550, language: "en-GB")
        call = try #require(service.recommendationsCalls.last)
        #expect(call.movieID == 550)
        #expect(call.page == nil)
        #expect(call.language == "en-GB")

        _ = try await service.recommendations(forMovie: 550)
        call = try #require(service.recommendationsCalls.last)
        #expect(call.movieID == 550)
        #expect(call.page == nil)
        #expect(call.language == nil)

        #expect(service.recommendationsCalls.count == 3)
    }

    @Test("reviews(forMovie:page:language:) conveniences forward the parameters they omit")
    func reviewsOverloadsForwardOmittedParameters() async throws {
        _ = try await service.reviews(forMovie: 550, page: 3)
        var call = try #require(service.reviewsCalls.last)
        #expect(call.movieID == 550)
        #expect(call.page == 3)
        #expect(call.language == nil)

        _ = try await service.reviews(forMovie: 550, language: "en-GB")
        call = try #require(service.reviewsCalls.last)
        #expect(call.movieID == 550)
        #expect(call.page == nil)
        #expect(call.language == "en-GB")

        _ = try await service.reviews(forMovie: 550)
        call = try #require(service.reviewsCalls.last)
        #expect(call.movieID == 550)
        #expect(call.page == nil)
        #expect(call.language == nil)

        #expect(service.reviewsCalls.count == 3)
    }

    @Test("similar(toMovie:page:language:) conveniences forward the parameters they omit")
    func similarOverloadsForwardOmittedParameters() async throws {
        _ = try await service.similar(toMovie: 550, page: 3)
        var call = try #require(service.similarCalls.last)
        #expect(call.movieID == 550)
        #expect(call.page == 3)
        #expect(call.language == nil)

        _ = try await service.similar(toMovie: 550, language: "en-GB")
        call = try #require(service.similarCalls.last)
        #expect(call.movieID == 550)
        #expect(call.page == nil)
        #expect(call.language == "en-GB")

        _ = try await service.similar(toMovie: 550)
        call = try #require(service.similarCalls.last)
        #expect(call.movieID == 550)
        #expect(call.page == nil)
        #expect(call.language == nil)

        #expect(service.similarCalls.count == 3)
    }

    @Test("topRated(page:country:language:) dropping one parameter")
    func topRatedDroppingOneForwardsTheRest() async throws {
        _ = try await service.topRated(page: 3, country: "GB")
        var call = try #require(service.topRatedCalls.last)
        #expect(call.page == 3)
        #expect(call.country == "GB")
        #expect(call.language == nil)

        _ = try await service.topRated(page: 3, language: "en-GB")
        call = try #require(service.topRatedCalls.last)
        #expect(call.page == 3)
        #expect(call.country == nil)
        #expect(call.language == "en-GB")

        _ = try await service.topRated(country: "GB", language: "en-GB")
        call = try #require(service.topRatedCalls.last)
        #expect(call.page == nil)
        #expect(call.country == "GB")
        #expect(call.language == "en-GB")

        #expect(service.topRatedCalls.count == 3)
    }

    @Test("topRated(page:country:language:) dropping two parameters")
    func topRatedDroppingTwoForwardsTheRest() async throws {
        _ = try await service.topRated(page: 3)
        var call = try #require(service.topRatedCalls.last)
        #expect(call.page == 3)
        #expect(call.country == nil)
        #expect(call.language == nil)

        _ = try await service.topRated(country: "GB")
        call = try #require(service.topRatedCalls.last)
        #expect(call.page == nil)
        #expect(call.country == "GB")
        #expect(call.language == nil)

        _ = try await service.topRated(language: "en-GB")
        call = try #require(service.topRatedCalls.last)
        #expect(call.page == nil)
        #expect(call.country == nil)
        #expect(call.language == "en-GB")

        #expect(service.topRatedCalls.count == 3)
    }

    @Test("topRated(page:country:language:) dropping three parameters")
    func topRatedDroppingThreeForwardsTheRest() async throws {
        _ = try await service.topRated()
        let call = try #require(service.topRatedCalls.last)
        #expect(call.page == nil)
        #expect(call.country == nil)
        #expect(call.language == nil)

        #expect(service.topRatedCalls.count == 1)
    }

    @Test("upcoming(page:country:language:) dropping one parameter")
    func upcomingDroppingOneForwardsTheRest() async throws {
        _ = try await service.upcoming(page: 3, country: "GB")
        var call = try #require(service.upcomingCalls.last)
        #expect(call.page == 3)
        #expect(call.country == "GB")
        #expect(call.language == nil)

        _ = try await service.upcoming(page: 3, language: "en-GB")
        call = try #require(service.upcomingCalls.last)
        #expect(call.page == 3)
        #expect(call.country == nil)
        #expect(call.language == "en-GB")

        _ = try await service.upcoming(country: "GB", language: "en-GB")
        call = try #require(service.upcomingCalls.last)
        #expect(call.page == nil)
        #expect(call.country == "GB")
        #expect(call.language == "en-GB")

        #expect(service.upcomingCalls.count == 3)
    }

    @Test("upcoming(page:country:language:) dropping two parameters")
    func upcomingDroppingTwoForwardsTheRest() async throws {
        _ = try await service.upcoming(page: 3)
        var call = try #require(service.upcomingCalls.last)
        #expect(call.page == 3)
        #expect(call.country == nil)
        #expect(call.language == nil)

        _ = try await service.upcoming(country: "GB")
        call = try #require(service.upcomingCalls.last)
        #expect(call.page == nil)
        #expect(call.country == "GB")
        #expect(call.language == nil)

        _ = try await service.upcoming(language: "en-GB")
        call = try #require(service.upcomingCalls.last)
        #expect(call.page == nil)
        #expect(call.country == nil)
        #expect(call.language == "en-GB")

        #expect(service.upcomingCalls.count == 3)
    }

    @Test("upcoming(page:country:language:) dropping three parameters")
    func upcomingDroppingThreeForwardsTheRest() async throws {
        _ = try await service.upcoming()
        let call = try #require(service.upcomingCalls.last)
        #expect(call.page == nil)
        #expect(call.country == nil)
        #expect(call.language == nil)

        #expect(service.upcomingCalls.count == 1)
    }

}

// swiftlint:enable type_body_length
