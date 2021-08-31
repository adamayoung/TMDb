#if canImport(Combine)
import Combine
@testable import TMDb
import XCTest

final class TMDbDiscoverServiceCombineTests: XCTestCase {

    var cancellables: Set<AnyCancellable> = []
    var service: TMDbDiscoverService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        service = TMDbDiscoverService(apiClient: apiClient)
    }

    override func tearDown() {
        apiClient = nil
        service = nil
        super.tearDown()
    }

    func testMoviesPublisherWithDefaultParametersReturnsMovies() throws {
        let expectedResult = MoviePageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try waitFor(publisher: service.moviesPublisher(), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.movies().url)
    }

    func testMoviesPublisherReturnsMovies() throws {
        let expectedResult = MoviePageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try waitFor(publisher: service.moviesPublisher(sortedBy: nil, withPeople: nil, page: nil),
                                 storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.movies().url)
    }

    func testMoviesPublisherWithSortByReturnsMovies() throws {
        let sortBy = MovieSort.originalTitle(descending: false)
        let expectedResult = MoviePageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try waitFor(publisher: service.moviesPublisher(sortedBy: sortBy, withPeople: nil, page: nil),
                                 storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.movies(sortedBy: sortBy).url)
    }

    func testMoviesPublisherWithWithPeopleReturnsMovies() throws {
        let people: [Int] = [.randomID, .randomID, .randomID, .randomID, .randomID]
        let expectedResult = MoviePageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try waitFor(publisher: service.moviesPublisher(sortedBy: nil, withPeople: people, page: nil),
                                 storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.movies(people: people).url)
    }

    func testMoviesPublisherWithWithPageReturnsMovies() throws {
        let expectedResult = MoviePageableList.mock
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try waitFor(publisher: service.moviesPublisher(sortedBy: nil, withPeople: nil, page: page),
                                 storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.movies(page: page).url)
    }

    func testMoviesPublisherWithSortByAndWithPeopleAndPageReturnsMovies() throws {
        let sortBy = MovieSort.originalTitle(descending: false)
        let people: [Int] = [.randomID, .randomID, .randomID, .randomID, .randomID]
        let expectedResult = MoviePageableList.mock
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try waitFor(publisher: service.moviesPublisher(sortedBy: sortBy, withPeople: people, page: page),
                                 storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.movies(sortedBy: sortBy, people: people, page: page).url)
    }

    func testTVShowsPublisherWithDefaultParametersReturnsTVShows() throws {
        let expectedResult = TVShowPageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try waitFor(publisher: service.tvShowsPublisher(), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.tvShows().url)
    }

    func testTVShowsPublisherReturnsTVShows() throws {
        let expectedResult = TVShowPageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try waitFor(publisher: service.tvShowsPublisher(sortedBy: nil, page: nil), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.tvShows().url)
    }

    func testTVShowsPublisherWithSortByReturnsTVShows() throws {
        let sortBy = TVShowSort.firstAirDate(descending: false)
        let expectedResult = TVShowPageableList.mock
        apiClient.result = .success(expectedResult)

        let result = try waitFor(publisher: service.tvShowsPublisher(sortedBy: sortBy, page: nil),
                                 storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.tvShows(sortedBy: sortBy).url)
    }

    func testTVShowsPublisherWithPageReturnsTVShows() throws {
        let expectedResult = TVShowPageableList.mock
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try waitFor(publisher: service.tvShowsPublisher(sortedBy: nil, page: page), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.tvShows(page: page).url)
    }

    func testTVShowsPublisherWithSortByAndPageReturnsTVShows() throws {
        let sortBy = TVShowSort.firstAirDate(descending: false)
        let expectedResult = TVShowPageableList.mock
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let result = try waitFor(publisher: service.tvShowsPublisher(sortedBy: sortBy, page: page),
                                 storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.tvShows(sortedBy: sortBy, page: page).url)
    }

}
#endif
