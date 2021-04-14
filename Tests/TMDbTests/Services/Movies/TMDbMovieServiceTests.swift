import Combine
@testable import TMDb
import XCTest

class TMDbMovieServiceTests: XCTestCase {

    var cancellables: Set<AnyCancellable> = []
    var service: TMDbMovieService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()

        apiClient = MockAPIClient()
        service = TMDbMovieService(apiClient: apiClient)
    }

    override func tearDown() {
        apiClient.reset()

        super.tearDown()
    }

    func testFetchDetailsReturnsMovie() throws {
        let movieID = 1
        let expectedResult = Movie(id: movieID, title: "Some title")
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchDetails(forMovie: movieID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.details(movieID: movieID).url)
    }

    func testFetchCreditsReturnsCredits() throws {
        let movieID = 1
        let expectedResult = ShowCredits(
            id: movieID,
            cast: [CastMember(id: 2, creditID: "a", name: "Cast 1", character: "Character 1", order: 1)],
            crew: [CrewMember(id: 3, creditID: "b", name: "Crew 1", job: "Job 1", department: "Department 1")]
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchCredits(forMovie: movieID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.credits(movieID: movieID).url)
    }

    func testFetchReviewsReturnsReviews() throws {
        let movieID = 1
        let expectedResult = ReviewPageableList(
            page: 1,
            results: [
                Review(id: "1", author: "Author 1", content: "Some content 1"),
                Review(id: "2", author: "Author 2", content: "Some content 2"),
                Review(id: "3", author: "Author 3", content: "Some content 3")
            ],
            totalResults: 3,
            totalPages: 1
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchReviews(forMovie: movieID, page: nil), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.reviews(movieID: movieID).url)
    }

    func testFetchReviewsWithPageReturnsReviews() throws {
        let movieID = 1
        let page = 2
        let expectedResult = ReviewPageableList(
            page: page,
            results: [
                Review(id: "4", author: "Author 4", content: "Some content 4"),
                Review(id: "5", author: "Author 5", content: "Some content 5"),
                Review(id: "6", author: "Author 6", content: "Some content 6")
            ],
            totalResults: 6,
            totalPages: 2
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchReviews(forMovie: movieID, page: page), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.reviews(movieID: movieID, page: page).url)
    }

    func testFetchImagesReturnsImageCollection() throws {
        let movieID = 1
        let expectedResult = ImageCollection(
            id: movieID,
            posters: [ImageMetadata(filePath: URL(string: "/poster.jog")!, width: 10, height: 20)],
            backdrops: [ImageMetadata(filePath: URL(string: "/backgrop.jog")!, width: 50, height: 100)]
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchImages(forMovie: movieID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.images(movieID: movieID).url)
    }

    func testFetchVideosReturnsVideoCollection() throws {
        let movieID = 1
        let expectedResult = VideoCollection(
            id: movieID,
            results: [
                VideoMetadata(
                    id: "2",
                    name: "Video",
                    site: "YouTube",
                    key: "abc123",
                    type: .trailer,
                    size: .s1080
                )
            ]
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchVideos(forMovie: movieID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.videos(movieID: movieID).url)
    }

    func testFetchRecommendationsReturnsMovies() throws {
        let movieID = 1
        let expectedResult = MoviePageableList(
            page: 1,
            results: [
                Movie(id: 1, title: "Movie 1"),
                Movie(id: 2, title: "Movie 2"),
                Movie(id: 3, title: "Movie 3")
            ],
            totalResults: 3,
            totalPages: 1
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchRecommendations(forMovie: movieID, page: nil),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.recommendations(movieID: movieID).url)
    }

    func testFetchRecommendationsWithPageReturnsMovies() throws {
        let movieID = 1
        let page = 2
        let expectedResult = MoviePageableList(
            page: page,
            results: [
                Movie(id: 4, title: "Movie 4"),
                Movie(id: 5, title: "Movie 5"),
                Movie(id: 6, title: "Movie 6")
            ],
            totalResults: 6,
            totalPages: 2
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchRecommendations(forMovie: movieID, page: page),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.recommendations(movieID: movieID, page: page).url)
    }

    func testFetchSimilarReturnsMovies() throws {
        let movieID = 1
        let expectedResult = MoviePageableList(
            page: 1,
            results: [
                Movie(id: 1, title: "Movie 1"),
                Movie(id: 2, title: "Movie 2"),
                Movie(id: 3, title: "Movie 3")
            ],
            totalResults: 3,
            totalPages: 1
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchSimilar(toMovie: movieID, page: nil), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.similar(movieID: movieID).url)
    }

    func testFetchSimilarWithPageReturnsMovies() throws {
        let movieID = 1
        let page = 2
        let expectedResult = MoviePageableList(
            page: page,
            results: [
                Movie(id: 4, title: "Movie 4"),
                Movie(id: 5, title: "Movie 5"),
                Movie(id: 6, title: "Movie 6")
            ],
            totalResults: 6,
            totalPages: 2
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchSimilar(toMovie: movieID, page: page), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.similar(movieID: movieID, page: page).url)
    }

    func testFetchPopularReturnsMovies() throws {
        let expectedResult = MoviePageableList(
            page: 1,
            results: [
                Movie(id: 1, title: "Movie 1"),
                Movie(id: 2, title: "Movie 2"),
                Movie(id: 3, title: "Movie 3")
            ],
            totalResults: 3,
            totalPages: 1
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchPopular(page: nil), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.popular().url)
    }

    func testFetchPopularWithPageReturnsMovies() throws {
        let page = 2
        let expectedResult = MoviePageableList(
            page: page,
            results: [
                Movie(id: 4, title: "Movie 4"),
                Movie(id: 5, title: "Movie 5"),
                Movie(id: 6, title: "Movie 6")
            ],
            totalResults: 6,
            totalPages: 2
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchPopular(page: page), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, MoviesEndpoint.popular(page: page).url)
    }

}
