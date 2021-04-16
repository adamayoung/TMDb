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
