@testable import TMDb
import XCTest

#if canImport(Combine)
import Combine
#endif

class TMDbPersonServiceTests: XCTestCase {

    #if canImport(Combine)
    var cancellables: Set<AnyCancellable> = []
    #endif
    var service: TMDbPersonService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()

        apiClient = MockAPIClient()
        service = TMDbPersonService(apiClient: apiClient)
    }

    override func tearDown() {
        apiClient.reset()

        super.tearDown()
    }

    func testFetchDetailsReturnsPerson() throws {
        let expectedResult = Person.mock
        let personID = expectedResult.id
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchDetails(forPerson: personID) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, PeopleEndpoint.details(personID: personID).url)
    }

    func testFetchCombinedCreditsReturnsCombinedCredits() throws {
        let expectedResult = PersonCombinedCredits.mock
        let personID = expectedResult.id
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchCombinedCredits(forPerson: personID) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, PeopleEndpoint.combinedCredits(personID: personID).url)
    }

    func testFetchMovieCreditsPublisherReturnsMovieCredits() throws {
        let expectedResult = PersonMovieCredits.mock
        let personID = expectedResult.id
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchMovieCredits(forPerson: personID) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, PeopleEndpoint.movieCredits(personID: personID).url)
    }

    func testFetchTVShowCreditsReturnsTVShowCredits() throws {
        let expectedResult = PersonTVShowCredits.mock
        let personID = expectedResult.id
        apiClient.response = expectedResult

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
        apiClient.response = expectedResult

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
        apiClient.response = credits
        let topCastShows = Array(credits.cast.prefix(10))
        let topCrewShows = Array(credits.crew.prefix(10))
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

    func testFetchPopularReturnsPeople() throws {
        let expectedResult = PersonPageableList.mock
        apiClient.response = expectedResult

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
        apiClient.response = expectedResult

        let expectation = XCTestExpectation(description: "await")
        service.fetchPopular(page: page) { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, PeopleEndpoint.popular(page: page).url)
    }

}

#if canImport(Combine)
extension TMDbPersonServiceTests {

    func testDetailsPublisherReturnsPerson() throws {
        let expectedResult = Person.mock
        let personID = expectedResult.id
        apiClient.response = expectedResult

        let result = try await(publisher: service.detailsPublisher(forPerson: personID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, PeopleEndpoint.details(personID: personID).url)
    }

    func testCombinedCreditsPublisherReturnsCombinedCredits() throws {
        let expectedResult = PersonCombinedCredits.mock
        let personID = expectedResult.id
        apiClient.response = expectedResult

        let result = try await(publisher: service.combinedCreditsPublisher(forPerson: personID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, PeopleEndpoint.combinedCredits(personID: personID).url)
    }

    func testMovieCreditsPublisherReturnsMovieCredits() throws {
        let expectedResult = PersonMovieCredits.mock
        let personID = expectedResult.id
        apiClient.response = expectedResult

        let result = try await(publisher: service.movieCreditsPublisher(forPerson: personID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, PeopleEndpoint.movieCredits(personID: personID).url)
    }

    func testTVShowCreditsPublisherReturnsTVShowCredits() throws {
        let expectedResult = PersonTVShowCredits.mock
        let personID = expectedResult.id
        apiClient.response = expectedResult

        let result = try await(publisher: service.tvShowCreditsPublisher(forPerson: personID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, PeopleEndpoint.tvShowCredits(personID: personID).url)
    }

    func testImagesPublisherReturnsImageCollection() throws {
        let expectedResult = PersonImageCollection.mock
        let personID = expectedResult.id
        apiClient.response = expectedResult

        let result = try await(publisher: service.imagesPublisher(forPerson: personID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, PeopleEndpoint.images(personID: personID).url)
    }

    func testKnownForPublisherReturnsShows() throws {
        let credits = PersonCombinedCredits.mock
        let personID = credits.id
        apiClient.response = credits
        let topCastShows = Array(credits.cast.prefix(10))
        let topCrewShows = Array(credits.crew.prefix(10))
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

        let result = try await(publisher: service.knownForPublisher(forPerson: personID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, PeopleEndpoint.combinedCredits(personID: personID).url)
    }

    func testPopularPublisherReturnsPeople() throws {
        let expectedResult = PersonPageableList.mock
        apiClient.response = expectedResult

        let result = try await(publisher: service.popularPublisher(page: nil), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, PeopleEndpoint.popular().url)
    }

    func testPopularPublisherWithPageReturnsPeople() throws {
        let expectedResult = PersonPageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let result = try await(publisher: service.popularPublisher(page: page), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, PeopleEndpoint.popular(page: page).url)
    }

}
#endif
