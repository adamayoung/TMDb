//
//  TMDbMovieServiceListsTests.swift
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

@Suite(.tags(.services, .movie))
struct TMDbMovieServiceListsTests {

    var service: TMDbMovieService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbMovieService(apiClient: apiClient)
    }

    @Test("recommendations returns movies")
    func recommendationsReturnsMovies() async throws {
        let movieID = 1
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieRecommendationsRequest(id: movieID, page: nil, language: nil)

        let result = try await service.recommendations(forMovie: movieID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? MovieRecommendationsRequest == expectedRequest)
    }

    @Test("recommenendations with page and language returns movies")
    func recommendationsWithPageAndLanguageReturnsMovies() async throws {
        let movieID = 1
        let page = 2
        let language = "en"
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieRecommendationsRequest(id: movieID, page: page, language: language)

        let result = try await service.recommendations(forMovie: movieID, page: page, language: language)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? MovieRecommendationsRequest == expectedRequest)
    }

    @Test("recommendations when errors throws error")
    func recommendationsWhenErrorsThrowsError() async throws {
        let movieID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.recommendations(forMovie: movieID)
        }
    }

    @Test("similar returns movies")
    func similarReturnsMovies() async throws {
        let movieID = 1
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = SimilarMoviesRequest(id: movieID, page: nil, language: nil)

        let result = try await service.similar(toMovie: movieID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? SimilarMoviesRequest == expectedRequest)
    }

    @Test("similar with page and language returns movies")
    func similarWithPageAndLanguageReturnsMovies() async throws {
        let movieID = 1
        let page = 2
        let language = "en"
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = SimilarMoviesRequest(id: movieID, page: page, language: language)

        let result = try await service.similar(toMovie: movieID, page: page, language: language)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? SimilarMoviesRequest == expectedRequest)
    }

    @Test("similar when errors throws error")
    func similarWhenErrorsThrowsError() async throws {
        let movieID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.similar(toMovie: movieID)
        }
    }

    @Test("nowPlaying returns movies")
    func nowPlayingReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MoviesNowPlayingRequest(page: nil)

        let result = try await service.nowPlaying()

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? MoviesNowPlayingRequest == expectedRequest)
    }

    @Test("nowPlaying with page, country and language returns movies")
    func nowPlayingWithPageAndCountryAndLanguageReturnsMovies() async throws {
        let page = 2
        let country = "GB"
        let language = "en"
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MoviesNowPlayingRequest(page: page, country: country, language: language)

        let result = try await service.nowPlaying(page: page, country: country, language: language)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? MoviesNowPlayingRequest == expectedRequest)
    }

    @Test("nowPlaying when errors throws error")
    func nowPlayingWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.nowPlaying()
        }
    }

    @Test("popular returns movies")
    func popularReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PopularMoviesRequest(page: nil, country: nil, language: nil)

        let result = try await service.popular()

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? PopularMoviesRequest == expectedRequest)
    }

    @Test("popular with page, country and language returns movies")
    func popularWithPageAndCountryAndLanguageReturnsMovies() async throws {
        let page = 2
        let country = "GB"
        let language = "en"
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PopularMoviesRequest(page: page, country: country, language: language)

        let result = try await service.popular(page: page, country: country, language: language)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? PopularMoviesRequest == expectedRequest)
    }

    @Test("popular when errors throws error")
    func popularWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown)).self

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.popular()
        }
    }

    @Test("topRated returns movies")
    func topRatedReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TopRatedMoviesRequest(page: nil, country: nil, language: nil)

        let result = try await service.topRated()

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TopRatedMoviesRequest == expectedRequest)
    }

    @Test("topRated with page, country and language returns movies")
    func topRatedWithPageAndCountryAndLanguageReturnsMovies() async throws {
        let page = 2
        let country = "GB"
        let language = "en"
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TopRatedMoviesRequest(page: page, country: country, language: language)

        let result = try await service.topRated(page: page, country: country, language: language)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TopRatedMoviesRequest == expectedRequest)
    }

    @Test("topRated when errors throws error")
    func topRatedWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.topRated()
        }
    }

    @Test("upcoming returns movies")
    func upcomingReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = UpcomingMoviesRequest(page: nil, country: nil, language: nil)

        let result = try await service.upcoming()

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? UpcomingMoviesRequest == expectedRequest)
    }

    @Test("upcoming with page, country and language returns movies")
    func upcomingWithPageAndCountryAndLanguageReturnsMovies() async throws {
        let page = 2
        let country = "GB"
        let language = "en"
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = UpcomingMoviesRequest(page: page, country: country, language: language)

        let result = try await service.upcoming(page: page, country: country, language: language)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? UpcomingMoviesRequest == expectedRequest)
    }

    @Test("upcoming when errors throws error")
    func upcomingWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.upcoming()
        }
    }

}
