//
//  TMDbTVSeriesServiceListsTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .tvSeries))
struct TMDbTVSeriesServiceListsTests {

    var service: TMDbTVSeriesService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbTVSeriesService(apiClient: apiClient)
    }

    @Test("recommenendations with default parameter values returns TV series")
    func recommendationsWithDefaultParameterValuesReturnsTVSeries() async throws {
        let tvSeriesID = 1
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesRecommendationsRequest(
            id: tvSeriesID,
            page: nil,
            language: nil
        )

        let result = try await (service as TVSeriesService).recommendations(forTVSeries: tvSeriesID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeriesRecommendationsRequest == expectedRequest)
    }

    @Test("recommendations with page and language returns TV series")
    func recommendationsWithPageAndLanguageReturnsTVSeries() async throws {
        let tvSeriesID = 1
        let page = 2
        let language = "en"
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesRecommendationsRequest(
            id: tvSeriesID, page: page, language: language
        )

        let result = try await service.recommendations(
            forTVSeries: tvSeriesID, page: page, language: language
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeriesRecommendationsRequest == expectedRequest)
    }

    @Test("recommendations when errors throws error")
    func recommendationsWhenErrorsThrowsError() async throws {
        let tvSeriesID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.recommendations(forTVSeries: tvSeriesID)
        }
    }

    @Test("similar with default parameter values returns TV series")
    func similarWithDefaultParameterValuesReturnsTVSeries() async throws {
        let tvSeriesID = 1
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = SimilarTVSeriesRequest(id: tvSeriesID, page: nil, language: nil)

        let result = try await (service as TVSeriesService).similar(toTVSeries: tvSeriesID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? SimilarTVSeriesRequest == expectedRequest)
    }

    @Test("similar with page and language returns TV series")
    func similarWithPageAndLanguageReturnsTVSeries() async throws {
        let tvSeriesID = 1
        let page = 2
        let language = "en"
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = SimilarTVSeriesRequest(id: tvSeriesID, page: page, language: language)

        let result = try await service.similar(
            toTVSeries: tvSeriesID, page: page, language: language
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? SimilarTVSeriesRequest == expectedRequest)
    }

    @Test("similar when errors throws error")
    func similarWhenErrorsThrowsError() async throws {
        let tvSeriesID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.similar(toTVSeries: tvSeriesID)
        }
    }

    @Test("popular with default parameter values returns TV series")
    func popularWithDefaultParameterValuesReturnsTVSeries() async throws {
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PopularTVSeriesRequest(page: nil, language: nil)

        let result = try await (service as TVSeriesService).popular()

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? PopularTVSeriesRequest == expectedRequest)
    }

    @Test("popular with page and language returns TV series")
    func popularWithPageAndLanguageReturnsTVSeries() async throws {
        let page = 2
        let language = "en"
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PopularTVSeriesRequest(page: page, language: language)

        let result = try await service.popular(page: page, language: language)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? PopularTVSeriesRequest == expectedRequest)
    }

    @Test("popular when errors throws error")
    func popularWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.popular()
        }
    }

    @Test("airingToday with default parameter values returns TV series")
    func airingTodayWithDefaultParameterValuesReturnsTVSeries() async throws {
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesAiringTodayRequest(page: nil, timezone: nil, language: nil)

        let result = try await (service as TVSeriesService).airingToday()

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeriesAiringTodayRequest == expectedRequest)
    }

    @Test("airingToday with page, timezone and language returns TV series")
    func airingTodayWithPageTimezoneAndLanguageReturnsTVSeries() async throws {
        let page = 2
        let timezone = "America/New_York"
        let language = "en"
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesAiringTodayRequest(
            page: page,
            timezone: timezone,
            language: language
        )

        let result = try await service.airingToday(
            page: page,
            timezone: timezone,
            language: language
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeriesAiringTodayRequest == expectedRequest)
    }

    @Test("airingToday when errors throws error")
    func airingTodayWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.airingToday()
        }
    }

    @Test("onTheAir with default parameter values returns TV series")
    func onTheAirWithDefaultParameterValuesReturnsTVSeries() async throws {
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesOnTheAirRequest(page: nil, timezone: nil, language: nil)

        let result = try await (service as TVSeriesService).onTheAir()

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeriesOnTheAirRequest == expectedRequest)
    }

    @Test("onTheAir with page, timezone and language returns TV series")
    func onTheAirWithPageTimezoneAndLanguageReturnsTVSeries() async throws {
        let page = 2
        let timezone = "Europe/London"
        let language = "en"
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesOnTheAirRequest(
            page: page,
            timezone: timezone,
            language: language
        )

        let result = try await service.onTheAir(
            page: page,
            timezone: timezone,
            language: language
        )

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeriesOnTheAirRequest == expectedRequest)
    }

    @Test("onTheAir when errors throws error")
    func onTheAirWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.onTheAir()
        }
    }

    @Test("topRated with default parameter values returns TV series")
    func topRatedWithDefaultParameterValuesReturnsTVSeries() async throws {
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TopRatedTVSeriesRequest(page: nil, language: nil)

        let result = try await (service as TVSeriesService).topRated()

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TopRatedTVSeriesRequest == expectedRequest)
    }

    @Test("topRated with page and language returns TV series")
    func topRatedWithPageAndLanguageReturnsTVSeries() async throws {
        let page = 2
        let language = "en"
        let expectedResult = TVSeriesPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TopRatedTVSeriesRequest(page: page, language: language)

        let result = try await service.topRated(page: page, language: language)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TopRatedTVSeriesRequest == expectedRequest)
    }

    @Test("topRated when errors throws error")
    func topRatedWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.topRated()
        }
    }

}
