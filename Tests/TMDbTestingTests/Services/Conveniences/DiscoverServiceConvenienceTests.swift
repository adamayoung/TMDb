//
//  DiscoverServiceConvenienceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
import TMDb
import TMDbTesting

///
/// Pins the zero-defaulted-argument conveniences on ``DiscoverService``.
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
@Suite(.tags(.testingSupport, .mocks, .discover))
struct DiscoverServiceConvenienceTests {

    var service: MockDiscoverService

    init() {
        self.service = MockDiscoverService()
    }

    @Test("movies(filter:sortedBy:page:language:) dropping one parameter")
    func moviesDroppingOneForwardsTheRest() async throws {
        _ = try await service.movies(
            filter: DiscoverMovieFilter(people: [500]),
            sortedBy: .originalTitle(descending: true),
            page: 3
        )
        var call = try #require(service.moviesCalls.last)
        #expect(call.filter?.people == [500])
        #expect(call.sortedBy == .originalTitle(descending: true))
        #expect(call.page == 3)
        #expect(call.language == nil)

        _ = try await service.movies(
            filter: DiscoverMovieFilter(people: [500]),
            sortedBy: .originalTitle(descending: true),
            language: "en-GB"
        )
        call = try #require(service.moviesCalls.last)
        #expect(call.filter?.people == [500])
        #expect(call.sortedBy == .originalTitle(descending: true))
        #expect(call.page == nil)
        #expect(call.language == "en-GB")

        _ = try await service.movies(filter: DiscoverMovieFilter(people: [500]), page: 3, language: "en-GB")
        call = try #require(service.moviesCalls.last)
        #expect(call.filter?.people == [500])
        #expect(call.sortedBy == nil)
        #expect(call.page == 3)
        #expect(call.language == "en-GB")

        _ = try await service.movies(sortedBy: .originalTitle(descending: true), page: 3, language: "en-GB")
        call = try #require(service.moviesCalls.last)
        #expect(call.filter == nil)
        #expect(call.sortedBy == .originalTitle(descending: true))
        #expect(call.page == 3)
        #expect(call.language == "en-GB")

        #expect(service.moviesCalls.count == 4)
    }

    @Test("movies(filter:sortedBy:page:language:) dropping two parameters")
    func moviesDroppingTwoForwardsTheRest() async throws {
        _ = try await service.movies(
            filter: DiscoverMovieFilter(people: [500]),
            sortedBy: .originalTitle(descending: true)
        )
        var call = try #require(service.moviesCalls.last)
        #expect(call.filter?.people == [500])
        #expect(call.sortedBy == .originalTitle(descending: true))
        #expect(call.page == nil)
        #expect(call.language == nil)

        _ = try await service.movies(filter: DiscoverMovieFilter(people: [500]), page: 3)
        call = try #require(service.moviesCalls.last)
        #expect(call.filter?.people == [500])
        #expect(call.sortedBy == nil)
        #expect(call.page == 3)
        #expect(call.language == nil)

        _ = try await service.movies(filter: DiscoverMovieFilter(people: [500]), language: "en-GB")
        call = try #require(service.moviesCalls.last)
        #expect(call.filter?.people == [500])
        #expect(call.sortedBy == nil)
        #expect(call.page == nil)
        #expect(call.language == "en-GB")

        _ = try await service.movies(sortedBy: .originalTitle(descending: true), page: 3)
        call = try #require(service.moviesCalls.last)
        #expect(call.filter == nil)
        #expect(call.sortedBy == .originalTitle(descending: true))
        #expect(call.page == 3)
        #expect(call.language == nil)

        _ = try await service.movies(sortedBy: .originalTitle(descending: true), language: "en-GB")
        call = try #require(service.moviesCalls.last)
        #expect(call.filter == nil)
        #expect(call.sortedBy == .originalTitle(descending: true))
        #expect(call.page == nil)
        #expect(call.language == "en-GB")

        _ = try await service.movies(page: 3, language: "en-GB")
        call = try #require(service.moviesCalls.last)
        #expect(call.filter == nil)
        #expect(call.sortedBy == nil)
        #expect(call.page == 3)
        #expect(call.language == "en-GB")

        #expect(service.moviesCalls.count == 6)
    }

    @Test("movies(filter:sortedBy:page:language:) dropping three parameters")
    func moviesDroppingThreeForwardsTheRest() async throws {
        _ = try await service.movies(filter: DiscoverMovieFilter(people: [500]))
        var call = try #require(service.moviesCalls.last)
        #expect(call.filter?.people == [500])
        #expect(call.sortedBy == nil)
        #expect(call.page == nil)
        #expect(call.language == nil)

        _ = try await service.movies(sortedBy: .originalTitle(descending: true))
        call = try #require(service.moviesCalls.last)
        #expect(call.filter == nil)
        #expect(call.sortedBy == .originalTitle(descending: true))
        #expect(call.page == nil)
        #expect(call.language == nil)

        _ = try await service.movies(page: 3)
        call = try #require(service.moviesCalls.last)
        #expect(call.filter == nil)
        #expect(call.sortedBy == nil)
        #expect(call.page == 3)
        #expect(call.language == nil)

        _ = try await service.movies(language: "en-GB")
        call = try #require(service.moviesCalls.last)
        #expect(call.filter == nil)
        #expect(call.sortedBy == nil)
        #expect(call.page == nil)
        #expect(call.language == "en-GB")

        #expect(service.moviesCalls.count == 4)
    }

    @Test("movies(filter:sortedBy:page:language:) dropping four parameters")
    func moviesDroppingFourForwardsTheRest() async throws {
        _ = try await service.movies()
        let call = try #require(service.moviesCalls.last)
        #expect(call.filter == nil)
        #expect(call.sortedBy == nil)
        #expect(call.page == nil)
        #expect(call.language == nil)

        #expect(service.moviesCalls.count == 1)
    }

    @Test("tvSeries(filter:sortedBy:page:language:) dropping one parameter")
    func tvSeriesDroppingOneForwardsTheRest() async throws {
        _ = try await service.tvSeries(
            filter: DiscoverTVSeriesFilter(firstAirDateYear: 1999),
            sortedBy: .firstAirDate(descending: true),
            page: 3
        )
        var call = try #require(service.tvSeriesCalls.last)
        #expect(call.filter?.firstAirDateYear == 1999)
        #expect(call.sortedBy == .firstAirDate(descending: true))
        #expect(call.page == 3)
        #expect(call.language == nil)

        _ = try await service.tvSeries(
            filter: DiscoverTVSeriesFilter(firstAirDateYear: 1999),
            sortedBy: .firstAirDate(descending: true),
            language: "en-GB"
        )
        call = try #require(service.tvSeriesCalls.last)
        #expect(call.filter?.firstAirDateYear == 1999)
        #expect(call.sortedBy == .firstAirDate(descending: true))
        #expect(call.page == nil)
        #expect(call.language == "en-GB")

        _ = try await service.tvSeries(
            filter: DiscoverTVSeriesFilter(firstAirDateYear: 1999),
            page: 3,
            language: "en-GB"
        )
        call = try #require(service.tvSeriesCalls.last)
        #expect(call.filter?.firstAirDateYear == 1999)
        #expect(call.sortedBy == nil)
        #expect(call.page == 3)
        #expect(call.language == "en-GB")

        _ = try await service.tvSeries(sortedBy: .firstAirDate(descending: true), page: 3, language: "en-GB")
        call = try #require(service.tvSeriesCalls.last)
        #expect(call.filter == nil)
        #expect(call.sortedBy == .firstAirDate(descending: true))
        #expect(call.page == 3)
        #expect(call.language == "en-GB")

        #expect(service.tvSeriesCalls.count == 4)
    }

    @Test("tvSeries(filter:sortedBy:page:language:) dropping two parameters")
    func tvSeriesDroppingTwoForwardsTheRest() async throws {
        _ = try await service.tvSeries(
            filter: DiscoverTVSeriesFilter(firstAirDateYear: 1999),
            sortedBy: .firstAirDate(descending: true)
        )
        var call = try #require(service.tvSeriesCalls.last)
        #expect(call.filter?.firstAirDateYear == 1999)
        #expect(call.sortedBy == .firstAirDate(descending: true))
        #expect(call.page == nil)
        #expect(call.language == nil)

        _ = try await service.tvSeries(filter: DiscoverTVSeriesFilter(firstAirDateYear: 1999), page: 3)
        call = try #require(service.tvSeriesCalls.last)
        #expect(call.filter?.firstAirDateYear == 1999)
        #expect(call.sortedBy == nil)
        #expect(call.page == 3)
        #expect(call.language == nil)

        _ = try await service.tvSeries(filter: DiscoverTVSeriesFilter(firstAirDateYear: 1999), language: "en-GB")
        call = try #require(service.tvSeriesCalls.last)
        #expect(call.filter?.firstAirDateYear == 1999)
        #expect(call.sortedBy == nil)
        #expect(call.page == nil)
        #expect(call.language == "en-GB")

        _ = try await service.tvSeries(sortedBy: .firstAirDate(descending: true), page: 3)
        call = try #require(service.tvSeriesCalls.last)
        #expect(call.filter == nil)
        #expect(call.sortedBy == .firstAirDate(descending: true))
        #expect(call.page == 3)
        #expect(call.language == nil)

        _ = try await service.tvSeries(sortedBy: .firstAirDate(descending: true), language: "en-GB")
        call = try #require(service.tvSeriesCalls.last)
        #expect(call.filter == nil)
        #expect(call.sortedBy == .firstAirDate(descending: true))
        #expect(call.page == nil)
        #expect(call.language == "en-GB")

        _ = try await service.tvSeries(page: 3, language: "en-GB")
        call = try #require(service.tvSeriesCalls.last)
        #expect(call.filter == nil)
        #expect(call.sortedBy == nil)
        #expect(call.page == 3)
        #expect(call.language == "en-GB")

        #expect(service.tvSeriesCalls.count == 6)
    }

    @Test("tvSeries(filter:sortedBy:page:language:) dropping three parameters")
    func tvSeriesDroppingThreeForwardsTheRest() async throws {
        _ = try await service.tvSeries(filter: DiscoverTVSeriesFilter(firstAirDateYear: 1999))
        var call = try #require(service.tvSeriesCalls.last)
        #expect(call.filter?.firstAirDateYear == 1999)
        #expect(call.sortedBy == nil)
        #expect(call.page == nil)
        #expect(call.language == nil)

        _ = try await service.tvSeries(sortedBy: .firstAirDate(descending: true))
        call = try #require(service.tvSeriesCalls.last)
        #expect(call.filter == nil)
        #expect(call.sortedBy == .firstAirDate(descending: true))
        #expect(call.page == nil)
        #expect(call.language == nil)

        _ = try await service.tvSeries(page: 3)
        call = try #require(service.tvSeriesCalls.last)
        #expect(call.filter == nil)
        #expect(call.sortedBy == nil)
        #expect(call.page == 3)
        #expect(call.language == nil)

        _ = try await service.tvSeries(language: "en-GB")
        call = try #require(service.tvSeriesCalls.last)
        #expect(call.filter == nil)
        #expect(call.sortedBy == nil)
        #expect(call.page == nil)
        #expect(call.language == "en-GB")

        #expect(service.tvSeriesCalls.count == 4)
    }

    @Test("tvSeries(filter:sortedBy:page:language:) dropping four parameters")
    func tvSeriesDroppingFourForwardsTheRest() async throws {
        _ = try await service.tvSeries()
        let call = try #require(service.tvSeriesCalls.last)
        #expect(call.filter == nil)
        #expect(call.sortedBy == nil)
        #expect(call.page == nil)
        #expect(call.language == nil)

        #expect(service.tvSeriesCalls.count == 1)
    }

}
