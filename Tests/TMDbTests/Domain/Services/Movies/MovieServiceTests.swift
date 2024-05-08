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

    func testCreditsReturnsCredits() async throws {
        let expectedResult = ShowCredits.mock()
        let movieID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieCreditsRequest(id: movieID, language: nil)

        let result = try await service.credits(forMovie: movieID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MovieCreditsRequest, expectedRequest)
    }

    func testReviewsWithDefaultParametersReturnsReviews() async throws {
        let movieID = Int.randomID
        let expectedResult = ReviewPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieReviewsRequest(id: movieID, page: nil, language: nil)

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

    func testImagesReturnsImageCollection() async throws {
        let expectedResult = ImageCollection.mock()
        let movieID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieImagesRequest(id: movieID, language: nil)

        let result = try await service.images(forMovie: movieID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MovieImagesRequest, expectedRequest)
    }

    func testVideosReturnsVideoCollection() async throws {
        let expectedResult = VideoCollection.mock()
        let movieID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = MovieVideosRequest(id: movieID, language: nil)

        let result = try await service.videos(forMovie: movieID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MovieVideosRequest, expectedRequest)
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

    func testSimilarReturnsMovies() async throws {
        let movieID = 1
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = SimilarMoviesRequest(id: movieID, page: nil, language: nil)

        let result = try await service.similar(toMovie: movieID)

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
        let expectedRequest = MoviesNowPlayingRequest(page: nil, language: nil, country: nil)

        let result = try await service.nowPlaying()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? MoviesNowPlayingRequest, expectedRequest)
    }

    func testPopularReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PopularMoviesRequest(page: nil, language: nil, country: nil)

        let result = try await service.popular()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? PopularMoviesRequest, expectedRequest)
    }

    func testTopRatedReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = TopRatedMoviesRequest(page: nil, language: nil, country: nil)

        let result = try await service.topRated()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? TopRatedMoviesRequest, expectedRequest)
    }

    func testUpcomingReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = UpcomingMoviesRequest(page: nil, language: nil, country: nil)

        let result = try await service.upcoming()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? UpcomingMoviesRequest, expectedRequest)
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
