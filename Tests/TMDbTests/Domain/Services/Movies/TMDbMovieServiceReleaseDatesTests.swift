//
//  TMDbMovieServiceReleaseDatesTests.swift
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
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.services, .movie))
struct TMDbMovieServiceReleaseDatesTests {

    var service: TMDbMovieService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbMovieService(apiClient: apiClient)
    }

    @Test("releaseDates returns release dates by country")
    func releaseDatesReturnsReleaseDatesByCountry() async throws {
        let movieID = 550
        let expectedResult = MovieReleaseDatesResult.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieReleaseDatesRequest(id: movieID)

        let result = try await service.releaseDates(forMovie: movieID)

        #expect(result == expectedResult.results)
        #expect(apiClient.lastRequest as? MovieReleaseDatesRequest == expectedRequest)
    }

    @Test("releaseDates when errors throws error")
    func releaseDatesWhenErrorsThrowsError() async throws {
        let movieID = 550
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.releaseDates(forMovie: movieID)
        }
    }

}
