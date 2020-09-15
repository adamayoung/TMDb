import Combine
@testable import TMDb
import XCTest

class TMDbDiscoverServiceTests: XCTestCase {

    var cancellables: Set<AnyCancellable> = []
    var service: TMDbDiscoverService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()

        apiClient = MockAPIClient()
        service = TMDbDiscoverService(apiClient: apiClient)
    }

    override func tearDown() {
        apiClient.reset()

        super.tearDown()
    }

    func testFetchMoviesReturnsMovies() throws {
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

        let result = try await(publisher: service.fetchMovies(), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.movies().url)
    }

    func testFetchMoviesWithSortByReturnsMovies() throws {
        let sortBy = MovieSortBy.originalTitleAscending
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

        let result = try await(publisher: service.fetchMovies(sortBy: sortBy), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.movies(sortBy: sortBy).url)
    }

    func testFetchMoviesWithWithPeopleReturnsMovies() throws {
        let people = [1, 2, 3, 4, 5]
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

        let result = try await(publisher: service.fetchMovies(withPeople: people), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.movies(withPeople: people).url)
    }

    func testFetchMoviesWithWithPageReturnsMovies() throws {
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

        let result = try await(publisher: service.fetchMovies(page: page), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.movies(page: page).url)
    }

    func testFetchMoviesWithSortByAndWithPeopleAndPageReturnsMovies() throws {
        let sortBy = MovieSortBy.originalTitleAscending
        let people = [1, 2, 3, 4, 5]
        let page = 3
        let expectedResult = MoviePageableList(
            page: page,
            results: [
                Movie(id: 7, title: "Movie 7"),
                Movie(id: 8, title: "Movie 8"),
                Movie(id: 9, title: "Movie 9")
            ],
            totalResults: 3,
            totalPages: 3
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchMovies(sortBy: sortBy, withPeople: people, page: page),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.movies(sortBy: sortBy, withPeople: people, page: page).url)
    }

    func testFetchTVShowsReturnsTVShows() throws {
        let expectedResult = TVShowPageableList(
            page: 1,
            results: [
                TVShow(id: 1, name: "TV Show 1"),
                TVShow(id: 2, name: "TV Show 2"),
                TVShow(id: 3, name: "TV Show 3")
            ],
            totalResults: 3,
            totalPages: 1
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchTVShows(), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.tvShows().url)
    }

    func testFetchTVShowsWithSortByReturnsTVShows() throws {
        let sortBy = TVShowSortBy.firstAirDateAscending
        let expectedResult = TVShowPageableList(
            page: 1,
            results: [
                TVShow(id: 1, name: "TV Show 1"),
                TVShow(id: 2, name: "TV Show 2"),
                TVShow(id: 3, name: "TV Show 3")
            ],
            totalResults: 3,
            totalPages: 1
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchTVShows(sortBy: sortBy), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.tvShows(sortBy: sortBy).url)
    }

    func testFetchTVShowsWithPageReturnsTVShows() throws {
        let page = 2
        let expectedResult = TVShowPageableList(
            page: page,
            results: [
                TVShow(id: 4, name: "TV Show 4"),
                TVShow(id: 5, name: "TV Show 5"),
                TVShow(id: 6, name: "TV Show 6")
            ],
            totalResults: 6,
            totalPages: 2
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchTVShows(page: page), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.tvShows(page: page).url)
    }

    func testFetchTVShowsWithSortByAndPageReturnsTVShows() throws {
        let sortBy = TVShowSortBy.firstAirDateAscending
        let page = 3
        let expectedResult = TVShowPageableList(
            page: page,
            results: [
                TVShow(id: 7, name: "TV Show 7"),
                TVShow(id: 8, name: "TV Show 8"),
                TVShow(id: 9, name: "TV Show 9")
            ],
            totalResults: 9,
            totalPages: 3
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchTVShows(sortBy: sortBy, page: page), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.tvShows(sortBy: sortBy, page: page).url)
    }

}
