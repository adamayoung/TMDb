@testable import TMDb
import XCTest

final class TMDbPersonServiceTests: XCTestCase {

    var service: TMDbPersonService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        service = TMDbPersonService(apiClient: apiClient)
    }

    override func tearDown() {
        apiClient = nil
        service = nil
        super.tearDown()
    }

    func testFetchDetailsReturnsPerson() throws {
        let expectedResult = Person.mock
        let personID = expectedResult.id
        apiClient.result = .success(expectedResult)

        let expectation = XCTestExpectation(description: "await")
        service.fetchDetails(forPerson: personID) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, PeopleEndpoint.details(personID: personID).url)
    }

    func testFetchCombinedCreditsReturnsCombinedCredits() throws {
        let mock = PersonCombinedCredits.mock
        let expectedResult = PersonCombinedCredits(id: mock.id, cast: mock.cast.sorted(), crew: mock.crew.sorted())
        let personID = expectedResult.id
        apiClient.result = .success(expectedResult)

        let expectation = XCTestExpectation(description: "await")
        service.fetchCombinedCredits(forPerson: personID) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, PeopleEndpoint.combinedCredits(personID: personID).url)
    }

    func testFetchMovieCreditsPublisherReturnsMovieCredits() throws {
        let mock = PersonMovieCredits.mock
        let expectedResult = PersonMovieCredits(id: mock.id, cast: mock.cast.sorted(), crew: mock.crew.sorted())
        let personID = expectedResult.id
        apiClient.result = .success(expectedResult)

        let expectation = XCTestExpectation(description: "await")
        service.fetchMovieCredits(forPerson: personID) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, PeopleEndpoint.movieCredits(personID: personID).url)
    }

    func testFetchTVShowCreditsReturnsTVShowCredits() throws {
        let mock = PersonTVShowCredits.mock
        let expectedResult = PersonTVShowCredits(id: mock.id, cast: mock.cast.sorted(), crew: mock.crew.sorted())
        let personID = expectedResult.id
        apiClient.result = .success(expectedResult)

        let expectation = XCTestExpectation(description: "await")
        service.fetchTVShowCredits(forPerson: personID) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, PeopleEndpoint.tvShowCredits(personID: personID).url)
    }

    func testFetchImagesReturnsImageCollection() throws {
        let expectedResult = PersonImageCollection.mock
        let personID = expectedResult.id
        apiClient.result = .success(expectedResult)

        let expectation = XCTestExpectation(description: "await")
        service.fetchImages(forPerson: personID) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, PeopleEndpoint.images(personID: personID).url)
    }

    func testFetchKnownForReturnsShows() throws {
        let credits = PersonCombinedCredits.mock
        let personID = credits.id
        apiClient.result = .success(credits)
        let topCastShows = Array(credits.cast.sorted().prefix(10))
        let topCrewShows = Array(credits.crew.sorted().prefix(10))
        var topShows = topCastShows + topCrewShows
        topShows = topShows.reduce([], { shows, show in
            var shows = shows
            if !shows.contains(where: { $0.id == show.id }) {
                shows.append(show)
            }

            return shows
        })

        topShows.sort { $0.popularity ?? 0 > $1.popularity ?? 0 }

        let expectedResult = Array(topShows.prefix(10))

        let expectation = XCTestExpectation(description: "await")
        service.fetchKnownFor(forPerson: personID) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, PeopleEndpoint.combinedCredits(personID: personID).url)
    }

    func testFetchPopularWithDefaultParametersReturnsPeople() throws {
        let expectedResult = PersonPageableList.mock
        apiClient.result = .success(expectedResult)

        let expectation = XCTestExpectation(description: "await")
        service.fetchPopular { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, PeopleEndpoint.popular().url)
    }

    func testFetchPopularReturnsPeople() throws {
        let expectedResult = PersonPageableList.mock
        apiClient.result = .success(expectedResult)

        let expectation = XCTestExpectation(description: "await")
        service.fetchPopular(page: nil) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, PeopleEndpoint.popular().url)
    }

    func testFetchPopularWithPageReturnsPeople() throws {
        let expectedResult = PersonPageableList.mock
        let page = expectedResult.page
        apiClient.result = .success(expectedResult)

        let expectation = XCTestExpectation(description: "await")
        service.fetchPopular(page: page) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, PeopleEndpoint.popular(page: page).url)
    }

}
