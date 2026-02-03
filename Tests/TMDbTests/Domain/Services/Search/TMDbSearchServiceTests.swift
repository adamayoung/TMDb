//
//  TMDbSearchServiceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .search))
struct TMDbSearchServiceTests {

    var service: TMDbSearchService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbSearchService(apiClient: apiClient)
    }

    @Test("searchAll with default parameter values returns media")
    func searchAllWithDefaultParameterValuesReturnsMedia() async throws {
        let query = "media search"
        let expectedResult = MediaPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MultiSearchRequest(
            query: query, includeAdult: nil, page: nil, language: nil
        )

        let result = try await (service as SearchService).searchAll(query: query)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? MultiSearchRequest == expectedRequest)
    }

    @Test("searchAll with filter, page and language returns media")
    func searchAllWithFilterAndPageAndLanguageReturnsMedia() async throws {
        let query = "media search"
        let includeAdult = true
        let page = 2
        let language = "en"
        let expectedResult = MediaPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MultiSearchRequest(
            query: query,
            includeAdult: includeAdult,
            page: page,
            language: language
        )

        let filter = AllMediaSearchFilter(includeAdult: includeAdult)
        let result = try await service.searchAll(
            query: query, filter: filter, page: page, language: language
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? MultiSearchRequest == expectedRequest)
    }

    @Test("searchAll when errors throws error")
    func searchAllWhenErrorsThrowsError() async throws {
        let query = "media search"
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.searchAll(query: query)
        }
    }

    @Test("searchMovies with default parameter values returns movies")
    func searchMoviesWithDefaultParameterValuesReturnsMovies() async throws {
        let query = "search movies"
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieSearchRequest(
            query: query,
            primaryReleaseYear: nil,
            includeAdult: nil,
            page: nil,
            language: nil
        )

        let result = try await (service as SearchService).searchMovies(query: query)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? MovieSearchRequest == expectedRequest)
    }

    @Test("searchMovies with filter, page and language returns movies")
    func searchMoviesWithFilterAndPageAndLanguageReturnsMovies() async throws {
        let query = "search movies"
        let primaryReleaseYear = 2024
        let country = "GB"
        let includeAdult = true
        let page = 3
        let language = "en"
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieSearchRequest(
            query: query,
            primaryReleaseYear: primaryReleaseYear,
            country: country,
            includeAdult: includeAdult,
            page: page,
            language: language
        )

        let filter = MovieSearchFilter(
            primaryReleaseYear: primaryReleaseYear,
            country: country,
            includeAdult: includeAdult
        )
        let result = try await service.searchMovies(
            query: query, filter: filter, page: page, language: language
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? MovieSearchRequest == expectedRequest)
    }

    @Test("searchMovies when errors throws error")
    func searchMoviesWhenErrorsThrowsError() async throws {
        let query = "search movies"
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.searchMovies(query: query)
        }
    }

    @Test("searchTVSeries with default parameter values returns TV series")
    func searchTVSeriesWithDefaultParameterValuesReturnsTVSeries() async throws {
        let query = "search tv series"
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesSearchRequest(
            query: query,
            firstAirDateYear: nil,
            year: nil,
            includeAdult: nil,
            page: nil,
            language: nil
        )

        let result = try await (service as SearchService).searchTVSeries(query: query)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeriesSearchRequest == expectedRequest)
    }

    @Test("searchTVSeries with filter, page and language returns TV series")
    func searchTVSeriesWithFilterAndPageAndLanguageReturnsTVSeries() async throws {
        let query = "search tv series"
        let firstAirDateYear = 2023
        let year = 2024
        let includeAdult = true
        let page = 3
        let language = "en"
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesSearchRequest(
            query: query,
            firstAirDateYear: firstAirDateYear,
            year: year,
            includeAdult: includeAdult,
            page: page,
            language: language
        )

        let filter = TVSeriesSearchFilter(
            firstAirDateYear: firstAirDateYear, year: year, includeAdult: includeAdult
        )
        let result = try await service.searchTVSeries(
            query: query, filter: filter, page: page, language: language
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeriesSearchRequest == expectedRequest)
    }

    @Test("searchTVSeries when errors throws error")
    func searchTVSeriesWhenErrorsThrowsError() async throws {
        let query = "search tv series"
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.searchTVSeries(query: query)
        }
    }

    @Test("searchPeople with default parameter values returns people")
    func searchPeopleWithDefaultParameterValuesReturnsPeople() async throws {
        let query = "search people"
        let expectedResult = PersonPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PersonSearchRequest(
            query: query, includeAdult: nil, page: nil, language: nil
        )

        let result = try await (service as SearchService).searchPeople(query: query)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? PersonSearchRequest == expectedRequest)
    }

    @Test("searchPeople with filter, page and language returns people")
    func searchPeopleWithFilterAndPageAndLanguageReturnsPeople() async throws {
        let query = "search people"
        let includeAdult = true
        let page = 2
        let language = "en"
        let expectedResult = PersonPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PersonSearchRequest(
            query: query,
            includeAdult: includeAdult,
            page: page,
            language: language
        )

        let filter = PersonSearchFilter(includeAdult: includeAdult)
        let result = try await service.searchPeople(
            query: query, filter: filter, page: page, language: language
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? PersonSearchRequest == expectedRequest)
    }

    @Test("searchPeople when errors throws error")
    func searchPeopleWhenErrorsThrowsError() async throws {
        let query = "search people"
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.searchPeople(query: query)
        }
    }

}
