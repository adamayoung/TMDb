//
//  ChangesServiceConvenienceTests.swift
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
/// Pins the zero-defaulted-argument conveniences on ``ChangesService``.
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
@Suite(.tags(.testingSupport, .mocks, .changes))
struct ChangesServiceConvenienceTests {

    var service: MockChangesService

    init() {
        self.service = MockChangesService()
    }

    @Test("movieChanges(startDate:endDate:page:) dropping one parameter")
    func movieChangesDroppingOneForwardsTheRest() async throws {
        _ = try await service.movieChanges(
            startDate: Date(timeIntervalSince1970: 1_000_000),
            endDate: Date(timeIntervalSince1970: 2_000_000)
        )
        var call = try #require(service.movieChangesCalls.last)
        #expect(call.startDate == Date(timeIntervalSince1970: 1_000_000))
        #expect(call.endDate == Date(timeIntervalSince1970: 2_000_000))
        #expect(call.page == nil)

        _ = try await service.movieChanges(startDate: Date(timeIntervalSince1970: 1_000_000), page: 3)
        call = try #require(service.movieChangesCalls.last)
        #expect(call.startDate == Date(timeIntervalSince1970: 1_000_000))
        #expect(call.endDate == nil)
        #expect(call.page == 3)

        _ = try await service.movieChanges(endDate: Date(timeIntervalSince1970: 2_000_000), page: 3)
        call = try #require(service.movieChangesCalls.last)
        #expect(call.startDate == nil)
        #expect(call.endDate == Date(timeIntervalSince1970: 2_000_000))
        #expect(call.page == 3)

        #expect(service.movieChangesCalls.count == 3)
    }

    @Test("movieChanges(startDate:endDate:page:) dropping two parameters")
    func movieChangesDroppingTwoForwardsTheRest() async throws {
        _ = try await service.movieChanges(startDate: Date(timeIntervalSince1970: 1_000_000))
        var call = try #require(service.movieChangesCalls.last)
        #expect(call.startDate == Date(timeIntervalSince1970: 1_000_000))
        #expect(call.endDate == nil)
        #expect(call.page == nil)

        _ = try await service.movieChanges(endDate: Date(timeIntervalSince1970: 2_000_000))
        call = try #require(service.movieChangesCalls.last)
        #expect(call.startDate == nil)
        #expect(call.endDate == Date(timeIntervalSince1970: 2_000_000))
        #expect(call.page == nil)

        _ = try await service.movieChanges(page: 3)
        call = try #require(service.movieChangesCalls.last)
        #expect(call.startDate == nil)
        #expect(call.endDate == nil)
        #expect(call.page == 3)

        #expect(service.movieChangesCalls.count == 3)
    }

    @Test("movieChanges(startDate:endDate:page:) dropping three parameters")
    func movieChangesDroppingThreeForwardsTheRest() async throws {
        _ = try await service.movieChanges()
        let call = try #require(service.movieChangesCalls.last)
        #expect(call.startDate == nil)
        #expect(call.endDate == nil)
        #expect(call.page == nil)

        #expect(service.movieChangesCalls.count == 1)
    }

    @Test("movieDetails(forMovie:startDate:endDate:page:) dropping one parameter")
    func movieDetailsDroppingOneForwardsTheRest() async throws {
        _ = try await service.movieDetails(
            forMovie: 550,
            startDate: Date(timeIntervalSince1970: 1_000_000),
            endDate: Date(timeIntervalSince1970: 2_000_000)
        )
        var call = try #require(service.movieDetailsCalls.last)
        #expect(call.id == 550)
        #expect(call.startDate == Date(timeIntervalSince1970: 1_000_000))
        #expect(call.endDate == Date(timeIntervalSince1970: 2_000_000))
        #expect(call.page == nil)

        _ = try await service.movieDetails(forMovie: 550, startDate: Date(timeIntervalSince1970: 1_000_000), page: 3)
        call = try #require(service.movieDetailsCalls.last)
        #expect(call.id == 550)
        #expect(call.startDate == Date(timeIntervalSince1970: 1_000_000))
        #expect(call.endDate == nil)
        #expect(call.page == 3)

        _ = try await service.movieDetails(forMovie: 550, endDate: Date(timeIntervalSince1970: 2_000_000), page: 3)
        call = try #require(service.movieDetailsCalls.last)
        #expect(call.id == 550)
        #expect(call.startDate == nil)
        #expect(call.endDate == Date(timeIntervalSince1970: 2_000_000))
        #expect(call.page == 3)

        #expect(service.movieDetailsCalls.count == 3)
    }

    @Test("movieDetails(forMovie:startDate:endDate:page:) dropping two parameters")
    func movieDetailsDroppingTwoForwardsTheRest() async throws {
        _ = try await service.movieDetails(forMovie: 550, startDate: Date(timeIntervalSince1970: 1_000_000))
        var call = try #require(service.movieDetailsCalls.last)
        #expect(call.id == 550)
        #expect(call.startDate == Date(timeIntervalSince1970: 1_000_000))
        #expect(call.endDate == nil)
        #expect(call.page == nil)

        _ = try await service.movieDetails(forMovie: 550, endDate: Date(timeIntervalSince1970: 2_000_000))
        call = try #require(service.movieDetailsCalls.last)
        #expect(call.id == 550)
        #expect(call.startDate == nil)
        #expect(call.endDate == Date(timeIntervalSince1970: 2_000_000))
        #expect(call.page == nil)

        _ = try await service.movieDetails(forMovie: 550, page: 3)
        call = try #require(service.movieDetailsCalls.last)
        #expect(call.id == 550)
        #expect(call.startDate == nil)
        #expect(call.endDate == nil)
        #expect(call.page == 3)

        #expect(service.movieDetailsCalls.count == 3)
    }

    @Test("movieDetails(forMovie:startDate:endDate:page:) dropping three parameters")
    func movieDetailsDroppingThreeForwardsTheRest() async throws {
        _ = try await service.movieDetails(forMovie: 550)
        let call = try #require(service.movieDetailsCalls.last)
        #expect(call.id == 550)
        #expect(call.startDate == nil)
        #expect(call.endDate == nil)
        #expect(call.page == nil)

        #expect(service.movieDetailsCalls.count == 1)
    }

    @Test("personChanges(startDate:endDate:page:) dropping one parameter")
    func personChangesDroppingOneForwardsTheRest() async throws {
        _ = try await service.personChanges(
            startDate: Date(timeIntervalSince1970: 1_000_000),
            endDate: Date(timeIntervalSince1970: 2_000_000)
        )
        var call = try #require(service.personChangesCalls.last)
        #expect(call.startDate == Date(timeIntervalSince1970: 1_000_000))
        #expect(call.endDate == Date(timeIntervalSince1970: 2_000_000))
        #expect(call.page == nil)

        _ = try await service.personChanges(startDate: Date(timeIntervalSince1970: 1_000_000), page: 3)
        call = try #require(service.personChangesCalls.last)
        #expect(call.startDate == Date(timeIntervalSince1970: 1_000_000))
        #expect(call.endDate == nil)
        #expect(call.page == 3)

        _ = try await service.personChanges(endDate: Date(timeIntervalSince1970: 2_000_000), page: 3)
        call = try #require(service.personChangesCalls.last)
        #expect(call.startDate == nil)
        #expect(call.endDate == Date(timeIntervalSince1970: 2_000_000))
        #expect(call.page == 3)

        #expect(service.personChangesCalls.count == 3)
    }

    @Test("personChanges(startDate:endDate:page:) dropping two parameters")
    func personChangesDroppingTwoForwardsTheRest() async throws {
        _ = try await service.personChanges(startDate: Date(timeIntervalSince1970: 1_000_000))
        var call = try #require(service.personChangesCalls.last)
        #expect(call.startDate == Date(timeIntervalSince1970: 1_000_000))
        #expect(call.endDate == nil)
        #expect(call.page == nil)

        _ = try await service.personChanges(endDate: Date(timeIntervalSince1970: 2_000_000))
        call = try #require(service.personChangesCalls.last)
        #expect(call.startDate == nil)
        #expect(call.endDate == Date(timeIntervalSince1970: 2_000_000))
        #expect(call.page == nil)

        _ = try await service.personChanges(page: 3)
        call = try #require(service.personChangesCalls.last)
        #expect(call.startDate == nil)
        #expect(call.endDate == nil)
        #expect(call.page == 3)

        #expect(service.personChangesCalls.count == 3)
    }

    @Test("personChanges(startDate:endDate:page:) dropping three parameters")
    func personChangesDroppingThreeForwardsTheRest() async throws {
        _ = try await service.personChanges()
        let call = try #require(service.personChangesCalls.last)
        #expect(call.startDate == nil)
        #expect(call.endDate == nil)
        #expect(call.page == nil)

        #expect(service.personChangesCalls.count == 1)
    }

    @Test("personDetails(forPerson:startDate:endDate:page:) dropping one parameter")
    func personDetailsDroppingOneForwardsTheRest() async throws {
        _ = try await service.personDetails(
            forPerson: 500,
            startDate: Date(timeIntervalSince1970: 1_000_000),
            endDate: Date(timeIntervalSince1970: 2_000_000)
        )
        var call = try #require(service.personDetailsCalls.last)
        #expect(call.id == 500)
        #expect(call.startDate == Date(timeIntervalSince1970: 1_000_000))
        #expect(call.endDate == Date(timeIntervalSince1970: 2_000_000))
        #expect(call.page == nil)

        _ = try await service.personDetails(forPerson: 500, startDate: Date(timeIntervalSince1970: 1_000_000), page: 3)
        call = try #require(service.personDetailsCalls.last)
        #expect(call.id == 500)
        #expect(call.startDate == Date(timeIntervalSince1970: 1_000_000))
        #expect(call.endDate == nil)
        #expect(call.page == 3)

        _ = try await service.personDetails(forPerson: 500, endDate: Date(timeIntervalSince1970: 2_000_000), page: 3)
        call = try #require(service.personDetailsCalls.last)
        #expect(call.id == 500)
        #expect(call.startDate == nil)
        #expect(call.endDate == Date(timeIntervalSince1970: 2_000_000))
        #expect(call.page == 3)

        #expect(service.personDetailsCalls.count == 3)
    }

    @Test("personDetails(forPerson:startDate:endDate:page:) dropping two parameters")
    func personDetailsDroppingTwoForwardsTheRest() async throws {
        _ = try await service.personDetails(forPerson: 500, startDate: Date(timeIntervalSince1970: 1_000_000))
        var call = try #require(service.personDetailsCalls.last)
        #expect(call.id == 500)
        #expect(call.startDate == Date(timeIntervalSince1970: 1_000_000))
        #expect(call.endDate == nil)
        #expect(call.page == nil)

        _ = try await service.personDetails(forPerson: 500, endDate: Date(timeIntervalSince1970: 2_000_000))
        call = try #require(service.personDetailsCalls.last)
        #expect(call.id == 500)
        #expect(call.startDate == nil)
        #expect(call.endDate == Date(timeIntervalSince1970: 2_000_000))
        #expect(call.page == nil)

        _ = try await service.personDetails(forPerson: 500, page: 3)
        call = try #require(service.personDetailsCalls.last)
        #expect(call.id == 500)
        #expect(call.startDate == nil)
        #expect(call.endDate == nil)
        #expect(call.page == 3)

        #expect(service.personDetailsCalls.count == 3)
    }

    @Test("personDetails(forPerson:startDate:endDate:page:) dropping three parameters")
    func personDetailsDroppingThreeForwardsTheRest() async throws {
        _ = try await service.personDetails(forPerson: 500)
        let call = try #require(service.personDetailsCalls.last)
        #expect(call.id == 500)
        #expect(call.startDate == nil)
        #expect(call.endDate == nil)
        #expect(call.page == nil)

        #expect(service.personDetailsCalls.count == 1)
    }

    @Test("tvEpisodeDetails(forEpisode:startDate:endDate:page:) dropping one parameter")
    func tvEpisodeDetailsDroppingOneForwardsTheRest() async throws {
        _ = try await service.tvEpisodeDetails(
            forEpisode: 1,
            startDate: Date(timeIntervalSince1970: 1_000_000),
            endDate: Date(timeIntervalSince1970: 2_000_000)
        )
        var call = try #require(service.tvEpisodeDetailsCalls.last)
        #expect(call.episodeID == 1)
        #expect(call.startDate == Date(timeIntervalSince1970: 1_000_000))
        #expect(call.endDate == Date(timeIntervalSince1970: 2_000_000))
        #expect(call.page == nil)

        _ = try await service.tvEpisodeDetails(
            forEpisode: 1,
            startDate: Date(timeIntervalSince1970: 1_000_000),
            page: 3
        )
        call = try #require(service.tvEpisodeDetailsCalls.last)
        #expect(call.episodeID == 1)
        #expect(call.startDate == Date(timeIntervalSince1970: 1_000_000))
        #expect(call.endDate == nil)
        #expect(call.page == 3)

        _ = try await service.tvEpisodeDetails(forEpisode: 1, endDate: Date(timeIntervalSince1970: 2_000_000), page: 3)
        call = try #require(service.tvEpisodeDetailsCalls.last)
        #expect(call.episodeID == 1)
        #expect(call.startDate == nil)
        #expect(call.endDate == Date(timeIntervalSince1970: 2_000_000))
        #expect(call.page == 3)

        #expect(service.tvEpisodeDetailsCalls.count == 3)
    }

    @Test("tvEpisodeDetails(forEpisode:startDate:endDate:page:) dropping two parameters")
    func tvEpisodeDetailsDroppingTwoForwardsTheRest() async throws {
        _ = try await service.tvEpisodeDetails(forEpisode: 1, startDate: Date(timeIntervalSince1970: 1_000_000))
        var call = try #require(service.tvEpisodeDetailsCalls.last)
        #expect(call.episodeID == 1)
        #expect(call.startDate == Date(timeIntervalSince1970: 1_000_000))
        #expect(call.endDate == nil)
        #expect(call.page == nil)

        _ = try await service.tvEpisodeDetails(forEpisode: 1, endDate: Date(timeIntervalSince1970: 2_000_000))
        call = try #require(service.tvEpisodeDetailsCalls.last)
        #expect(call.episodeID == 1)
        #expect(call.startDate == nil)
        #expect(call.endDate == Date(timeIntervalSince1970: 2_000_000))
        #expect(call.page == nil)

        _ = try await service.tvEpisodeDetails(forEpisode: 1, page: 3)
        call = try #require(service.tvEpisodeDetailsCalls.last)
        #expect(call.episodeID == 1)
        #expect(call.startDate == nil)
        #expect(call.endDate == nil)
        #expect(call.page == 3)

        #expect(service.tvEpisodeDetailsCalls.count == 3)
    }

    @Test("tvEpisodeDetails(forEpisode:startDate:endDate:page:) dropping three parameters")
    func tvEpisodeDetailsDroppingThreeForwardsTheRest() async throws {
        _ = try await service.tvEpisodeDetails(forEpisode: 1)
        let call = try #require(service.tvEpisodeDetailsCalls.last)
        #expect(call.episodeID == 1)
        #expect(call.startDate == nil)
        #expect(call.endDate == nil)
        #expect(call.page == nil)

        #expect(service.tvEpisodeDetailsCalls.count == 1)
    }

    @Test("tvSeasonDetails(forSeason:startDate:endDate:page:) dropping one parameter")
    func tvSeasonDetailsDroppingOneForwardsTheRest() async throws {
        _ = try await service.tvSeasonDetails(
            forSeason: 1,
            startDate: Date(timeIntervalSince1970: 1_000_000),
            endDate: Date(timeIntervalSince1970: 2_000_000)
        )
        var call = try #require(service.tvSeasonDetailsCalls.last)
        #expect(call.seasonID == 1)
        #expect(call.startDate == Date(timeIntervalSince1970: 1_000_000))
        #expect(call.endDate == Date(timeIntervalSince1970: 2_000_000))
        #expect(call.page == nil)

        _ = try await service.tvSeasonDetails(forSeason: 1, startDate: Date(timeIntervalSince1970: 1_000_000), page: 3)
        call = try #require(service.tvSeasonDetailsCalls.last)
        #expect(call.seasonID == 1)
        #expect(call.startDate == Date(timeIntervalSince1970: 1_000_000))
        #expect(call.endDate == nil)
        #expect(call.page == 3)

        _ = try await service.tvSeasonDetails(forSeason: 1, endDate: Date(timeIntervalSince1970: 2_000_000), page: 3)
        call = try #require(service.tvSeasonDetailsCalls.last)
        #expect(call.seasonID == 1)
        #expect(call.startDate == nil)
        #expect(call.endDate == Date(timeIntervalSince1970: 2_000_000))
        #expect(call.page == 3)

        #expect(service.tvSeasonDetailsCalls.count == 3)
    }

    @Test("tvSeasonDetails(forSeason:startDate:endDate:page:) dropping two parameters")
    func tvSeasonDetailsDroppingTwoForwardsTheRest() async throws {
        _ = try await service.tvSeasonDetails(forSeason: 1, startDate: Date(timeIntervalSince1970: 1_000_000))
        var call = try #require(service.tvSeasonDetailsCalls.last)
        #expect(call.seasonID == 1)
        #expect(call.startDate == Date(timeIntervalSince1970: 1_000_000))
        #expect(call.endDate == nil)
        #expect(call.page == nil)

        _ = try await service.tvSeasonDetails(forSeason: 1, endDate: Date(timeIntervalSince1970: 2_000_000))
        call = try #require(service.tvSeasonDetailsCalls.last)
        #expect(call.seasonID == 1)
        #expect(call.startDate == nil)
        #expect(call.endDate == Date(timeIntervalSince1970: 2_000_000))
        #expect(call.page == nil)

        _ = try await service.tvSeasonDetails(forSeason: 1, page: 3)
        call = try #require(service.tvSeasonDetailsCalls.last)
        #expect(call.seasonID == 1)
        #expect(call.startDate == nil)
        #expect(call.endDate == nil)
        #expect(call.page == 3)

        #expect(service.tvSeasonDetailsCalls.count == 3)
    }

    @Test("tvSeasonDetails(forSeason:startDate:endDate:page:) dropping three parameters")
    func tvSeasonDetailsDroppingThreeForwardsTheRest() async throws {
        _ = try await service.tvSeasonDetails(forSeason: 1)
        let call = try #require(service.tvSeasonDetailsCalls.last)
        #expect(call.seasonID == 1)
        #expect(call.startDate == nil)
        #expect(call.endDate == nil)
        #expect(call.page == nil)

        #expect(service.tvSeasonDetailsCalls.count == 1)
    }

    @Test("tvSeriesChanges(startDate:endDate:page:) dropping one parameter")
    func tvSeriesChangesDroppingOneForwardsTheRest() async throws {
        _ = try await service.tvSeriesChanges(
            startDate: Date(timeIntervalSince1970: 1_000_000),
            endDate: Date(timeIntervalSince1970: 2_000_000)
        )
        var call = try #require(service.tvSeriesChangesCalls.last)
        #expect(call.startDate == Date(timeIntervalSince1970: 1_000_000))
        #expect(call.endDate == Date(timeIntervalSince1970: 2_000_000))
        #expect(call.page == nil)

        _ = try await service.tvSeriesChanges(startDate: Date(timeIntervalSince1970: 1_000_000), page: 3)
        call = try #require(service.tvSeriesChangesCalls.last)
        #expect(call.startDate == Date(timeIntervalSince1970: 1_000_000))
        #expect(call.endDate == nil)
        #expect(call.page == 3)

        _ = try await service.tvSeriesChanges(endDate: Date(timeIntervalSince1970: 2_000_000), page: 3)
        call = try #require(service.tvSeriesChangesCalls.last)
        #expect(call.startDate == nil)
        #expect(call.endDate == Date(timeIntervalSince1970: 2_000_000))
        #expect(call.page == 3)

        #expect(service.tvSeriesChangesCalls.count == 3)
    }

    @Test("tvSeriesChanges(startDate:endDate:page:) dropping two parameters")
    func tvSeriesChangesDroppingTwoForwardsTheRest() async throws {
        _ = try await service.tvSeriesChanges(startDate: Date(timeIntervalSince1970: 1_000_000))
        var call = try #require(service.tvSeriesChangesCalls.last)
        #expect(call.startDate == Date(timeIntervalSince1970: 1_000_000))
        #expect(call.endDate == nil)
        #expect(call.page == nil)

        _ = try await service.tvSeriesChanges(endDate: Date(timeIntervalSince1970: 2_000_000))
        call = try #require(service.tvSeriesChangesCalls.last)
        #expect(call.startDate == nil)
        #expect(call.endDate == Date(timeIntervalSince1970: 2_000_000))
        #expect(call.page == nil)

        _ = try await service.tvSeriesChanges(page: 3)
        call = try #require(service.tvSeriesChangesCalls.last)
        #expect(call.startDate == nil)
        #expect(call.endDate == nil)
        #expect(call.page == 3)

        #expect(service.tvSeriesChangesCalls.count == 3)
    }

    @Test("tvSeriesChanges(startDate:endDate:page:) dropping three parameters")
    func tvSeriesChangesDroppingThreeForwardsTheRest() async throws {
        _ = try await service.tvSeriesChanges()
        let call = try #require(service.tvSeriesChangesCalls.last)
        #expect(call.startDate == nil)
        #expect(call.endDate == nil)
        #expect(call.page == nil)

        #expect(service.tvSeriesChangesCalls.count == 1)
    }

    @Test("tvSeriesDetails(forTVSeries:startDate:endDate:page:) dropping one parameter")
    func tvSeriesDetailsDroppingOneForwardsTheRest() async throws {
        _ = try await service.tvSeriesDetails(
            forTVSeries: 1399,
            startDate: Date(timeIntervalSince1970: 1_000_000),
            endDate: Date(timeIntervalSince1970: 2_000_000)
        )
        var call = try #require(service.tvSeriesDetailsCalls.last)
        #expect(call.id == 1399)
        #expect(call.startDate == Date(timeIntervalSince1970: 1_000_000))
        #expect(call.endDate == Date(timeIntervalSince1970: 2_000_000))
        #expect(call.page == nil)

        _ = try await service.tvSeriesDetails(
            forTVSeries: 1399,
            startDate: Date(timeIntervalSince1970: 1_000_000),
            page: 3
        )
        call = try #require(service.tvSeriesDetailsCalls.last)
        #expect(call.id == 1399)
        #expect(call.startDate == Date(timeIntervalSince1970: 1_000_000))
        #expect(call.endDate == nil)
        #expect(call.page == 3)

        _ = try await service.tvSeriesDetails(
            forTVSeries: 1399,
            endDate: Date(timeIntervalSince1970: 2_000_000),
            page: 3
        )
        call = try #require(service.tvSeriesDetailsCalls.last)
        #expect(call.id == 1399)
        #expect(call.startDate == nil)
        #expect(call.endDate == Date(timeIntervalSince1970: 2_000_000))
        #expect(call.page == 3)

        #expect(service.tvSeriesDetailsCalls.count == 3)
    }

    @Test("tvSeriesDetails(forTVSeries:startDate:endDate:page:) dropping two parameters")
    func tvSeriesDetailsDroppingTwoForwardsTheRest() async throws {
        _ = try await service.tvSeriesDetails(forTVSeries: 1399, startDate: Date(timeIntervalSince1970: 1_000_000))
        var call = try #require(service.tvSeriesDetailsCalls.last)
        #expect(call.id == 1399)
        #expect(call.startDate == Date(timeIntervalSince1970: 1_000_000))
        #expect(call.endDate == nil)
        #expect(call.page == nil)

        _ = try await service.tvSeriesDetails(forTVSeries: 1399, endDate: Date(timeIntervalSince1970: 2_000_000))
        call = try #require(service.tvSeriesDetailsCalls.last)
        #expect(call.id == 1399)
        #expect(call.startDate == nil)
        #expect(call.endDate == Date(timeIntervalSince1970: 2_000_000))
        #expect(call.page == nil)

        _ = try await service.tvSeriesDetails(forTVSeries: 1399, page: 3)
        call = try #require(service.tvSeriesDetailsCalls.last)
        #expect(call.id == 1399)
        #expect(call.startDate == nil)
        #expect(call.endDate == nil)
        #expect(call.page == 3)

        #expect(service.tvSeriesDetailsCalls.count == 3)
    }

    @Test("tvSeriesDetails(forTVSeries:startDate:endDate:page:) dropping three parameters")
    func tvSeriesDetailsDroppingThreeForwardsTheRest() async throws {
        _ = try await service.tvSeriesDetails(forTVSeries: 1399)
        let call = try #require(service.tvSeriesDetailsCalls.last)
        #expect(call.id == 1399)
        #expect(call.startDate == nil)
        #expect(call.endDate == nil)
        #expect(call.page == nil)

        #expect(service.tvSeriesDetailsCalls.count == 1)
    }

}

// swiftlint:enable type_body_length
