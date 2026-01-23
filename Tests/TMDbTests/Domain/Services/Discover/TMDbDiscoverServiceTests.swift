//
//  TMDbDiscoverServiceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.services, .configuration))
struct TMDbDiscoverServiceTests {

    var service: TMDbDiscoverService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbDiscoverService(apiClient: apiClient)
    }

    @Test("movies with default parameter values returns movies")
    func moviesWithDefaultParameterValuesReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = DiscoverMoviesRequest(
            filter: nil, sortedBy: nil, page: nil, language: nil
        )

        let result = try await (service as DiscoverService).movies()

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? DiscoverMoviesRequest == expectedRequest)
    }

    @Test("movies with filter, sort by, page and language returns movies")
    func moviesWithFilterAndSortByAndPageAndLanguageReturnsMovies() async throws {
        let filter = DiscoverMovieFilter(people: [4, 5, 6, 7, 8])
        let sortBy = MovieSort.originalTitle(descending: false)
        let expectedResult = MoviePageableList.mock()
        let page = expectedResult.page
        let language = "en"
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = DiscoverMoviesRequest(
            filter: filter, sortedBy: sortBy, page: page, language: language
        )

        let result = try await service.movies(
            filter: filter, sortedBy: sortBy, page: page, language: language
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? DiscoverMoviesRequest == expectedRequest)
    }

    @Test("movies when errors throws error")
    func moviesWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.movies()
        }
    }

    @Test("tvSeries with default parameter values returns TV series")
    func tvSeriesWithDefaultParameterValuesReturnsTVSeries() async throws {
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = DiscoverTVSeriesRequest(sortedBy: nil, page: nil, language: nil)

        let result = try await (service as DiscoverService).tvSeries()

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? DiscoverTVSeriesRequest == expectedRequest)
    }

    @Test("tvSeries with sort by, page and language returns TV series")
    func tvSeriesWithSortByAndPageAndLanguageReturnsTVSeries() async throws {
        let sortBy = TVSeriesSort.firstAirDate(descending: false)
        let expectedResult = TVSeriesPageableList.mock()
        let page = expectedResult.page
        let language = "en"
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = DiscoverTVSeriesRequest(
            sortedBy: sortBy, page: page, language: language
        )

        let result = try await service.tvSeries(sortedBy: sortBy, page: page, language: language)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? DiscoverTVSeriesRequest == expectedRequest)
    }

    @Test("tvSeries when errors throws error")
    func tvSeriesWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.tvSeries()
        }
    }

}
