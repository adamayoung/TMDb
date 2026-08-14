//
//  SearchServiceConvenienceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

// swiftlint:disable type_body_length

import Foundation
import Testing
import TMDb
import TMDbTesting

///
/// Pins the zero-defaulted-argument conveniences on ``SearchService``.
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
@Suite(.tags(.testingSupport, .mocks, .search))
struct SearchServiceConvenienceTests {

    var service: MockSearchService

    init() {
        self.service = MockSearchService()
    }

    @Test("searchCompanies(query:) forwards a nil page to the requirement")
    func searchCompaniesForwardsNilPage() async throws {
        _ = try await service.searchCompanies(query: "pixar")

        #expect(service.searchCompaniesCalls.count == 1)
        let call = try #require(service.searchCompaniesCalls.first)
        #expect(call.page == nil)
        #expect(call.query == "pixar")
    }

    @Test("searchKeywords(query:) forwards a nil page to the requirement")
    func searchKeywordsForwardsNilPage() async throws {
        _ = try await service.searchKeywords(query: "space")

        #expect(service.searchKeywordsCalls.count == 1)
        let call = try #require(service.searchKeywordsCalls.first)
        #expect(call.page == nil)
        #expect(call.query == "space")
    }

    @Test("searchAll(query:filter:page:language:) dropping one parameter")
    func searchAllDroppingOneForwardsTheRest() async throws {
        _ = try await service.searchAll(query: "Fight Club", filter: AllMediaSearchFilter(includeAdult: true), page: 3)
        var call = try #require(service.searchAllCalls.last)
        #expect(call.query == "Fight Club")
        #expect(call.filter?.includeAdult == true)
        #expect(call.page == 3)
        #expect(call.language == nil)

        _ = try await service.searchAll(
            query: "Fight Club",
            filter: AllMediaSearchFilter(includeAdult: true),
            language: "en-GB"
        )
        call = try #require(service.searchAllCalls.last)
        #expect(call.query == "Fight Club")
        #expect(call.filter?.includeAdult == true)
        #expect(call.page == nil)
        #expect(call.language == "en-GB")

        _ = try await service.searchAll(query: "Fight Club", page: 3, language: "en-GB")
        call = try #require(service.searchAllCalls.last)
        #expect(call.query == "Fight Club")
        #expect(call.filter == nil)
        #expect(call.page == 3)
        #expect(call.language == "en-GB")

        #expect(service.searchAllCalls.count == 3)
    }

    @Test("searchAll(query:filter:page:language:) dropping two parameters")
    func searchAllDroppingTwoForwardsTheRest() async throws {
        _ = try await service.searchAll(query: "Fight Club", filter: AllMediaSearchFilter(includeAdult: true))
        var call = try #require(service.searchAllCalls.last)
        #expect(call.query == "Fight Club")
        #expect(call.filter?.includeAdult == true)
        #expect(call.page == nil)
        #expect(call.language == nil)

        _ = try await service.searchAll(query: "Fight Club", page: 3)
        call = try #require(service.searchAllCalls.last)
        #expect(call.query == "Fight Club")
        #expect(call.filter == nil)
        #expect(call.page == 3)
        #expect(call.language == nil)

        _ = try await service.searchAll(query: "Fight Club", language: "en-GB")
        call = try #require(service.searchAllCalls.last)
        #expect(call.query == "Fight Club")
        #expect(call.filter == nil)
        #expect(call.page == nil)
        #expect(call.language == "en-GB")

        #expect(service.searchAllCalls.count == 3)
    }

    @Test("searchAll(query:filter:page:language:) dropping three parameters")
    func searchAllDroppingThreeForwardsTheRest() async throws {
        _ = try await service.searchAll(query: "Fight Club")
        let call = try #require(service.searchAllCalls.last)
        #expect(call.query == "Fight Club")
        #expect(call.filter == nil)
        #expect(call.page == nil)
        #expect(call.language == nil)

        #expect(service.searchAllCalls.count == 1)
    }

    @Test("searchCollections(query:page:language:) conveniences forward the parameters they omit")
    func searchCollectionsOverloadsForwardOmittedParameters() async throws {
        _ = try await service.searchCollections(query: "Fight Club", page: 3)
        var call = try #require(service.searchCollectionsCalls.last)
        #expect(call.query == "Fight Club")
        #expect(call.page == 3)
        #expect(call.language == nil)

        _ = try await service.searchCollections(query: "Fight Club", language: "en-GB")
        call = try #require(service.searchCollectionsCalls.last)
        #expect(call.query == "Fight Club")
        #expect(call.page == nil)
        #expect(call.language == "en-GB")

        _ = try await service.searchCollections(query: "Fight Club")
        call = try #require(service.searchCollectionsCalls.last)
        #expect(call.query == "Fight Club")
        #expect(call.page == nil)
        #expect(call.language == nil)

        #expect(service.searchCollectionsCalls.count == 3)
    }

    @Test("searchMovies(query:filter:page:language:) dropping one parameter")
    func searchMoviesDroppingOneForwardsTheRest() async throws {
        _ = try await service.searchMovies(query: "Fight Club", filter: MovieSearchFilter(year: 1999), page: 3)
        var call = try #require(service.searchMoviesCalls.last)
        #expect(call.query == "Fight Club")
        #expect(call.filter?.year == 1999)
        #expect(call.page == 3)
        #expect(call.language == nil)

        _ = try await service.searchMovies(
            query: "Fight Club",
            filter: MovieSearchFilter(year: 1999),
            language: "en-GB"
        )
        call = try #require(service.searchMoviesCalls.last)
        #expect(call.query == "Fight Club")
        #expect(call.filter?.year == 1999)
        #expect(call.page == nil)
        #expect(call.language == "en-GB")

        _ = try await service.searchMovies(query: "Fight Club", page: 3, language: "en-GB")
        call = try #require(service.searchMoviesCalls.last)
        #expect(call.query == "Fight Club")
        #expect(call.filter == nil)
        #expect(call.page == 3)
        #expect(call.language == "en-GB")

        #expect(service.searchMoviesCalls.count == 3)
    }

    @Test("searchMovies(query:filter:page:language:) dropping two parameters")
    func searchMoviesDroppingTwoForwardsTheRest() async throws {
        _ = try await service.searchMovies(query: "Fight Club", filter: MovieSearchFilter(year: 1999))
        var call = try #require(service.searchMoviesCalls.last)
        #expect(call.query == "Fight Club")
        #expect(call.filter?.year == 1999)
        #expect(call.page == nil)
        #expect(call.language == nil)

        _ = try await service.searchMovies(query: "Fight Club", page: 3)
        call = try #require(service.searchMoviesCalls.last)
        #expect(call.query == "Fight Club")
        #expect(call.filter == nil)
        #expect(call.page == 3)
        #expect(call.language == nil)

        _ = try await service.searchMovies(query: "Fight Club", language: "en-GB")
        call = try #require(service.searchMoviesCalls.last)
        #expect(call.query == "Fight Club")
        #expect(call.filter == nil)
        #expect(call.page == nil)
        #expect(call.language == "en-GB")

        #expect(service.searchMoviesCalls.count == 3)
    }

    @Test("searchMovies(query:filter:page:language:) dropping three parameters")
    func searchMoviesDroppingThreeForwardsTheRest() async throws {
        _ = try await service.searchMovies(query: "Fight Club")
        let call = try #require(service.searchMoviesCalls.last)
        #expect(call.query == "Fight Club")
        #expect(call.filter == nil)
        #expect(call.page == nil)
        #expect(call.language == nil)

        #expect(service.searchMoviesCalls.count == 1)
    }

    @Test("searchPeople(query:filter:page:language:) dropping one parameter")
    func searchPeopleDroppingOneForwardsTheRest() async throws {
        _ = try await service.searchPeople(query: "Fight Club", filter: PersonSearchFilter(includeAdult: true), page: 3)
        var call = try #require(service.searchPeopleCalls.last)
        #expect(call.query == "Fight Club")
        #expect(call.filter?.includeAdult == true)
        #expect(call.page == 3)
        #expect(call.language == nil)

        _ = try await service.searchPeople(
            query: "Fight Club",
            filter: PersonSearchFilter(includeAdult: true),
            language: "en-GB"
        )
        call = try #require(service.searchPeopleCalls.last)
        #expect(call.query == "Fight Club")
        #expect(call.filter?.includeAdult == true)
        #expect(call.page == nil)
        #expect(call.language == "en-GB")

        _ = try await service.searchPeople(query: "Fight Club", page: 3, language: "en-GB")
        call = try #require(service.searchPeopleCalls.last)
        #expect(call.query == "Fight Club")
        #expect(call.filter == nil)
        #expect(call.page == 3)
        #expect(call.language == "en-GB")

        #expect(service.searchPeopleCalls.count == 3)
    }

    @Test("searchPeople(query:filter:page:language:) dropping two parameters")
    func searchPeopleDroppingTwoForwardsTheRest() async throws {
        _ = try await service.searchPeople(query: "Fight Club", filter: PersonSearchFilter(includeAdult: true))
        var call = try #require(service.searchPeopleCalls.last)
        #expect(call.query == "Fight Club")
        #expect(call.filter?.includeAdult == true)
        #expect(call.page == nil)
        #expect(call.language == nil)

        _ = try await service.searchPeople(query: "Fight Club", page: 3)
        call = try #require(service.searchPeopleCalls.last)
        #expect(call.query == "Fight Club")
        #expect(call.filter == nil)
        #expect(call.page == 3)
        #expect(call.language == nil)

        _ = try await service.searchPeople(query: "Fight Club", language: "en-GB")
        call = try #require(service.searchPeopleCalls.last)
        #expect(call.query == "Fight Club")
        #expect(call.filter == nil)
        #expect(call.page == nil)
        #expect(call.language == "en-GB")

        #expect(service.searchPeopleCalls.count == 3)
    }

    @Test("searchPeople(query:filter:page:language:) dropping three parameters")
    func searchPeopleDroppingThreeForwardsTheRest() async throws {
        _ = try await service.searchPeople(query: "Fight Club")
        let call = try #require(service.searchPeopleCalls.last)
        #expect(call.query == "Fight Club")
        #expect(call.filter == nil)
        #expect(call.page == nil)
        #expect(call.language == nil)

        #expect(service.searchPeopleCalls.count == 1)
    }

    @Test("searchTVSeries(query:filter:page:language:) dropping one parameter")
    func searchTVSeriesDroppingOneForwardsTheRest() async throws {
        _ = try await service.searchTVSeries(
            query: "Fight Club",
            filter: TVSeriesSearchFilter(firstAirDateYear: nil, year: 1999, includeAdult: nil),
            page: 3
        )
        var call = try #require(service.searchTVSeriesCalls.last)
        #expect(call.query == "Fight Club")
        #expect(call.filter?.year == 1999)
        #expect(call.page == 3)
        #expect(call.language == nil)

        _ = try await service.searchTVSeries(
            query: "Fight Club",
            filter: TVSeriesSearchFilter(firstAirDateYear: nil, year: 1999, includeAdult: nil),
            language: "en-GB"
        )
        call = try #require(service.searchTVSeriesCalls.last)
        #expect(call.query == "Fight Club")
        #expect(call.filter?.year == 1999)
        #expect(call.page == nil)
        #expect(call.language == "en-GB")

        _ = try await service.searchTVSeries(query: "Fight Club", page: 3, language: "en-GB")
        call = try #require(service.searchTVSeriesCalls.last)
        #expect(call.query == "Fight Club")
        #expect(call.filter == nil)
        #expect(call.page == 3)
        #expect(call.language == "en-GB")

        #expect(service.searchTVSeriesCalls.count == 3)
    }

    @Test("searchTVSeries(query:filter:page:language:) dropping two parameters")
    func searchTVSeriesDroppingTwoForwardsTheRest() async throws {
        _ = try await service.searchTVSeries(
            query: "Fight Club",
            filter: TVSeriesSearchFilter(firstAirDateYear: nil, year: 1999, includeAdult: nil)
        )
        var call = try #require(service.searchTVSeriesCalls.last)
        #expect(call.query == "Fight Club")
        #expect(call.filter?.year == 1999)
        #expect(call.page == nil)
        #expect(call.language == nil)

        _ = try await service.searchTVSeries(query: "Fight Club", page: 3)
        call = try #require(service.searchTVSeriesCalls.last)
        #expect(call.query == "Fight Club")
        #expect(call.filter == nil)
        #expect(call.page == 3)
        #expect(call.language == nil)

        _ = try await service.searchTVSeries(query: "Fight Club", language: "en-GB")
        call = try #require(service.searchTVSeriesCalls.last)
        #expect(call.query == "Fight Club")
        #expect(call.filter == nil)
        #expect(call.page == nil)
        #expect(call.language == "en-GB")

        #expect(service.searchTVSeriesCalls.count == 3)
    }

    @Test("searchTVSeries(query:filter:page:language:) dropping three parameters")
    func searchTVSeriesDroppingThreeForwardsTheRest() async throws {
        _ = try await service.searchTVSeries(query: "Fight Club")
        let call = try #require(service.searchTVSeriesCalls.last)
        #expect(call.query == "Fight Club")
        #expect(call.filter == nil)
        #expect(call.page == nil)
        #expect(call.language == nil)

        #expect(service.searchTVSeriesCalls.count == 1)
    }

}

// swiftlint:enable type_body_length
