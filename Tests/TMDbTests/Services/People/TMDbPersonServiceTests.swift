import Combine
@testable import TMDb
import XCTest

class TMDbPersonServiceTests: XCTestCase {

    var cancellables: Set<AnyCancellable> = []
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
        let personID = 12
        let expectedResult = PersonDTO(id: 1, name: "Edward Norton")
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchDetails(forPerson: personID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, PeopleEndpoint.details(personID: personID).url)
    }

    func testFetchCombinedCreditsReturnsCombinedCredits() throws {
        let personID = 11
        let expectedResult = PersonCombinedCreditsDTO(
            id: 1,
            cast: [
                .movie(MovieDTO(id: 1, title: "Movie 1")),
                .tvShow(TVShowDTO(id: 2, name: "TV Show 2"))
            ],
            crew: [
                .movie(MovieDTO(id: 3, title: "Movie 3")),
                .tvShow(TVShowDTO(id: 4, name: "TV Show 4"))
            ]
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchCombinedCredits(forPerson: personID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, PeopleEndpoint.combinedCredits(personID: personID).url)
    }

    func testFetchMovieCreditsReturnsMovieCredits() throws {
        let personID = 11
        let expectedResult = PersonMovieCreditsDTO(
            id: 2,
            cast: [
                MovieDTO(id: 1, title: "Movie 1"),
                MovieDTO(id: 2, title: "Movie 2")
            ],
            crew: [
                MovieDTO(id: 3, title: "Movie 3"),
                MovieDTO(id: 4, title: "Movie 4")
            ]
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchMovieCredits(forPerson: personID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, PeopleEndpoint.movieCredits(personID: personID).url)
    }

    func testFetchTVShowCreditsReturnsTVShowCredits() throws {
        let personID = 11
        let expectedResult = PersonTVShowCreditsDTO(
            id: 1,
            cast: [
                TVShowDTO(id: 1, name: "TV Show 1"),
                TVShowDTO(id: 2, name: "TV Show 2")
            ],
            crew: [
                TVShowDTO(id: 3, name: "TV Show 3"),
                TVShowDTO(id: 4, name: "TV Show 4")
            ]
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchTVShowCredits(forPerson: personID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, PeopleEndpoint.tvShowCredits(personID: personID).url)
    }

    func testFetchImagesReturnsImageCollection() throws {
        let personID = 13
        let expectedResult = PersonImageCollectionDTO(
            id: personID,
            profiles: [
                ImageMetadataDTO(filePath: URL(string: "/some/path/image1.jpg")!, width: 100, height: 200),
                ImageMetadataDTO(filePath: URL(string: "/some/path/image2.jpg")!, width: 150, height: 300)
            ]
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchImages(forPerson: personID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, PeopleEndpoint.images(personID: personID).url)
    }

    func testFetchPopularReturnsPeople() throws {
        let expectedResult = PersonPageableListDTO(
            page: 1,
            results: [
                PersonDTO(id: 1, name: "Person 1"),
                PersonDTO(id: 2, name: "Person 2")
            ],
            totalResults: 2,
            totalPages: 1
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchPopular(page: nil), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, PeopleEndpoint.popular().url)
    }

    func testFetchPopularWithPageReturnsPeople() throws {
        let page = 2
        let expectedResult = PersonPageableListDTO(
            page: page,
            results: [
                PersonDTO(id: 3, name: "Person 3"),
                PersonDTO(id: 4, name: "Person 4")
            ],
            totalResults: 5,
            totalPages: 2
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.fetchPopular(page: page), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, PeopleEndpoint.popular(page: page).url)
    }

}
