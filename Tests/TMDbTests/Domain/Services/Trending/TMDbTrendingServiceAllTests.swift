//
//  TMDbTrendingServiceAllTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .trending))
struct TMDbTrendingServiceAllTests {

    var service: TMDbTrendingService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbTrendingService(apiClient: apiClient)
    }

    @Test("allTrending with default parameter values returns trending items")
    func allTrendingWithDefaultParameterValuesReturnsTrendingItems() async throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        let expectedResult = TrendingPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TrendingAllRequest(
            timeWindow: timeWindow, page: nil, language: nil
        )

        let result = try await (service as TrendingService).allTrending(
            inTimeWindow: timeWindow
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TrendingAllRequest == expectedRequest)
    }

    @Test("allTrending with page and language returns trending items")
    func allTrendingWithPageAndLanguageReturnsTrendingItems() async throws {
        let timeWindow = TrendingTimeWindowFilterType.week
        let page = 2
        let language = "en"
        let expectedResult = TrendingPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TrendingAllRequest(
            timeWindow: timeWindow, page: page, language: language
        )

        let result = try await service.allTrending(
            inTimeWindow: timeWindow, page: page, language: language
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TrendingAllRequest == expectedRequest)
    }

    @Test("allTrending when errors throws error")
    func allTrendingWhenErrorsThrowsError() async throws {
        let timeWindow = TrendingTimeWindowFilterType.day
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.allTrending(inTimeWindow: timeWindow)
        }
    }

}
