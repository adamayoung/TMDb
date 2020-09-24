import Combine
@testable import TMDb
import XCTest

class TMDbAPIDiscoverTests: TMDbAPITestCase {

    func testDiscoverMoviesPublisherReturnsMovies() throws {
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
        discoverService.movies = expectedResult

        let result = try await(publisher: tmdb.discoverMoviesPublisher(), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(discoverService.lastMoviesSortBy, .default)
        XCTAssertNil(discoverService.lastMoviesWithPeople)
        XCTAssertNil(discoverService.lastMoviesPage)
    }

    func testDiscoverMoviesPublisherWithSortByReturnsMovies() throws {
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
        discoverService.movies = expectedResult
        let expectedSortBy = MovieSortBy.popularityAscending

        let result = try await(publisher: tmdb.discoverMoviesPublisher(sortBy: expectedSortBy),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(discoverService.lastMoviesSortBy, expectedSortBy)
        XCTAssertNil(discoverService.lastMoviesWithPeople)
        XCTAssertNil(discoverService.lastMoviesPage)
    }

    func testDiscoverMoviesPublisherWithPeopleReturnsMovies() throws {
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
        discoverService.movies = expectedResult
        let expectedWithPeople: [PersonDTO.ID] = [1, 2, 3]

        let result = try await(publisher: tmdb.discoverMoviesPublisher(withPeople: expectedWithPeople),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(discoverService.lastMoviesSortBy, .default)
        XCTAssertEqual(discoverService.lastMoviesWithPeople, expectedWithPeople)
        XCTAssertNil(discoverService.lastMoviesPage)
    }

    func testDiscoverMoviesPublisherWithPageReturnsMovies() throws {
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
        discoverService.movies = expectedResult
        let expectedPage = 2

        let result = try await(publisher: tmdb.discoverMoviesPublisher(page: expectedPage),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(discoverService.lastMoviesSortBy, .default)
        XCTAssertNil(discoverService.lastMoviesWithPeople)
        XCTAssertEqual(discoverService.lastMoviesPage, expectedPage)
    }

    func testDiscoverMoviesPublisherWithSortByWithPeoplePageReturnsMovies() throws {
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
        discoverService.movies = expectedResult
        let expectedSortBy = MovieSortBy.popularityAscending
        let expectedWithPeople: [PersonDTO.ID] = [1, 2, 3]
        let expectedPage = 2

        let result = try await(
            publisher: tmdb.discoverMoviesPublisher(sortBy: expectedSortBy,
                                                    withPeople: expectedWithPeople,
                                                    page: expectedPage),
            storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(discoverService.lastMoviesSortBy, expectedSortBy)
        XCTAssertEqual(discoverService.lastMoviesWithPeople, expectedWithPeople)
        XCTAssertEqual(discoverService.lastMoviesPage, expectedPage)
    }

}

extension TMDbAPIDiscoverTests {

    func testDiscoverTVShowsPublisherReturnsTVShows() throws {
        let expectedResult = TVShowPageableListDTO(
            page: 2,
            results: [
                TVShowDTO(id: 1, name: "Title 1"),
                TVShowDTO(id: 2, name: "Title 2"),
                TVShowDTO(id: 3, name: "Title 3")
            ],
            totalResults: 6,
            totalPages: 2
        )
        discoverService.tvShows = expectedResult

        let result = try await(publisher: tmdb.discoverTVShowsPublisher(), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(discoverService.lastTVShowsSortBy, .default)
        XCTAssertNil(discoverService.lastTVShowsPage)
    }

    func testDiscoverTVShowsPublisherWithSortByReturnsTVShows() throws {
        let expectedResult = TVShowPageableListDTO(
            page: 2,
            results: [
                TVShowDTO(id: 1, name: "Title 1"),
                TVShowDTO(id: 2, name: "Title 2"),
                TVShowDTO(id: 3, name: "Title 3")
            ],
            totalResults: 6,
            totalPages: 2
        )
        discoverService.tvShows = expectedResult
        let expectedSortBy = TVShowSortBy.popularityDescending

        let result = try await(publisher: tmdb.discoverTVShowsPublisher(sortBy: expectedSortBy),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(discoverService.lastTVShowsSortBy, expectedSortBy)
        XCTAssertNil(discoverService.lastTVShowsPage)
    }

    func testDiscoverTVShowsPublisherWithPageReturnsTVShows() throws {
        let expectedResult = TVShowPageableListDTO(
            page: 2,
            results: [
                TVShowDTO(id: 1, name: "Title 1"),
                TVShowDTO(id: 2, name: "Title 2"),
                TVShowDTO(id: 3, name: "Title 3")
            ],
            totalResults: 6,
            totalPages: 2
        )
        discoverService.tvShows = expectedResult
        let expectedPage = 2

        let result = try await(publisher: tmdb.discoverTVShowsPublisher(page: expectedPage),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(discoverService.lastTVShowsSortBy, .default)
        XCTAssertEqual(discoverService.lastTVShowsPage, expectedPage)
    }

    func testDiscoverTVShowsPublisherWithSortByPageReturnsTVShows() throws {
        let expectedResult = TVShowPageableListDTO(
            page: 2,
            results: [
                TVShowDTO(id: 1, name: "Title 1"),
                TVShowDTO(id: 2, name: "Title 2"),
                TVShowDTO(id: 3, name: "Title 3")
            ],
            totalResults: 6,
            totalPages: 2
        )
        discoverService.tvShows = expectedResult
        let expectedSortBy = TVShowSortBy.popularityDescending
        let expectedPage = 2

        let result = try await(publisher: tmdb.discoverTVShowsPublisher(sortBy: expectedSortBy, page: expectedPage),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(discoverService.lastTVShowsSortBy, expectedSortBy)
        XCTAssertEqual(discoverService.lastTVShowsPage, expectedPage)
    }

}
