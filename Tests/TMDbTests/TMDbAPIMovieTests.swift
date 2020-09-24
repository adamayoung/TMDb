import Combine
@testable import TMDb
import XCTest

class TMDbAPIMovieTests: TMDbAPITestCase {

    func testDetailsPublisherForMovieReturnsMovie() throws {
        let expectedResult = MovieDTO(id: 1, title: "Title 1")
        movieService.movieDetails = expectedResult
        let expectedMovieID: MovieDTO.ID = 1

        let result = try await(publisher: tmdb.detailsPublisher(forMovie: expectedMovieID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(movieService.lastMovieDetailsID, expectedMovieID)
    }

    func testCreditsPublisherForMovieReturnsShowCredits() throws {
        let expectedResult = ShowCreditsDTO(
            id: 1,
            cast: [
                CastMemberDTO(
                    id: 2,
                    creditID: "3",
                    name: "Cast 1",
                    character: "Character 1",
                    order: 0
                ),
                CastMemberDTO(
                    id: 3,
                    creditID: "4",
                    name: "Cast 2",
                    character: "Character 2",
                    order: 1
                )
            ],
            crew: [
                CrewMemberDTO(
                    id: 4,
                    creditID: "5",
                    name: "Crew 1",
                    job: "Job 1",
                    department: "Department 1"
                ),
                CrewMemberDTO(
                    id: 5,
                    creditID: "6",
                    name: "Crew 2",
                    job: "Job 2",
                    department: "Department 2"
                )
            ]
        )
        movieService.credits = expectedResult
        let expectedMovieID: MovieDTO.ID = 1

        let result = try await(publisher: tmdb.creditsPublisher(forMovie: expectedMovieID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(movieService.lastCreditsMovieID, expectedMovieID)
    }

    func testReviewsPublisherForMovieReturnsReviews() throws {
        let expectedResult = ReviewPageableListDTO(
            page: 2,
            results: [
                ReviewDTO(id: "1", author: "Author 1", content: "Content 1"),
                ReviewDTO(id: "2", author: "Author 2", content: "Content 2"),
                ReviewDTO(id: "3", author: "Author 3", content: "Content 3")
            ],
            totalResults: 6,
            totalPages: 2
        )
        movieService.reviews = expectedResult
        let expectedMovieID: MovieDTO.ID = 1

        let result = try await(publisher: tmdb.reviewsPublisher(forMovie: expectedMovieID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(movieService.lastReviewsMovieID, expectedMovieID)
    }

    func testImagesPublisherForMovieReturnsImages() throws {
        let expectedResult = ImageCollectionDTO(
            id: 1,
            posters: [
                ImageMetadataDTO(filePath: URL(string: "/some/image1")!, width: 100, height: 100),
                ImageMetadataDTO(filePath: URL(string: "/some/image2")!, width: 200, height: 200),
                ImageMetadataDTO(filePath: URL(string: "/some/image3")!, width: 300, height: 300)
            ],
            backdrops: [
                ImageMetadataDTO(filePath: URL(string: "/some/image4")!, width: 400, height: 400),
                ImageMetadataDTO(filePath: URL(string: "/some/image5")!, width: 500, height: 500),
                ImageMetadataDTO(filePath: URL(string: "/some/image6")!, width: 600, height: 600)
            ]
        )
        movieService.images = expectedResult
        let expectedMovieID: MovieDTO.ID = 1

        let result = try await(publisher: tmdb.imagesPublisher(forMovie: expectedMovieID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(movieService.lastImagesMovieID, expectedMovieID)
    }

    func testVideosPublisherForMovieReturnsVideos() throws {
        let expectedResult = VideoCollectionDTO(
            id: 1,
            results: [
                VideoMetadataDTO(
                    id: "1", name: "Name 1",
                    site: "Site 1",
                    key: "key1",
                    type: .teaser,
                    size: .s1080
                ),
                VideoMetadataDTO(
                    id: "2", name: "Name 2",
                    site: "Site 2",
                    key: "key2",
                    type: .teaser,
                    size: .s360
                )
            ]
        )
        movieService.videos = expectedResult
        let expectedMovieID: MovieDTO.ID = 1

        let result = try await(publisher: tmdb.videosPublisher(forMovie: expectedMovieID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(movieService.lastVideosMovieID, expectedMovieID)
    }

    func testRecommendationsPublisherForMovieReturnsMovies() throws {
        let expectedResult = MoviePageableListDTO(
            page: 2,
            results: [
                MovieDTO(id: 1, title: "Title 1"),
                MovieDTO(id: 2, title: "Title 2"),
                MovieDTO(id: 3, title: "Title 3")
            ],
            totalResults: 6,
            totalPages: 2
        )
        movieService.recommendations = expectedResult
        let expectedMovieID: MovieDTO.ID = 1

        let result = try await(publisher: tmdb.recommendationsPublisher(forMovie: expectedMovieID),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(movieService.lastRecommendationsMovieID, expectedMovieID)
        XCTAssertNil(movieService.lastRecommendationsPage)
    }

    func testRecommendationsPublisherForMovieWithPageReturnsMovies() throws {
        let expectedResult = MoviePageableListDTO(
            page: 2,
            results: [
                MovieDTO(id: 1, title: "Title 1"),
                MovieDTO(id: 2, title: "Title 2"),
                MovieDTO(id: 3, title: "Title 3")
            ],
            totalResults: 6,
            totalPages: 2
        )
        movieService.recommendations = expectedResult
        let expectedMovieID: MovieDTO.ID = 1
        let expectedPage = 2

        let result = try await(publisher: tmdb.recommendationsPublisher(forMovie: expectedMovieID, page: expectedPage),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(movieService.lastRecommendationsMovieID, expectedMovieID)
        XCTAssertEqual(movieService.lastRecommendationsPage, expectedPage)
    }

    func testMoviesPublisherSimilarToMovieReturnsMovies() throws {
        let expectedResult = MoviePageableListDTO(
            page: 2,
            results: [
                MovieDTO(id: 1, title: "Title 1"),
                MovieDTO(id: 2, title: "Title 2"),
                MovieDTO(id: 3, title: "Title 3")
            ],
            totalResults: 6,
            totalPages: 2
        )
        movieService.similar = expectedResult
        let expectedMovieID: MovieDTO.ID = 1

        let result = try await(publisher: tmdb.moviesPublisher(similarToMovie: expectedMovieID),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(movieService.lastSimilarMovieID, expectedMovieID)
        XCTAssertNil(movieService.lastSimilarPage)
    }

    func testMoviesPublisherSimilarToMovieWithPageReturnsMovies() throws {
        let expectedResult = MoviePageableListDTO(
            page: 2,
            results: [
                MovieDTO(id: 1, title: "Title 1"),
                MovieDTO(id: 2, title: "Title 2"),
                MovieDTO(id: 3, title: "Title 3")
            ],
            totalResults: 6,
            totalPages: 2
        )
        movieService.similar = expectedResult
        let expectedMovieID: MovieDTO.ID = 1
        let expectedPage = 2

        let result = try await(publisher: tmdb.moviesPublisher(similarToMovie: expectedMovieID, page: expectedPage),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(movieService.lastSimilarMovieID, expectedMovieID)
        XCTAssertEqual(movieService.lastSimilarPage, expectedPage)
    }

    func testPopularMoviesPublisherReturnsMovies() throws {
        let expectedResult = MoviePageableListDTO(
            page: 2,
            results: [
                MovieDTO(id: 1, title: "Title 1"),
                MovieDTO(id: 2, title: "Title 2"),
                MovieDTO(id: 3, title: "Title 3")
            ],
            totalResults: 6,
            totalPages: 2
        )
        movieService.popular = expectedResult

        let result = try await(publisher: tmdb.popularMoviesPublisher(), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertNil(movieService.lastPopularPage)
    }

    func testPopularMoviesPublisherWithPageReturnsMovies() throws {
        let expectedResult = MoviePageableListDTO(
            page: 2,
            results: [
                MovieDTO(id: 1, title: "Title 1"),
                MovieDTO(id: 2, title: "Title 2"),
                MovieDTO(id: 3, title: "Title 3")
            ],
            totalResults: 6,
            totalPages: 2
        )
        movieService.popular = expectedResult
        let expectedPage = 2

        let result = try await(publisher: tmdb.popularMoviesPublisher(page: expectedPage), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(movieService.lastPopularPage, expectedPage)
    }

}
