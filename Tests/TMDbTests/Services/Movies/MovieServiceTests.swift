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

        let result = try await service.details(forMovie: movieID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, MoviesEndpoint.details(movieID: movieID).path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testCreditsReturnsCredits() async throws {
        let expectedResult = ShowCredits.mock()
        let movieID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.credits(forMovie: movieID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, MoviesEndpoint.credits(movieID: movieID).path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testReviewsWithDefaultParametersReturnsReviews() async throws {
        let movieID = Int.randomID
        let expectedResult = ReviewPageableList.mock()
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.reviews(forMovie: movieID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, MoviesEndpoint.reviews(movieID: movieID).path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testReviewsReturnsReviews() async throws {
        let movieID = Int.randomID
        let expectedResult = ReviewPageableList.mock()
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.reviews(forMovie: movieID, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, MoviesEndpoint.reviews(movieID: movieID).path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testReviewsWithPageReturnsReviews() async throws {
        let movieID = Int.randomID
        let expectedResult = ReviewPageableList.mock()
        let page = expectedResult.page
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.reviews(forMovie: movieID, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, MoviesEndpoint.reviews(movieID: movieID, page: page).path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testImagesReturnsImageCollection() async throws {
        let expectedResult = ImageCollection.mock()
        let movieID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.images(forMovie: movieID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(
            apiClient.lastRequestURL,
            MoviesEndpoint.images(movieID: movieID, languageCode: localeProvider.languageCode).path
        )
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testVideosReturnsVideoCollection() async throws {
        let expectedResult = VideoCollection.mock()
        let movieID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.videos(forMovie: movieID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(
            apiClient.lastRequestURL,
            MoviesEndpoint.videos(movieID: movieID, languageCode: localeProvider.languageCode).path
        )
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testRecommendationsWithDefaultParametersReturnsMovies() async throws {
        let movieID = 1
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.recommendations(forMovie: movieID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, MoviesEndpoint.recommendations(movieID: movieID).path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testRecommendationsReturnsMovies() async throws {
        let movieID = 1
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.recommendations(forMovie: movieID, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, MoviesEndpoint.recommendations(movieID: movieID).path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testRecommendationsWithPageReturnsMovies() async throws {
        let movieID = 1
        let expectedResult = MoviePageableList.mock()
        let page = expectedResult.page
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.recommendations(forMovie: movieID, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, MoviesEndpoint.recommendations(movieID: movieID, page: page).path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testSimilarWithDefaultParametersReturnsMovies() async throws {
        let movieID = 1
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.similar(toMovie: movieID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, MoviesEndpoint.similar(movieID: movieID).path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testSimilarReturnsMovies() async throws {
        let movieID = 1
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.similar(toMovie: movieID, page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, MoviesEndpoint.similar(movieID: movieID).path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testSimilarWithPageReturnsMovies() async throws {
        let movieID = 1
        let expectedResult = MoviePageableList.mock()
        let page = expectedResult.page
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.similar(toMovie: movieID, page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, MoviesEndpoint.similar(movieID: movieID, page: page).path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testNowPlayingWithDefaultParametersReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.nowPlaying()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, MoviesEndpoint.nowPlaying().path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testNowPlayingReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.nowPlaying(page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, MoviesEndpoint.nowPlaying().path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testNowPlayingWithPageReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        let page = expectedResult.page
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.nowPlaying(page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, MoviesEndpoint.nowPlaying(page: page).path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testPopularWithDefaultParametersReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.popular()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, MoviesEndpoint.popular().path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testPopularReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.popular(page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, MoviesEndpoint.popular().path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testPopularWithPageReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        let page = expectedResult.page
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.popular(page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, MoviesEndpoint.popular(page: page).path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testTopRatedWithDefaultParametersReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.topRated()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, MoviesEndpoint.topRated().path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testTopRatedReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.topRated(page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, MoviesEndpoint.topRated().path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testTopRatedWithPageReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        let page = expectedResult.page
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.topRated(page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, MoviesEndpoint.topRated(page: page).path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testUpcomingWithDefaultParametersReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.upcoming()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, MoviesEndpoint.upcoming().path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testUpcomingReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.upcoming(page: nil)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, MoviesEndpoint.upcoming().path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testUpcomingWithPageReturnsMovies() async throws {
        let expectedResult = MoviePageableList.mock()
        let page = expectedResult.page
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.upcoming(page: page)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, MoviesEndpoint.upcoming(page: page).path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testWatchReturnsWatchProviders() async throws {
        let expectedResult = ShowWatchProviderResult.mock()
        let movieID = 1
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.watchProviders(forMovie: movieID)

        let regionCode = try XCTUnwrap(localeProvider.regionCode)
        XCTAssertEqual(result, expectedResult.results[regionCode])
        XCTAssertEqual(apiClient.lastRequestURL, MoviesEndpoint.watch(movieID: movieID).path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testExternalLinksReturnsExternalLinks() async throws {
        let expectedResult = MovieExternalLinksCollection.barbie
        let movieID = 346_698
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.externalLinks(forMovie: movieID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, MoviesEndpoint.externalIDs(movieID: movieID).path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

}
