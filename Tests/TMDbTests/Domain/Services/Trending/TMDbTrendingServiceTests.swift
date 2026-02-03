//
//  TMDbTrendingServiceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .trending))
struct TMDbTrendingServiceTests {

    var service: TMDbTrendingService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbTrendingService(apiClient: apiClient)
    }

    @Test("movies with default parameter values returns movies")
    func moviesWithDefaultParameterValuesReturnsMovies() async throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TrendingMoviesRequest(
            timeWindow: timeWindow, page: nil, language: nil
        )

        let result = try await (service as TrendingService).movies(inTimeWindow: timeWindow)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TrendingMoviesRequest == expectedRequest)
    }

    @Test("movies with page and language returns movies")
    func moviesWithPageAndLanguageReturnsMovies() async throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let page = 2
        let language = "en"
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TrendingMoviesRequest(
            timeWindow: timeWindow, page: page, language: language
        )

        let result = try await service.movies(
            inTimeWindow: timeWindow, page: page, language: language
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TrendingMoviesRequest == expectedRequest)
    }

    @Test("movies when errors throws error")
    func moviesWhenErrorsThrowsError() async throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.movies(inTimeWindow: timeWindow)
        }
    }

    @Test("tvSeries with default parameter values returns tv series")
    func tvSeriesWithDefaultParameterValuesReturnsTVSeries() async throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TrendingTVSeriesRequest(
            timeWindow: timeWindow, page: nil, language: nil
        )

        let result = try await (service as TrendingService).tvSeries(inTimeWindow: timeWindow)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TrendingTVSeriesRequest == expectedRequest)
    }

    @Test("tvSeries with page and language returns TV series")
    func tvSeriesWithPageAndLanguageReturnsTVSeries() async throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let page = 2
        let language = "en"
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TrendingTVSeriesRequest(
            timeWindow: timeWindow, page: page, language: language
        )

        let result = try await service.tvSeries(
            inTimeWindow: timeWindow, page: page, language: language
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TrendingTVSeriesRequest == expectedRequest)
    }

    @Test("tvSeries when errors throws error")
    func tvSeriesWhenErrorsThrowsError() async throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.tvSeries(inTimeWindow: timeWindow)
        }
    }

    @Test("people with default parameter values returns people")
    func peopleWithDefaultParameterValuesReturnsPeople() async throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = PersonPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TrendingPeopleRequest(
            timeWindow: timeWindow, page: nil, language: nil
        )

        let result = try await (service as TrendingService).people(inTimeWindow: timeWindow)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TrendingPeopleRequest == expectedRequest)
    }

    @Test("people with page and language returns people")
    func peopleWithPageAndLanguageReturnsPeople() async throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let page = 2
        let language = "en"
        let expectedResult = PersonPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TrendingPeopleRequest(
            timeWindow: timeWindow, page: page, language: language
        )

        let result = try await service.people(
            inTimeWindow: timeWindow, page: page, language: language
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TrendingPeopleRequest == expectedRequest)
    }

    @Test("people when errors throws error")
    func peopleWhenErrorsThrowsError() async throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.people(inTimeWindow: timeWindow)
        }
    }

}
