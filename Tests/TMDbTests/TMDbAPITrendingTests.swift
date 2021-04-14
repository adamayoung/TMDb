import Combine
@testable import TMDb
import XCTest

class TMDbAPITrendingTests: TMDbAPITestCase {

    func testTrendingMoviesPublisherReturnsMovies() throws {
        let expectedResult = MoviePageableList(
            page: 2,
            results: [
                Movie(id: 1, title: "Title 1"),
                Movie(id: 2, title: "Title 2"),
                Movie(id: 3, title: "Title 3")
            ],
            totalResults: 6,
            totalPages: 2
        )
        trendingService.movies = expectedResult
        let expectedTimeWindow: TrendingTimeWindowFilterType = .default

        let result = try await(publisher: tmdb.trendingMoviesPublisher(), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(trendingService.lastMoviesTimeWindow, expectedTimeWindow)
        XCTAssertNil(trendingService.lastMoviesPage)
    }

    func testTrendingMoviesPublisherWithTimeWindowReturnsMovies() throws {
        let expectedResult = MoviePageableList(
            page: 2,
            results: [
                Movie(id: 1, title: "Title 1"),
                Movie(id: 2, title: "Title 2"),
                Movie(id: 3, title: "Title 3")
            ],
            totalResults: 6,
            totalPages: 2
        )
        trendingService.movies = expectedResult
        let expectedTimeWindow: TrendingTimeWindowFilterType = .week

        let result = try await(publisher: tmdb.trendingMoviesPublisher(inTimeWindow: expectedTimeWindow),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(trendingService.lastMoviesTimeWindow, expectedTimeWindow)
        XCTAssertNil(trendingService.lastMoviesPage)
    }

    func testTrendingMoviesPublisherWithPageReturnsMovies() throws {
        let expectedResult = MoviePageableList(
            page: 2,
            results: [
                Movie(id: 1, title: "Title 1"),
                Movie(id: 2, title: "Title 2"),
                Movie(id: 3, title: "Title 3")
            ],
            totalResults: 6,
            totalPages: 2
        )
        trendingService.movies = expectedResult
        let expectedTimeWindow: TrendingTimeWindowFilterType = .default
        let expectedPage = 2

        let result = try await(publisher: tmdb.trendingMoviesPublisher(page: expectedPage), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(trendingService.lastMoviesTimeWindow, expectedTimeWindow)
        XCTAssertEqual(trendingService.lastMoviesPage, expectedPage)
    }

    func testTrendingMoviesPublisherWithTimeWindowPageReturnsMovies() throws {
        let expectedResult = MoviePageableList(
            page: 2,
            results: [
                Movie(id: 1, title: "Title 1"),
                Movie(id: 2, title: "Title 2"),
                Movie(id: 3, title: "Title 3")
            ],
            totalResults: 6,
            totalPages: 2
        )
        trendingService.movies = expectedResult
        let expectedTimeWindow: TrendingTimeWindowFilterType = .week
        let expectedPage = 2

        let result = try await(publisher: tmdb.trendingMoviesPublisher(inTimeWindow: expectedTimeWindow,
                                                                       page: expectedPage),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(trendingService.lastMoviesTimeWindow, expectedTimeWindow)
        XCTAssertEqual(trendingService.lastMoviesPage, expectedPage)
    }

}

extension TMDbAPITrendingTests {

    func testTrendingTVShowsPublisherReturnsTVShows() throws {
        let expectedResult = TVShowPageableList(
            page: 2,
            results: [
                TVShow(id: 1, name: "Name 1"),
                TVShow(id: 2, name: "Name 2"),
                TVShow(id: 3, name: "Name 3")
            ],
            totalResults: 6,
            totalPages: 2
        )
        trendingService.tvShows = expectedResult
        let expectedTimeWindow: TrendingTimeWindowFilterType = .default

        let result = try await(publisher: tmdb.trendingTVShowsPublisher(), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(trendingService.lastTVShowsTimeWindow, expectedTimeWindow)
        XCTAssertNil(trendingService.lastTVShowsPage)
    }

    func testTrendingTVShowsPublisherWithTimeWindowReturnsTVShows() throws {
        let expectedResult = TVShowPageableList(
            page: 2,
            results: [
                TVShow(id: 1, name: "Name 1"),
                TVShow(id: 2, name: "Name 2"),
                TVShow(id: 3, name: "Name 3")
            ],
            totalResults: 6,
            totalPages: 2
        )
        trendingService.tvShows = expectedResult
        let expectedTimeWindow: TrendingTimeWindowFilterType = .week

        let result = try await(publisher: tmdb.trendingTVShowsPublisher(inTimeWindow: expectedTimeWindow),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(trendingService.lastTVShowsTimeWindow, expectedTimeWindow)
        XCTAssertNil(trendingService.lastTVShowsPage)
    }

    func testTrendingTVShowsPublisherWithPageReturnsTVShows() throws {
        let expectedResult = TVShowPageableList(
            page: 2,
            results: [
                TVShow(id: 1, name: "Name 1"),
                TVShow(id: 2, name: "Name 2"),
                TVShow(id: 3, name: "Name 3")
            ],
            totalResults: 6,
            totalPages: 2
        )
        trendingService.tvShows = expectedResult
        let expectedTimeWindow: TrendingTimeWindowFilterType = .default
        let expectedPage = 2

        let result = try await(publisher: tmdb.trendingTVShowsPublisher(page: expectedPage), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(trendingService.lastTVShowsTimeWindow, expectedTimeWindow)
        XCTAssertEqual(trendingService.lastTVShowsPage, expectedPage)
    }

    func testTrendingTVShowsPublisherWithTimeWindowPageReturnsTVShows() throws {
        let expectedResult = TVShowPageableList(
            page: 2,
            results: [
                TVShow(id: 1, name: "Name 1"),
                TVShow(id: 2, name: "Name 2"),
                TVShow(id: 3, name: "Name 3")
            ],
            totalResults: 6,
            totalPages: 2
        )
        trendingService.tvShows = expectedResult
        let expectedTimeWindow: TrendingTimeWindowFilterType = .week
        let expectedPage = 2

        let result = try await(
            publisher: tmdb.trendingTVShowsPublisher(inTimeWindow: expectedTimeWindow, page: expectedPage),
            storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(trendingService.lastTVShowsTimeWindow, expectedTimeWindow)
        XCTAssertEqual(trendingService.lastTVShowsPage, expectedPage)
    }

}

extension TMDbAPITrendingTests {

    func testTrendingPeoplePublisherReturnsPeople() throws {
        let expectedResult = PersonPageableList(
            page: 2,
            results: [
                Person(id: 1, name: "Name 1"),
                Person(id: 2, name: "Name 1"),
                Person(id: 3, name: "Name 3")
            ],
            totalResults: 6,
            totalPages: 2
        )
        trendingService.people = expectedResult
        let expectedTimeWindow: TrendingTimeWindowFilterType = .default

        let result = try await(publisher: tmdb.trendingPeoplePublisher(), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(trendingService.lastPeopleTimeWindow, expectedTimeWindow)
        XCTAssertNil(trendingService.lastPeoplePage)
    }

    func testTrendingPeoplePublisherWithTimeWindowReturnsPeople() throws {
        let expectedResult = PersonPageableList(
            page: 2,
            results: [
                Person(id: 1, name: "Name 1"),
                Person(id: 2, name: "Name 1"),
                Person(id: 3, name: "Name 3")
            ],
            totalResults: 6,
            totalPages: 2
        )
        trendingService.people = expectedResult
        let expectedTimeWindow: TrendingTimeWindowFilterType = .week

        let result = try await(publisher: tmdb.trendingPeoplePublisher(inTimeWindow: expectedTimeWindow),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(trendingService.lastPeopleTimeWindow, expectedTimeWindow)
        XCTAssertNil(trendingService.lastPeoplePage)
    }

    func testTrendingPeoplePublisherWithPageReturnsPeople() throws {
        let expectedResult = PersonPageableList(
            page: 2,
            results: [
                Person(id: 1, name: "Name 1"),
                Person(id: 2, name: "Name 1"),
                Person(id: 3, name: "Name 3")
            ],
            totalResults: 6,
            totalPages: 2
        )
        trendingService.people = expectedResult
        let expectedTimeWindow: TrendingTimeWindowFilterType = .default
        let expectedPage = 2

        let result = try await(publisher: tmdb.trendingPeoplePublisher(page: expectedPage), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(trendingService.lastPeopleTimeWindow, expectedTimeWindow)
        XCTAssertEqual(trendingService.lastPeoplePage, expectedPage)
    }

    func testTrendingPeoplePublisherWithTimeWindowPageReturnsPeople() throws {
        let expectedResult = PersonPageableList(
            page: 2,
            results: [
                Person(id: 1, name: "Name 1"),
                Person(id: 2, name: "Name 1"),
                Person(id: 3, name: "Name 3")
            ],
            totalResults: 6,
            totalPages: 2
        )
        trendingService.people = expectedResult
        let expectedTimeWindow: TrendingTimeWindowFilterType = .week
        let expectedPage = 2

        let result = try await(
            publisher: tmdb.trendingPeoplePublisher(inTimeWindow: expectedTimeWindow, page: expectedPage),
            storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(trendingService.lastPeopleTimeWindow, expectedTimeWindow)
        XCTAssertEqual(trendingService.lastPeoplePage, expectedPage)
    }

}
