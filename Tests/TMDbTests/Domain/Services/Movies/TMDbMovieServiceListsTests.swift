//
//  TMDbMovieServiceListsTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
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

    @Test("recommendations with default parameter values returns movies")
    func recommendationsWIthDefaultParametersReturnsMovies() async throws {
        let movieID = 1
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieRecommendationsRequest(id: movieID, page: nil, language: nil)

        let result = try await (service as MovieService).recommendations(forMovie: movieID)

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
        let expectedRequest = MovieRecommendationsRequest(
            id: movieID, page: page, language: language
        )

        let result = try await service.recommendations(
            forMovie: movieID, page: page, language: language
        )

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

    @Test("similar with default parameter values returns movies")
    func similarWithDefaultParameterValuesReturnsMovies() async throws {
        let movieID = 1
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = SimilarMoviesRequest(id: movieID, page: nil, language: nil)

        let result = try await (service as MovieService).similar(toMovie: movieID)

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

    @Test("nowPlaying with default parameter values returns movies")
    func nowPlayingWithDefaultParameterValuesReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MoviesNowPlayingRequest(page: nil)

        let result = try await (service as MovieService).nowPlaying()

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
        let expectedRequest = MoviesNowPlayingRequest(
            page: page, country: country, language: language
        )

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

    @Test("popular with default parameter values returns movies")
    func popularWithDefaultParameterValuesReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PopularMoviesRequest(page: nil, country: nil, language: nil)

        let result = try await (service as MovieService).popular()

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

    @Test("topRated with default parameter values returns movies")
    func topRatedWithDefaultParameterValuesReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TopRatedMoviesRequest(page: nil, country: nil, language: nil)

        let result = try await (service as MovieService).topRated()

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
        let expectedRequest = TopRatedMoviesRequest(
            page: page, country: country, language: language
        )

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

    @Test("upcoming with default parameter values returns movies")
    func upcomingWithDefaultParameterValuesReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = UpcomingMoviesRequest(page: nil, country: nil, language: nil)

        let result = try await (service as MovieService).upcoming()

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
        let expectedRequest = UpcomingMoviesRequest(
            page: page, country: country, language: language
        )

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

    @Test("lists with default parameter values returns media lists")
    func listsWithDefaultParameterValuesReturnsMediaLists() async throws {
        let expectedResult = MediaPageableList.mock()
        let movieID = 1
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieListsRequest(id: movieID, page: nil, language: nil)

        let result = try await (service as MovieService).lists(forMovie: movieID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? MovieListsRequest == expectedRequest)
    }

    @Test("lists with page and language returns media lists")
    func listsWithPageAndLanguageReturnsMediaLists() async throws {
        let expectedResult = MediaPageableList.mock()
        let movieID = 1
        let page = 2
        let language = "en"
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieListsRequest(id: movieID, page: page, language: language)

        let result = try await service.lists(forMovie: movieID, page: page, language: language)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? MovieListsRequest == expectedRequest)
    }

    @Test("lists when errors throws error")
    func listsWhenErrorsThrowsError() async throws {
        let movieID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.lists(forMovie: movieID)
        }
    }

}
