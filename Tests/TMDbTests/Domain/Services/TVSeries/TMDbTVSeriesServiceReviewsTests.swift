//
//  TMDbTVSeriesServiceReviewsTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.services, .tvSeries))
struct TMDbTVSeriesServiceReviewsTests {

    var service: TMDbTVSeriesService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbTVSeriesService(apiClient: apiClient)
    }

    @Test("reviews with default parameter values returns reviews")
    func reviewsWithDefaultParameterValuesReturnsReviews() async throws {
        let tvSeriesID = 1
        let expectedResult = ReviewPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesReviewsRequest(id: tvSeriesID, page: nil, language: nil)

        let result = try await (service as TVSeriesService).reviews(forTVSeries: tvSeriesID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeriesReviewsRequest == expectedRequest)
    }

    @Test("reviews with language returns reviews")
    func reviewsWithLanguageReturnsReviews() async throws {
        let tvSeriesID = 1
        let language = "en"
        let expectedResult = ReviewPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesReviewsRequest(id: tvSeriesID, page: nil, language: language)

        let result = try await service.reviews(forTVSeries: tvSeriesID, language: language)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeriesReviewsRequest == expectedRequest)
    }

    @Test("reviews when errors returns error")
    func reviewsWhenErrorsThrowsError() async throws {
        let tvSeriesID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.reviews(forTVSeries: tvSeriesID)
        }
    }

}
