import Combine
@testable import TMDb
import XCTest

class TMDbAPIPeopleTests: TMDbAPITestCase {

    func testDetailsPublisherForPersonReturnsPerson() throws {
        let expectedResult = PersonDTO(id: 1, name: "Name 1")
        personService.personDetails = expectedResult
        let expectedPersonID: PersonDTO.ID = 1

        let result = try await(publisher: tmdb.detailsPublisher(forPerson: expectedPersonID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(personService.lastPersonDetailsID, expectedPersonID)
    }

    func testCombinedCreditsPublisherForPersonReturnsCombinedCredits() throws {
        let expectedResult = PersonCombinedCreditsDTO(
            id: 1,
            cast: [
                .movie(MovieDTO(id: 1, title: "Title 1")),
                .tvShow(TVShowDTO(id: 2, name: "Name 2"))
            ],
            crew: [
                .movie(MovieDTO(id: 3, title: "Title 3")),
                .tvShow(TVShowDTO(id: 4, name: "Name 4"))
            ]
        )
        personService.combinedCredits = expectedResult
        let expectedPersonID: PersonDTO.ID = 1

        let result = try await(publisher: tmdb.combinedCreditsPublisher(forPerson: expectedPersonID),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(personService.lastCombinedCredtsPersonID, expectedPersonID)
    }

    func testMovieCreditsPublisherForPersonReturnsMovieCredits() throws {
        let expectedResult = PersonMovieCreditsDTO(
            id: 1,
            cast: [
                MovieDTO(id: 1, title: "Title 1"),
                MovieDTO(id: 2, title: "Title 2")
            ],
            crew: [
                MovieDTO(id: 3, title: "Title 3"),
                MovieDTO(id: 4, title: "Title 4")
            ]
        )
        personService.movieCredits = expectedResult
        let expectedPersonID: PersonDTO.ID = 1

        let result = try await(publisher: tmdb.movieCreditsPublisher(forPerson: expectedPersonID),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(personService.lastMovieCreditsPersonID, expectedPersonID)
    }

    func testTVShowCreditsPublisherForPersonReturnsTVShowCredits() throws {
        let expectedResult = PersonTVShowCreditsDTO(
            id: 1,
            cast: [
                TVShowDTO(id: 1, name: "Name 1"),
                TVShowDTO(id: 2, name: "Name 2")
            ],
            crew: [
                TVShowDTO(id: 3, name: "Name 3"),
                TVShowDTO(id: 4, name: "Name 4")
            ]
        )
        personService.tvShowCredits = expectedResult
        let expectedPersonID: PersonDTO.ID = 1

        let result = try await(publisher: tmdb.tvShowCredits(forPerson: expectedPersonID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(personService.lastTVShowCreditsPersonID, expectedPersonID)
    }

    func testImagesPublisherForPersonReturnsImages() throws {
        let expectedResult = PersonImageCollectionDTO(
            id: 1,
            profiles: [
                ImageMetadataDTO(filePath: URL(string: "/some/images1")!, width: 100, height: 100),
                ImageMetadataDTO(filePath: URL(string: "/some/images2")!, width: 200, height: 200)
            ]
        )
        personService.images = expectedResult
        let expectedPersonID: PersonDTO.ID = 1

        let result = try await(publisher: tmdb.imagesPublisher(forPerson: expectedPersonID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(personService.lastImagesPersonID, expectedPersonID)
    }

    func testKnowForPublisherForPersonReturnsShows() throws {
        let expectedResult: [ShowDTO] = [
            .movie(MovieDTO(id: 1, title: "Title 1")),
            .tvShow(TVShowDTO(id: 2, name: "Name 2"))
        ]
        personService.knownFor = expectedResult
        let expectedPersonID: PersonDTO.ID = 1

        let result = try await(publisher: tmdb.knownForPublisher(forPerson: expectedPersonID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(personService.lastKnownForPersonID, expectedPersonID)
    }

    func testPopularPeoplePublisherReturnsPeople() throws {
        let expectedResult = PersonPageableListDTO(
            page: 2,
            results: [
                PersonDTO(id: 1, name: "Name 1"),
                PersonDTO(id: 2, name: "Name 2"),
                PersonDTO(id: 3, name: "Name 3")
            ],
            totalResults: 6,
            totalPages: 2
        )
        personService.popular = expectedResult

        let result = try await(publisher: tmdb.popularPeoplePublisher(), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertNil(personService.lastPopularPage)
    }

    func testPopularPeoplePublisherWithPageReturnsPeople() throws {
        let expectedResult = PersonPageableListDTO(
            page: 2,
            results: [
                PersonDTO(id: 1, name: "Name 1"),
                PersonDTO(id: 2, name: "Name 2"),
                PersonDTO(id: 3, name: "Name 3")
            ],
            totalResults: 6,
            totalPages: 2
        )
        personService.popular = expectedResult
        let expectedPage = 2

        let result = try await(publisher: tmdb.popularPeoplePublisher(page: expectedPage), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(personService.lastPopularPage, expectedPage)
    }

}
