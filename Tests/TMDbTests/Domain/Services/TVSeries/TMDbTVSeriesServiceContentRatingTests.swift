//
//  TMDbTVSeriesServiceContentRatingTests.swift
//  TMDb
//
//  Copyright © 2025 Adam Young.
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
struct TMDbTVSeriesServiceContentRatingTests {

    var service: TMDbTVSeriesService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbTVSeriesService(apiClient: apiClient)
    }

    @Test("contentRatings with default parameter values returns TV series ratings")
    func contentRatingsWithDefaultParameterValuesReturnsTVSeriesRatings() async throws {
        let expectedResult = ContentRatingResult.mock
        let tvSeriesID = expectedResult.id
        let country = "US"

        let expectedRating = expectedResult.results.first { rating in
            rating.countryCode == country
        }

        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = ContentRatingRequest(id: tvSeriesID)

        let result = try await (service as TVSeriesService).contentRatings(forTVSeries: tvSeriesID)

        #expect(result == expectedRating)
        #expect(apiClient.lastRequest as? ContentRatingRequest == expectedRequest)
    }

    @Test("contentRatings with country returns TV series ratings")
    func contentRatingsWithCountryReturnsTVSeriesRatings() async throws {
        let expectedResult = ContentRatingResult.mock
        let tvSeriesID = expectedResult.id
        let country = "GB"

        let expectedRating = expectedResult.results.first { rating in
            rating.countryCode == country
        }

        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = ContentRatingRequest(id: tvSeriesID)

        let result = try await service.contentRatings(forTVSeries: tvSeriesID, country: country)

        #expect(result == expectedRating)
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
