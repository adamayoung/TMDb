//
//  TMDbMovieServiceCreditsTests.swift
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
struct TMDbMovieServiceCreditsTests {

    var service: TMDbMovieService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbMovieService(apiClient: apiClient)
    }

    @Test("credits with default parameter values returns credits")
    func creditsWithDefaultParameterValuesReturnsCredits() async throws {
        let expectedResult = ShowCredits.mock()
        let movieID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieCreditsRequest(id: movieID, language: nil)

        let result = try await (service as MovieService).credits(forMovie: movieID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? MovieCreditsRequest == expectedRequest)
    }

    @Test("credit with language returns credits")
    func creditsWithLanguageReturnsCredits() async throws {
        let expectedResult = ShowCredits.mock()
        let movieID = expectedResult.id
        let language = "en"
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieCreditsRequest(id: movieID, language: language)

        let result = try await service.credits(forMovie: movieID, language: language)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? MovieCreditsRequest == expectedRequest)
    }

    @Test("credits when errors returns error")
    func creditsWhenErrorsThrowsError() async throws {
        let movieID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.credits(forMovie: movieID)
        }
    }

}
