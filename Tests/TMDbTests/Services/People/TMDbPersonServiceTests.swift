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
        let personID = 12
        let expectedResult = Person(id: 1, name: "Edward Norton")
        apiClient.response = expectedResult

        let result = try await(publisher: service.detailsPublisher(forPerson: personID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, PeopleEndpoint.details(personID: personID).url)
    }

    func testCombinedCreditsPublisherReturnsCombinedCredits() throws {
        let personID = 11
        let expectedResult = PersonCombinedCredits(
            id: 1,
            cast: [
                .movie(Movie(id: 1, title: "Movie 1")),
                .tvShow(TVShow(id: 2, name: "TV Show 2"))
            ],
            crew: [
                .movie(Movie(id: 3, title: "Movie 3")),
                .tvShow(TVShow(id: 4, name: "TV Show 4"))
            ]
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.combinedCreditsPublisher(forPerson: personID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, PeopleEndpoint.combinedCredits(personID: personID).url)
    }

    func testMovieCreditsPublisherReturnsMovieCredits() throws {
        let personID = 11
        let expectedResult = PersonMovieCredits(
            id: 2,
            cast: [
                Movie(id: 1, title: "Movie 1"),
                Movie(id: 2, title: "Movie 2")
            ],
            crew: [
                Movie(id: 3, title: "Movie 3"),
                Movie(id: 4, title: "Movie 4")
            ]
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.movieCreditsPublisher(forPerson: personID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, PeopleEndpoint.movieCredits(personID: personID).url)
    }

    func testTVShowCreditsPublisherReturnsTVShowCredits() throws {
        let personID = 11
        let expectedResult = PersonTVShowCredits(
            id: 1,
            cast: [
                TVShow(id: 1, name: "TV Show 1"),
                TVShow(id: 2, name: "TV Show 2")
            ],
            crew: [
                TVShow(id: 3, name: "TV Show 3"),
                TVShow(id: 4, name: "TV Show 4")
            ]
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.tvShowCreditsPublisher(forPerson: personID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, PeopleEndpoint.tvShowCredits(personID: personID).url)
    }

    func testImagesPublisherReturnsImageCollection() throws {
        let personID = 13
        let expectedResult = PersonImageCollection(
            id: personID,
            profiles: [
                ImageMetadata(filePath: URL(string: "/some/path/image1.jpg")!, width: 100, height: 200),
                ImageMetadata(filePath: URL(string: "/some/path/image2.jpg")!, width: 150, height: 300)
            ]
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.imagesPublisher(forPerson: personID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, PeopleEndpoint.images(personID: personID).url)
    }

    func testPopularPublisherReturnsPeople() throws {
        let expectedResult = PersonPageableList(
            page: 1,
            results: [
                Person(id: 1, name: "Person 1"),
                Person(id: 2, name: "Person 2")
            ],
            totalResults: 2,
            totalPages: 1
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.popularPublisher(page: nil), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, PeopleEndpoint.popular().url)
    }

    func testPopularPublisherWithPageReturnsPeople() throws {
        let page = 2
        let expectedResult = PersonPageableList(
            page: page,
            results: [
                Person(id: 3, name: "Person 3"),
                Person(id: 4, name: "Person 4")
            ],
            totalResults: 5,
            totalPages: 2
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.popularPublisher(page: page), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, PeopleEndpoint.popular(page: page).url)
    }

}
#endif
