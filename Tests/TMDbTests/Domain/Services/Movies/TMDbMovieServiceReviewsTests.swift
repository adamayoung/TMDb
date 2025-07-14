//
//  TMDbMovieServiceReviewsTests.swift
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

@Suite(.tags(.services, .movie))
struct TMDbMovieServiceReviewsTests {

    var service: TMDbMovieService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbMovieService(apiClient: apiClient)
    }

    @Test("reviews with default parameter values returns reviews")
    func reviewsReturnsReviews() async throws {
        let movieID = 1
        let expectedResult = ReviewPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieReviewsRequest(id: movieID, page: nil, language: nil)

        let result = try await (service as MovieService).reviews(forMovie: movieID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? MovieReviewsRequest == expectedRequest)
    }

    @Test("reviews with page and language returns reviews")
    func reviewsWithPageAndLanguageReturnsReviews() async throws {
        let movieID = 1
        let expectedResult = ReviewPageableList.mock()
        let page = expectedResult.page
        let language = "en"
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieReviewsRequest(id: movieID, page: page, language: language)

        let result = try await service.reviews(forMovie: movieID, page: page, language: language)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? MovieReviewsRequest == expectedRequest)
    }

    @Test("reviews when errors returns error")
    func reviewsWhenErrorsThrowsError() async throws {
        let movieID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.self) {
            _ = try await service.reviews(forMovie: movieID)
        }
    }

}
