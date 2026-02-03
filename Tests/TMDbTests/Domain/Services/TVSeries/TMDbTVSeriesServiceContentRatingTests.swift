//
//  TMDbTVSeriesServiceContentRatingTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.services, .tvSeries))
struct TMDbTVSeriesServiceContentRatingTests {

    var service: TMDbTVSeriesService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbTVSeriesService(apiClient: apiClient)
    }

    @Test("contentRatings returns all TV series ratings")
    func contentRatingsReturnsAllTVSeriesRatings() async throws {
        let expectedResult = ContentRatingResult.mock
        let tvSeriesID = expectedResult.id

        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = ContentRatingRequest(id: tvSeriesID)

        let result = try await service.contentRatings(forTVSeries: tvSeriesID)

        #expect(result == expectedResult.results)
        #expect(apiClient.lastRequest as? ContentRatingRequest == expectedRequest)
    }

    @Test("contentRatings when errors throws error")
    func contentRatingsWhenErrorsThrowsError() async throws {
        let tvSeriesID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.contentRatings(forTVSeries: tvSeriesID)
        }
    }
}
