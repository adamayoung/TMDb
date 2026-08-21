//
//  SearchPlanExecutorDateTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb
@testable import TMDbIntelligence

///
/// The executor's two calendars, and why they differ.
///
/// Instant maths — `startOfYear`, `endOfYear`, `year(of:)` — runs at **GMT**,
/// because the dates it builds are formatted into `yyyy-MM-dd` discover query
/// parameters by the GMT-pinned `DateFormatter.theMovieDatabase`, and the dates
/// it reads a year out of were decoded at GMT midnight.
///
/// `currentYear()` stays on the **local** calendar, because "what year is it"
/// is a question about the user's wall clock rather than about TMDb's data.
///
/// Every assertion here that reads `== <GMT value>` passes trivially on a UTC
/// runner; the `unit-test-timezones` CI matrix is what makes them meaningful.
///
@Suite("SearchPlanExecutor dates")
struct SearchPlanExecutorDateTests {

    let dataSource: MockNaturalLanguageSearchDataSource
    let executor: SearchPlanExecutor

    init() {
        let dataSource = MockNaturalLanguageSearchDataSource()
        self.dataSource = dataSource
        // Pin "now" to 2026-06-03 so relative-date tests are deterministic.
        let now = NLSFixture.date(year: 2026)
        self.executor = SearchPlanExecutor(dataSource: dataSource, resultLimit: 20, now: { now })
    }

    /// `Pacific/Auckland` is the zone that catches a regression here: an
    /// ambient-zone calendar puts `startOfYear(2020)` at 2019-12-31T11:00:00Z,
    /// which the GMT formatter then renders as the wrong year entirely.
    @Test("year bounds are GMT midnight instants")
    func yearBoundsAreGMTMidnightInstants() throws {
        let start = try #require(executor.startOfYear(2020))
        let end = try #require(executor.endOfYear(2024))

        #expect(start == Date(timeIntervalSince1970: 1_577_836_800))
        #expect(end == Date(timeIntervalSince1970: 1_735_603_200))
    }

    @Test("the current year follows the local calendar")
    func currentYearFollowsLocalCalendar() {
        #expect(executor.yearBounds(for: .thisYear) == (from: 2026, to: 2026))
        #expect(executor.yearBounds(for: .recent) == (from: 2025, to: 2026))
    }

    /// The user-visible half of the calendar pin: `filterByYear` drops anything
    /// outside the requested bounds, so with an ambient-zone calendar a movie
    /// released 2024-01-01 (decoded as 2024-01-01T00:00:00Z) reads as *2023*
    /// west of Greenwich and vanishes from a "2024 movies" search. Mid-year
    /// fixtures cannot catch that; this one is on the boundary.
    @Test("a 1 January release stays in its own year when filtered")
    func januaryFirstReleaseStaysInItsOwnYearWhenFiltered() async throws {
        // Built directly rather than via `NLSFixture.movie(year:)`, which pins
        // 1 June — mid-year dates cannot expose a zone-dependent year read.
        let newYearsDay2024 = Date(timeIntervalSince1970: 1_704_067_200)
        dataSource.discoverMoviesResult = [
            MovieListItem(
                id: 1, title: "Movie", originalTitle: "Movie", originalLanguage: "en",
                overview: "", genreIDs: [], releaseDate: newYearsDay2024
            )
        ]

        let result = try await executor.execute(
            SearchPlan(intent: .browse, date: .exactYear(2024))
        )

        #expect(result.movies.map(\.id) == [1])
    }

    /// The deliberate carve-out, tested where it actually differs.
    ///
    /// Mid-year the local/GMT distinction is invisible, so this pins a `now`
    /// that straddles a year boundary: 2026-01-01T04:00:00Z is still 2025
    /// anywhere west of UTC-4, and already 2026 at GMT and east of it.
    ///
    /// The expectation is derived from the local calendar rather than
    /// hard-coded, so it holds under every `TZ` the matrix runs — and fails the
    /// moment someone "harmonises" `currentYear()` onto `calendar()`, which is
    /// the cleanup this carve-out exists to survive.
    @Test("the current year follows the local calendar across a year boundary")
    func currentYearFollowsLocalCalendarAcrossBoundary() {
        let boundary = Date(timeIntervalSince1970: 1_767_240_000) // 2026-01-01T04:00:00Z
        let executor = SearchPlanExecutor(
            dataSource: MockNaturalLanguageSearchDataSource(),
            resultLimit: 20,
            now: { boundary }
        )

        var local = Calendar(identifier: .gregorian)
        local.timeZone = .current
        let expectedYear = local.component(.year, from: boundary)

        #expect(executor.yearBounds(for: .thisYear) == (from: expectedYear, to: expectedYear))
    }

}
