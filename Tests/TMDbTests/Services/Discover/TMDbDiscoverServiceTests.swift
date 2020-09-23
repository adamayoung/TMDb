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
        let expectedResult = MoviePageableListDTO(
            page: 1,
            results: [
                MovieDTO(id: 1, title: "Movie 1"),
                MovieDTO(id: 2, title: "Movie 2"),
                MovieDTO(id: 3, title: "Movie 3")
            ],
            totalResults: 3,
            totalPages: 1
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchMovies(sortBy: nil, withPeople: nil, page: nil),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.movies().url)
    }

    func testFetchMoviesWithSortByReturnsMovies() throws {
        let sortBy = MovieSortBy.originalTitleAscending
        let expectedResult = MoviePageableListDTO(
            page: 1,
            results: [
                MovieDTO(id: 1, title: "Movie 1"),
                MovieDTO(id: 2, title: "Movie 2"),
                MovieDTO(id: 3, title: "Movie 3")
            ],
            totalResults: 3,
            totalPages: 1
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchMovies(sortBy: sortBy, withPeople: nil, page: nil),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.movies(sortBy: sortBy).url)
    }

    func testFetchMoviesWithWithPeopleReturnsMovies() throws {
        let people = [1, 2, 3, 4, 5]
        let expectedResult = MoviePageableListDTO(
            page: 1,
            results: [
                MovieDTO(id: 1, title: "Movie 1"),
                MovieDTO(id: 2, title: "Movie 2"),
                MovieDTO(id: 3, title: "Movie 3")
            ],
            totalResults: 3,
            totalPages: 1
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchMovies(sortBy: nil, withPeople: people, page: nil),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.movies(withPeople: people).url)
    }

    func testFetchMoviesWithWithPageReturnsMovies() throws {
        let page = 2
        let expectedResult = MoviePageableListDTO(
            page: page,
            results: [
                MovieDTO(id: 4, title: "Movie 4"),
                MovieDTO(id: 5, title: "Movie 5"),
                MovieDTO(id: 6, title: "Movie 6")
            ],
            totalResults: 6,
            totalPages: 2
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchMovies(sortBy: nil, withPeople: nil, page: page),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.movies(page: page).url)
    }

    func testFetchMoviesWithSortByAndWithPeopleAndPageReturnsMovies() throws {
        let sortBy = MovieSortBy.originalTitleAscending
        let people = [1, 2, 3, 4, 5]
        let page = 3
        let expectedResult = MoviePageableListDTO(
            page: page,
            results: [
                MovieDTO(id: 7, title: "Movie 7"),
                MovieDTO(id: 8, title: "Movie 8"),
                MovieDTO(id: 9, title: "Movie 9")
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
        let expectedResult = TVShowPageableListDTO(
            page: 1,
            results: [
                TVShowDTO(id: 1, name: "TV Show 1"),
                TVShowDTO(id: 2, name: "TV Show 2"),
                TVShowDTO(id: 3, name: "TV Show 3")
            ],
            totalResults: 3,
            totalPages: 1
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchTVShows(sortBy: nil, page: nil), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.tvShows().url)
    }

    func testFetchTVShowsWithSortByReturnsTVShows() throws {
        let sortBy = TVShowSortBy.firstAirDateAscending
        let expectedResult = TVShowPageableListDTO(
            page: 1,
            results: [
                TVShowDTO(id: 1, name: "TV Show 1"),
                TVShowDTO(id: 2, name: "TV Show 2"),
                TVShowDTO(id: 3, name: "TV Show 3")
            ],
            totalResults: 3,
            totalPages: 1
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchTVShows(sortBy: sortBy, page: nil), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.tvShows(sortBy: sortBy).url)
    }

    func testFetchTVShowsWithPageReturnsTVShows() throws {
        let page = 2
        let expectedResult = TVShowPageableListDTO(
            page: page,
            results: [
                TVShowDTO(id: 4, name: "TV Show 4"),
                TVShowDTO(id: 5, name: "TV Show 5"),
                TVShowDTO(id: 6, name: "TV Show 6")
            ],
            totalResults: 6,
            totalPages: 2
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchTVShows(sortBy: nil, page: page), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.tvShows(page: page).url)
    }

    func testFetchTVShowsWithSortByAndPageReturnsTVShows() throws {
        let sortBy = TVShowSortBy.firstAirDateAscending
        let page = 3
        let expectedResult = TVShowPageableListDTO(
            page: page,
            results: [
                TVShowDTO(id: 7, name: "TV Show 7"),
                TVShowDTO(id: 8, name: "TV Show 8"),
                TVShowDTO(id: 9, name: "TV Show 9")
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
