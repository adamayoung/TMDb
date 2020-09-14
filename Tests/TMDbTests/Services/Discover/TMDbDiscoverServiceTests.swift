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

    func testFetchMoviesReturnsMovies() {
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

        let finished = XCTestExpectation(description: "finished")
        service.fetchMovies()
            .sink(receiveCompletion: { result in
                switch result {
                case .failure:
                    XCTFail("Should not have failed")

                default:
                    break
                }
            }, receiveValue: { result in
                XCTAssertEqual(result, expectedResult)
                finished.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [finished], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.movies().url)
    }

    func testFetchTVShowsReturnsTVShows() {
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

        let finished = XCTestExpectation(description: "finished")
        service.fetchTVShows()
            .sink(receiveCompletion: { result in
                switch result {
                case .failure:
                    XCTFail("Should not have failed")

                default:
                    break
                }
            }, receiveValue: { result in
                XCTAssertEqual(result, expectedResult)
                finished.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [finished], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, DiscoverEndpoint.tvShows().url)
    }

}
