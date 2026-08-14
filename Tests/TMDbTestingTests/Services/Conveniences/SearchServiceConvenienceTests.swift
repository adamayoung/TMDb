//
//  SearchServiceConvenienceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
import TMDb
import TMDbTesting

///
/// Pins the zero-defaulted-argument conveniences on ``SearchService``.
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

    @Test("every searchAll(query:filter:page:language:) overload forwards the parameters it omits")
    func searchAllOverloadsForwardOmittedParameters() async throws {
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

        _ = try await service.searchAll(query: "Fight Club", filter: AllMediaSearchFilter(includeAdult: true))
        call = try #require(service.searchAllCalls.last)
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

        _ = try await service.searchAll(query: "Fight Club")
        call = try #require(service.searchAllCalls.last)
        #expect(call.query == "Fight Club")
        #expect(call.filter == nil)
        #expect(call.page == nil)
        #expect(call.language == nil)

        #expect(service.searchAllCalls.count == 7)
    }

    @Test("every searchCollections(query:page:language:) overload forwards the parameters it omits")
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

    @Test("every searchMovies(query:filter:page:language:) overload forwards the parameters it omits")
    func searchMoviesOverloadsForwardOmittedParameters() async throws {
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

        _ = try await service.searchMovies(query: "Fight Club", filter: MovieSearchFilter(year: 1999))
        call = try #require(service.searchMoviesCalls.last)
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

        _ = try await service.searchMovies(query: "Fight Club")
        call = try #require(service.searchMoviesCalls.last)
        #expect(call.query == "Fight Club")
        #expect(call.filter == nil)
        #expect(call.page == nil)
        #expect(call.language == nil)

        #expect(service.searchMoviesCalls.count == 7)
    }

    @Test("every searchPeople(query:filter:page:language:) overload forwards the parameters it omits")
    func searchPeopleOverloadsForwardOmittedParameters() async throws {
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

        _ = try await service.searchPeople(query: "Fight Club", filter: PersonSearchFilter(includeAdult: true))
        call = try #require(service.searchPeopleCalls.last)
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

        _ = try await service.searchPeople(query: "Fight Club")
        call = try #require(service.searchPeopleCalls.last)
        #expect(call.query == "Fight Club")
        #expect(call.filter == nil)
        #expect(call.page == nil)
        #expect(call.language == nil)

        #expect(service.searchPeopleCalls.count == 7)
    }

    @Test("every searchTVSeries(query:filter:page:language:) overload forwards the parameters it omits")
    func searchTVSeriesOverloadsForwardOmittedParameters() async throws {
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

        _ = try await service.searchTVSeries(
            query: "Fight Club",
            filter: TVSeriesSearchFilter(firstAirDateYear: nil, year: 1999, includeAdult: nil)
        )
        call = try #require(service.searchTVSeriesCalls.last)
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

        _ = try await service.searchTVSeries(query: "Fight Club")
        call = try #require(service.searchTVSeriesCalls.last)
        #expect(call.query == "Fight Club")
        #expect(call.filter == nil)
        #expect(call.page == nil)
        #expect(call.language == nil)

        #expect(service.searchTVSeriesCalls.count == 7)
    }

}
