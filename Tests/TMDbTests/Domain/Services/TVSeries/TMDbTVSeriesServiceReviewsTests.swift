//
//  TMDbTVSeriesServiceReviewsTests.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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

    @Test("reviews returns reviews")
    func reviewsReturnsReviews() async throws {
        let tvSeriesID = Int.randomID
        let expectedResult = ReviewPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TVSeriesReviewsRequest(id: tvSeriesID, page: nil, language: nil)

        let result = try await service.reviews(forTVSeries: tvSeriesID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeriesReviewsRequest == expectedRequest)
    }

    @Test("reviews with language returns reviews")
    func reviewsWithLanguageReturnsReviews() async throws {
        let tvSeriesID = Int.randomID
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
