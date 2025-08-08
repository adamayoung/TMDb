//
//  TMDbGenreServiceTests.swift
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

@Suite(.tags(.services, .genre))
struct TMDbGenreServiceTests {

    var service: TMDbGenreService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbGenreService(apiClient: apiClient)
    }

    @Test("movieGenres with default parameter values returns genres")
    func movieGenresWithDefaultParameterValuesReturnsGenres() async throws {
        let genreList = GenreList.mock()
        let expectedResult = genreList.genres
        apiClient.addResponse(.success(genreList))
        let expectedRequest = MovieGenresRequest(language: nil)

        let result = try await (service as GenreService).movieGenres()

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? MovieGenresRequest == expectedRequest)
    }

    @Test("movieGenres with language returns genres")
    func movieGenresWithLanguageReturnsGenres() async throws {
        let genreList = GenreList.mock()
        let language = "en"
        let expectedResult = genreList.genres
        apiClient.addResponse(.success(genreList))
        let expectedRequest = MovieGenresRequest(language: language)

        let result = try await service.movieGenres(language: language)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? MovieGenresRequest == expectedRequest)
    }

    @Test("movingGenres when errors throws error")
    func movieGenresWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.movieGenres()
        }
    }

    @Test("tvSeriesGenres with default parameter values returns genres")
    func tvSeriesGenresWithDefaultParameterValuesReturnsGenres() async throws {
        let genreList = GenreList.mock()
        let expectedResult = genreList.genres
        apiClient.addResponse(.success(genreList))
        let expectedRequest = TVSeriesGenresRequest(language: nil)

        let result = try await (service as GenreService).tvSeriesGenres()

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeriesGenresRequest == expectedRequest)
    }

    @Test("tvSeriesGenres with language returns genres")
    func tvSeriesGenresWithLanguageReturnsGenres() async throws {
        let genreList = GenreList.mock()
        let language = "en"
        let expectedResult = genreList.genres
        apiClient.addResponse(.success(genreList))
        let expectedRequest = TVSeriesGenresRequest(language: language)

        let result = try await service.tvSeriesGenres(language: language)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeriesGenresRequest == expectedRequest)
    }

    @Test("tvSeriesGenres when errors throws error")
    func tvSeriesGenresWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.tvSeriesGenres()
        }
    }

}
