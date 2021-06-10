#if canImport(Combine)
import Combine
@testable import TMDb
import XCTest

class TMDbPersonServiceCombineTests: XCTestCase {

    var cancellables: Set<AnyCancellable> = []
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

    func testDetailsPublisherReturnsPerson() throws {
        let expectedResult = Person.mock
        let personID = expectedResult.id
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.detailsPublisher(forPerson: personID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, PeopleEndpoint.details(personID: personID).url)
    }

    func testCombinedCreditsPublisherReturnsCombinedCredits() throws {
        let mock = PersonCombinedCredits.mock
        let expectedResult = PersonCombinedCredits(id: mock.id, cast: mock.cast.sorted(), crew: mock.crew.sorted())
        let personID = expectedResult.id
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.combinedCreditsPublisher(forPerson: personID),
                                 storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, PeopleEndpoint.combinedCredits(personID: personID).url)
    }

    func testMovieCreditsPublisherReturnsMovieCredits() throws {
        let mock = PersonMovieCredits.mock
        let expectedResult = PersonMovieCredits(id: mock.id, cast: mock.cast.sorted(), crew: mock.crew.sorted())
        let personID = expectedResult.id
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.movieCreditsPublisher(forPerson: personID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, PeopleEndpoint.movieCredits(personID: personID).url)
    }

    func testTVShowCreditsPublisherReturnsTVShowCredits() throws {
        let mock = PersonTVShowCredits.mock
        let expectedResult = PersonTVShowCredits(id: mock.id, cast: mock.cast.sorted(), crew: mock.crew.sorted())
        let personID = expectedResult.id
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.tvShowCreditsPublisher(forPerson: personID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, PeopleEndpoint.tvShowCredits(personID: personID).url)
    }

    func testImagesPublisherReturnsImageCollection() throws {
        let expectedResult = PersonImageCollection.mock
        let personID = expectedResult.id
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.imagesPublisher(forPerson: personID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, PeopleEndpoint.images(personID: personID).url)
    }

    func testKnownForPublisherReturnsShows() throws {
        let credits = PersonCombinedCredits.mock
        let personID = credits.id
        apiClient.response = credits
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

        let result = try waitFor(publisher: service.knownForPublisher(forPerson: personID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, PeopleEndpoint.combinedCredits(personID: personID).url)
    }

    func testPopularPublisherWithDefaultParametersReturnsPeople() throws {
        let expectedResult = PersonPageableList.mock
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.popularPublisher(), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, PeopleEndpoint.popular().url)
    }

    func testPopularPublisherReturnsPeople() throws {
        let expectedResult = PersonPageableList.mock
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.popularPublisher(page: nil), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, PeopleEndpoint.popular().url)
    }

    func testPopularPublisherWithPageReturnsPeople() throws {
        let expectedResult = PersonPageableList.mock
        let page = expectedResult.page
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.popularPublisher(page: page), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, PeopleEndpoint.popular(page: page).url)
    }

}
#endif
