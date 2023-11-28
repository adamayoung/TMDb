//
//  MovieIntegrationTests.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
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

import TMDb
import XCTest

final class MovieIntegrationTests: XCTestCase {

    var movieService: MovieService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        try configureTMDb()
        movieService = MovieService()
    }

    override func tearDown() {
        movieService = nil
        super.tearDown()
    }

    func testDetails() async throws {
        let movieID = 346_698

        let movie = try await movieService.details(forMovie: movieID)

        XCTAssertEqual(movie.id, movieID)
        XCTAssertEqual(movie.title, "Barbie")
    }

    func testCredits() async throws {
        let movieID = 346_698

        let credits = try await movieService.credits(forMovie: movieID)

        XCTAssertEqual(credits.id, movieID)
        XCTAssertFalse(credits.cast.isEmpty)
        XCTAssertFalse(credits.crew.isEmpty)
    }

    func testReviews() async throws {
        let movieID = 346_698

        let reviewList = try await movieService.reviews(forMovie: movieID)

        XCTAssertFalse(reviewList.results.isEmpty)
    }

    func testImages() async throws {
        let movieID = 346_698

        let imageCollection = try await movieService.images(forMovie: movieID)

        XCTAssertEqual(imageCollection.id, movieID)
        XCTAssertFalse(imageCollection.posters.isEmpty)
        XCTAssertFalse(imageCollection.logos.isEmpty)
        XCTAssertFalse(imageCollection.backdrops.isEmpty)
    }

    func testVideos() async throws {
        let movieID = 346_698

        let videoCollection = try await movieService.videos(forMovie: movieID)

        XCTAssertEqual(videoCollection.id, movieID)
        XCTAssertFalse(videoCollection.results.isEmpty)
    }

    func testRecommendations() async throws {
        let movieID = 921_636

        let recommendationList = try await movieService.recommendations(forMovie: movieID)

        XCTAssertFalse(recommendationList.results.isEmpty)
    }

    func testSimilar() async throws {
        let movieID = 921_636

        let movieList = try await movieService.similar(toMovie: movieID)

        XCTAssertFalse(movieList.results.isEmpty)
    }

    func testNowPlaying() async throws {
        let movieList = try await movieService.nowPlaying()

        XCTAssertFalse(movieList.results.isEmpty)
    }

    func testPopular() async throws {
        let movieList = try await movieService.popular()

        XCTAssertFalse(movieList.results.isEmpty)
    }

    func testTopRated() async throws {
        let movieList = try await movieService.topRated()

        XCTAssertFalse(movieList.results.isEmpty)
    }

    func testUpcoming() async throws {
        let movieList = try await movieService.upcoming()

        XCTAssertFalse(movieList.results.isEmpty)
    }

}
