//
//  MovieServiceTests.swift
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

@testable import TMDb
import XCTest

final class MovieServiceTests: XCTestCase {

    var service: MovieService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        service = MovieService(apiClient: apiClient)
    }

    override func tearDown() {
        apiClient = nil
        service = nil
        super.tearDown()
    }

    func testDetailsReturnsMovie() async throws {
        let expectedResult = Movie.thorLoveAndThunder
        let movieID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieRequest(id: movieID, language: nil)

        let result = try await service.details(forMovie: movieID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MovieRequest, expectedRequest)
    }

    func testDetailsWithLanguageReturnsMovie() async throws {
        let expectedResult = Movie.thorLoveAndThunder
        let movieID = expectedResult.id
        let language = "en"
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieRequest(id: movieID, language: language)

        let result = try await service.details(forMovie: movieID, language: language)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MovieRequest, expectedRequest)
    }

    func testDetailsWhenErrorsThrowsError() async throws {
        let movieID = 1
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.details(forMovie: movieID)
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

    func testCreditsReturnsCredits() async throws {
        let expectedResult = ShowCredits.mock()
        let movieID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieCreditsRequest(id: movieID, language: nil)

        let result = try await service.credits(forMovie: movieID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MovieCreditsRequest, expectedRequest)
    }

    func testCreditsWithLanguageReturnsCredits() async throws {
        let expectedResult = ShowCredits.mock()
        let movieID = expectedResult.id
        let language = "en"
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieCreditsRequest(id: movieID, language: language)

        let result = try await service.credits(forMovie: movieID, language: language)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MovieCreditsRequest, expectedRequest)
    }

    func testCreditsWhenErrorsThrowsError() async throws {
        let movieID = 1
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.credits(forMovie: movieID)
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

    func testReviewsReturnsReviews() async throws {
        let movieID = Int.randomID
        let expectedResult = ReviewPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieReviewsRequest(id: movieID, page: nil, language: nil)

        let result = try await service.reviews(forMovie: movieID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MovieReviewsRequest, expectedRequest)
    }

    func testReviewsWithPageAndLanguageReturnsReviews() async throws {
        let movieID = Int.randomID
        let expectedResult = ReviewPageableList.mock()
        let page = expectedResult.page
        let language = "en"
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieReviewsRequest(id: movieID, page: page, language: language)

        let result = try await service.reviews(forMovie: movieID, page: page, language: language)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MovieReviewsRequest, expectedRequest)
    }

    func testReviewsWhenErrorsThrowsError() async throws {
        let movieID = 1
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.reviews(forMovie: movieID)
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

    func testImagesReturnsImageCollection() async throws {
        let expectedResult = ImageCollection.mock()
        let movieID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieImagesRequest(id: movieID, languages: nil)

        let result = try await service.images(forMovie: movieID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MovieImagesRequest, expectedRequest)
    }

    func testImagesWithFilterReturnsImageCollection() async throws {
        let expectedResult = ImageCollection.mock()
        let movieID = expectedResult.id
        let languages = ["en-GB", "fr"]
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieImagesRequest(id: movieID, languages: languages)

        let filter = MovieImageFilter(languages: languages)
        let result = try await service.images(forMovie: movieID, filter: filter)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MovieImagesRequest, expectedRequest)
    }

    func testImagesWhenErrorsThrowsError() async throws {
        let movieID = 1
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.images(forMovie: movieID)
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

    func testVideosReturnsVideoCollection() async throws {
        let expectedResult = VideoCollection.mock()
        let movieID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieVideosRequest(id: movieID, languages: nil)

        let result = try await service.videos(forMovie: movieID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MovieVideosRequest, expectedRequest)
    }

    func testVideosWithFilterReturnsVideoCollection() async throws {
        let expectedResult = VideoCollection.mock()
        let movieID = expectedResult.id
        let languages = ["en", "fr"]
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieVideosRequest(id: movieID, languages: languages)

        let filter = MovieVideoFilter(languages: languages)
        let result = try await service.videos(forMovie: movieID, filter: filter)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MovieVideosRequest, expectedRequest)
    }

    func testVideosWhenErrorsThrowsError() async throws {
        let movieID = 1
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.videos(forMovie: movieID)
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

    func testRecommendationsReturnsMovies() async throws {
        let movieID = 1
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieRecommendationsRequest(id: movieID, page: nil, language: nil)

        let result = try await service.recommendations(forMovie: movieID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MovieRecommendationsRequest, expectedRequest)
    }

    func testRecommendationsWithPageAndLanguageReturnsMovies() async throws {
        let movieID = 1
        let page = 2
        let language = "en"
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieRecommendationsRequest(id: movieID, page: page, language: language)

        let result = try await service.recommendations(forMovie: movieID, page: page, language: language)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MovieRecommendationsRequest, expectedRequest)
    }

    func testRecommendationsWhenErrorsThrowsError() async throws {
        let movieID = 1
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.recommendations(forMovie: movieID)
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

    func testSimilarReturnsMovies() async throws {
        let movieID = 1
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = SimilarMoviesRequest(id: movieID, page: nil, language: nil)

        let result = try await service.similar(toMovie: movieID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? SimilarMoviesRequest, expectedRequest)
    }

    func testSimilarWithPageAndLanguageReturnsMovies() async throws {
        let movieID = 1
        let page = 2
        let language = "en"
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = SimilarMoviesRequest(id: movieID, page: page, language: language)

        let result = try await service.similar(toMovie: movieID, page: page, language: language)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? SimilarMoviesRequest, expectedRequest)
    }

    func testSimilarWhenErrorsThrowsError() async throws {
        let movieID = 1
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.similar(toMovie: movieID)
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

    func testNowPlayingReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MoviesNowPlayingRequest(page: nil)

        let result = try await service.nowPlaying()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MoviesNowPlayingRequest, expectedRequest)
    }

    func testNowPlayingWithPageAndCountryAndLanguageReturnsMovies() async throws {
        let page = 2
        let country = "GB"
        let language = "en"
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MoviesNowPlayingRequest(page: page, country: country, language: language)

        let result = try await service.nowPlaying(page: page, country: country, language: language)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MoviesNowPlayingRequest, expectedRequest)
    }

    func testNowPlayingWHenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.nowPlaying()
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

    func testPopularReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PopularMoviesRequest(page: nil, country: nil, language: nil)

        let result = try await service.popular()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? PopularMoviesRequest, expectedRequest)
    }

    func testPopularWithPageAndCountryAndLanguageReturnsMovies() async throws {
        let page = 2
        let country = "GB"
        let language = "en"
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PopularMoviesRequest(page: page, country: country, language: language)

        let result = try await service.popular(page: page, country: country, language: language)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? PopularMoviesRequest, expectedRequest)
    }

    func testPopularWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.popular()
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

    func testTopRatedReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TopRatedMoviesRequest(page: nil, country: nil, language: nil)

        let result = try await service.topRated()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TopRatedMoviesRequest, expectedRequest)
    }

    func testTopRatedWithPageAndCountryAndLanguageReturnsMovies() async throws {
        let page = 2
        let country = "GB"
        let language = "en"
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TopRatedMoviesRequest(page: page, country: country, language: language)

        let result = try await service.topRated(page: page, country: country, language: language)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TopRatedMoviesRequest, expectedRequest)
    }

    func testTopRatedWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.topRated()
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

    func testUpcomingReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = UpcomingMoviesRequest(page: nil, country: nil, language: nil)

        let result = try await service.upcoming()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? UpcomingMoviesRequest, expectedRequest)
    }

    func testUpcomingWithPageAndCountryAndLanguageReturnsMovies() async throws {
        let page = 2
        let country = "GB"
        let language = "en"
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = UpcomingMoviesRequest(page: page, country: country, language: language)

        let result = try await service.upcoming(page: page, country: country, language: language)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? UpcomingMoviesRequest, expectedRequest)
    }

    func testUpcomingWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.upcoming()
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

    func testWatchProvidersReturnsWatchProviders() async throws {
        let expectedResult = ShowWatchProviderResult.mock()
        let movieID = 1
        let country = "GB"
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieWatchProvidersRequest(id: movieID)

        let result = try await service.watchProviders(forMovie: movieID, country: country)

        XCTAssertEqual(result, expectedResult.results[country])
        XCTAssertEqual(apiClient.lastRequest as? MovieWatchProvidersRequest, expectedRequest)
    }

    func testWatchProvidersWhenErrorsThrowsError() async throws {
        let movieID = 1
        let country = "GB"
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.watchProviders(forMovie: movieID, country: country)
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

    func testExternalLinksReturnsExternalLinks() async throws {
        let expectedResult = MovieExternalLinksCollection.barbie
        let movieID = 346_698
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieExternalLinksRequest(id: movieID)

        let result = try await service.externalLinks(forMovie: movieID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MovieExternalLinksRequest, expectedRequest)
    }

    func testExternalLinksWhenErrorsThrowsError() async throws {
        let movieID = 346_698
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.externalLinks(forMovie: movieID)
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

}
