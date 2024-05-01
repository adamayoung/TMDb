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

// swiftlint:disable:next type_body_length
final class MovieServiceTests: XCTestCase {

    var service: MovieService!
    var apiClient: MockAPIClient!
    var localeProvider: LocaleMockProvider!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        localeProvider = LocaleMockProvider(languageCode: "en", regionCode: "GB")
        service = MovieService(apiClient: apiClient, localeProvider: localeProvider)
    }

    override func tearDown() {
        apiClient = nil
        localeProvider = nil
        service = nil
        super.tearDown()
    }

    func testDetailsReturnsMovie() async throws {
        let expectedResult = Movie.thorLoveAndThunder
        let movieID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieRequest(id: movieID)

        let result = try await service.details(forMovie: movieID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MovieRequest, expectedRequest)
    }

    func testCreditsReturnsCredits() async throws {
        let expectedResult = ShowCredits.mock()
        let movieID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieCreditsRequest(id: movieID)

        let result = try await service.credits(forMovie: movieID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MovieCreditsRequest, expectedRequest)
    }

    func testReviewsWithDefaultParametersReturnsReviews() async throws {
        let movieID = Int.randomID
        let expectedResult = ReviewPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieReviewsRequest(id: movieID, page: nil)

        let result = try await service.reviews(forMovie: movieID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MovieReviewsRequest, expectedRequest)
    }

    func testReviewsReturnsReviews() async throws {
        let movieID = Int.randomID
        let expectedResult = ReviewPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieReviewsRequest(id: movieID, page: nil)

        let result = try await service.reviews(forMovie: movieID, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MovieReviewsRequest, expectedRequest)
    }

    func testReviewsWithPageReturnsReviews() async throws {
        let movieID = Int.randomID
        let expectedResult = ReviewPageableList.mock()
        let page = expectedResult.page
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieReviewsRequest(id: movieID, page: page)

        let result = try await service.reviews(forMovie: movieID, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MovieReviewsRequest, expectedRequest)
    }

    func testImagesWhenLanguageCodeAvailableReturnsImageCollection() async throws {
        let expectedResult = ImageCollection.mock()
        let movieID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieImagesRequest(id: movieID, languageCode: localeProvider.languageCode)

        let result = try await service.images(forMovie: movieID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MovieImagesRequest, expectedRequest)
    }

    func testImagesWhenLanguageCodeNotAvailableReturnsImageCollection() async throws {
        let expectedResult = ImageCollection.mock()
        let movieID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))
        localeProvider.languageCode = nil
        let expectedRequest = MovieImagesRequest(id: movieID, languageCode: nil)

        let result = try await service.images(forMovie: movieID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MovieImagesRequest, expectedRequest)
    }

    func testVideosReturnsVideoCollection() async throws {
        let expectedResult = VideoCollection.mock()
        let movieID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieVideosRequest(id: movieID, languageCode: localeProvider.languageCode)

        let result = try await service.videos(forMovie: movieID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MovieVideosRequest, expectedRequest)
    }

    func testVideosWhenLanguageCodeNotAvailableReturnsImageCollection() async throws {
        let expectedResult = VideoCollection.mock()
        let movieID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))
        localeProvider.languageCode = nil
        let expectedRequest = MovieVideosRequest(id: movieID, languageCode: nil)

        let result = try await service.videos(forMovie: movieID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MovieVideosRequest, expectedRequest)
    }

    func testRecommendationsWithDefaultParametersReturnsMovies() async throws {
        let movieID = 1
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieRecommendationsRequest(id: movieID, page: nil)

        let result = try await service.recommendations(forMovie: movieID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MovieRecommendationsRequest, expectedRequest)
    }

    func testRecommendationsReturnsMovies() async throws {
        let movieID = 1
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieRecommendationsRequest(id: movieID, page: nil)

        let result = try await service.recommendations(forMovie: movieID, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MovieRecommendationsRequest, expectedRequest)
    }

    func testRecommendationsWithPageReturnsMovies() async throws {
        let movieID = 1
        let expectedResult = MoviePageableList.mock()
        let page = expectedResult.page
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieRecommendationsRequest(id: movieID, page: page)

        let result = try await service.recommendations(forMovie: movieID, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MovieRecommendationsRequest, expectedRequest)
    }

    func testSimilarWithDefaultParametersReturnsMovies() async throws {
        let movieID = 1
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = SimilarMoviesRequest(id: movieID, page: nil)

        let result = try await service.similar(toMovie: movieID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? SimilarMoviesRequest, expectedRequest)
    }

    func testSimilarReturnsMovies() async throws {
        let movieID = 1
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = SimilarMoviesRequest(id: movieID, page: nil)

        let result = try await service.similar(toMovie: movieID, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? SimilarMoviesRequest, expectedRequest)
    }

    func testSimilarWithPageReturnsMovies() async throws {
        let movieID = 1
        let expectedResult = MoviePageableList.mock()
        let page = expectedResult.page
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = SimilarMoviesRequest(id: movieID, page: page)

        let result = try await service.similar(toMovie: movieID, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? SimilarMoviesRequest, expectedRequest)
    }

    func testNowPlayingWithDefaultParametersReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MoviesNowPlayingRequest(page: nil)

        let result = try await service.nowPlaying()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MoviesNowPlayingRequest, expectedRequest)
    }

    func testNowPlayingReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MoviesNowPlayingRequest(page: nil)

        let result = try await service.nowPlaying(page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MoviesNowPlayingRequest, expectedRequest)
    }

    func testNowPlayingWithPageReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        let page = expectedResult.page
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MoviesNowPlayingRequest(page: page)

        let result = try await service.nowPlaying(page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MoviesNowPlayingRequest, expectedRequest)
    }

    func testPopularWithDefaultParametersReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PopularMoviesRequest(page: nil)

        let result = try await service.popular()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? PopularMoviesRequest, expectedRequest)
    }

    func testPopularReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PopularMoviesRequest(page: nil)

        let result = try await service.popular(page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? PopularMoviesRequest, expectedRequest)
    }

    func testPopularWithPageReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        let page = expectedResult.page
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PopularMoviesRequest(page: page)

        let result = try await service.popular(page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? PopularMoviesRequest, expectedRequest)
    }

    func testTopRatedWithDefaultParametersReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TopRatedMoviesRequest(page: nil)

        let result = try await service.topRated()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TopRatedMoviesRequest, expectedRequest)
    }

    func testTopRatedReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TopRatedMoviesRequest(page: nil)

        let result = try await service.topRated(page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TopRatedMoviesRequest, expectedRequest)
    }

    func testTopRatedWithPageReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        let page = expectedResult.page
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TopRatedMoviesRequest(page: page)

        let result = try await service.topRated(page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TopRatedMoviesRequest, expectedRequest)
    }

    func testUpcomingWithDefaultParametersReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = UpcomingMoviesRequest(page: nil)

        let result = try await service.upcoming()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? UpcomingMoviesRequest, expectedRequest)
    }

    func testUpcomingReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = UpcomingMoviesRequest(page: nil)

        let result = try await service.upcoming(page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? UpcomingMoviesRequest, expectedRequest)
    }

    func testUpcomingWithPageReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        let page = expectedResult.page
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = UpcomingMoviesRequest(page: page)

        let result = try await service.upcoming(page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? UpcomingMoviesRequest, expectedRequest)
    }

    func testWatchProvidersReturnsWatchProviders() async throws {
        let expectedResult = ShowWatchProviderResult.mock()
        let movieID = 1
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieWatchProvidersRequest(id: movieID)

        let result = try await service.watchProviders(forMovie: movieID)

        let regionCode = try XCTUnwrap(localeProvider.regionCode)
        XCTAssertEqual(result, expectedResult.results[regionCode])
        XCTAssertEqual(apiClient.lastRequest as? MovieWatchProvidersRequest, expectedRequest)
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

}
