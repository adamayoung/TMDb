//
//  TMDbTVSeriesServiceDetailsTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.services, .tvSeries))
struct TMDbTVSeriesServiceTests {

    var service: TMDbTVSeriesService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbTVSeriesService(apiClient: apiClient)
    }

    @Test("details with default parameter values returns TV series")
    func detailsReturnsTVSeries() async throws {
        let expectedResult = TVSeries.theSandman
        let tvSeriesID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesRequest(id: tvSeriesID, language: nil)

        let result = try await (service as TVSeriesService).details(forTVSeries: tvSeriesID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeriesRequest == expectedRequest)
    }

    @Test("details with language returns TV series")
    func detailsWithLanguageReturnsTVSeries() async throws {
        let expectedResult = TVSeries.theSandman
        let tvSeriesID = expectedResult.id
        let language = "en"
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesRequest(id: tvSeriesID, language: language)

        let result = try await service.details(forTVSeries: tvSeriesID, language: language)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeriesRequest == expectedRequest)
    }

    @Test("details when errors throws error")
    func detailsWhenErrorsThrowsError() async throws {
        let tvSeriesID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.details(forTVSeries: tvSeriesID)
        }
    }

}
