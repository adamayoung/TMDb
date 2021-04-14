import Combine
@testable import TMDb
import XCTest

class TMDbAPIPeopleTests: TMDbAPITestCase {

    func testDetailsPublisherForPersonReturnsPerson() throws {
        let expectedResult = Person(id: 1, name: "Name 1")
        personService.personDetails = expectedResult
        let expectedPersonID: Person.ID = 1

        let result = try await(publisher: tmdb.detailsPublisher(forPerson: expectedPersonID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(personService.lastPersonDetailsID, expectedPersonID)
    }

    func testCombinedCreditsPublisherForPersonReturnsCombinedCredits() throws {
        let expectedResult = PersonCombinedCredits(
            id: 1,
            cast: [
                .movie(Movie(id: 1, title: "Title 1")),
                .tvShow(TVShow(id: 2, name: "Name 2"))
            ],
            crew: [
                .movie(Movie(id: 3, title: "Title 3")),
                .tvShow(TVShow(id: 4, name: "Name 4"))
            ]
        )
        personService.combinedCredits = expectedResult
        let expectedPersonID: Person.ID = 1

        let result = try await(publisher: tmdb.combinedCreditsPublisher(forPerson: expectedPersonID),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(personService.lastCombinedCredtsPersonID, expectedPersonID)
    }

    func testMovieCreditsPublisherForPersonReturnsMovieCredits() throws {
        let expectedResult = PersonMovieCredits(
            id: 1,
            cast: [
                Movie(id: 1, title: "Title 1"),
                Movie(id: 2, title: "Title 2")
            ],
            crew: [
                Movie(id: 3, title: "Title 3"),
                Movie(id: 4, title: "Title 4")
            ]
        )
        personService.movieCredits = expectedResult
        let expectedPersonID: Person.ID = 1

        let result = try await(publisher: tmdb.movieCreditsPublisher(forPerson: expectedPersonID),
                               storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(personService.lastMovieCreditsPersonID, expectedPersonID)
    }

    func testTVShowCreditsPublisherForPersonReturnsTVShowCredits() throws {
        let expectedResult = PersonTVShowCredits(
            id: 1,
            cast: [
                TVShow(id: 1, name: "Name 1"),
                TVShow(id: 2, name: "Name 2")
            ],
            crew: [
                TVShow(id: 3, name: "Name 3"),
                TVShow(id: 4, name: "Name 4")
            ]
        )
        personService.tvShowCredits = expectedResult
        let expectedPersonID: Person.ID = 1

        let result = try await(publisher: tmdb.tvShowCredits(forPerson: expectedPersonID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(personService.lastTVShowCreditsPersonID, expectedPersonID)
    }

    func testImagesPublisherForPersonReturnsImages() throws {
        let expectedResult = PersonImageCollection(
            id: 1,
            profiles: [
                ImageMetadata(filePath: URL(string: "/some/images1")!, width: 100, height: 100),
                ImageMetadata(filePath: URL(string: "/some/images2")!, width: 200, height: 200)
            ]
        )
        personService.images = expectedResult
        let expectedPersonID: Person.ID = 1

        let result = try await(publisher: tmdb.imagesPublisher(forPerson: expectedPersonID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(personService.lastImagesPersonID, expectedPersonID)
    }

    func testKnowForPublisherForPersonReturnsShows() throws {
        let expectedResult: [Show] = [
            .movie(Movie(id: 1, title: "Title 1")),
            .tvShow(TVShow(id: 2, name: "Name 2"))
        ]
        personService.knownFor = expectedResult
        let expectedPersonID: Person.ID = 1

        let result = try await(publisher: tmdb.knownForPublisher(forPerson: expectedPersonID), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(personService.lastKnownForPersonID, expectedPersonID)
    }

    func testPopularPeoplePublisherReturnsPeople() throws {
        let expectedResult = PersonPageableList(
            page: 2,
            results: [
                Person(id: 1, name: "Name 1"),
                Person(id: 2, name: "Name 2"),
                Person(id: 3, name: "Name 3")
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
        let expectedResult = PersonPageableList(
            page: 2,
            results: [
                Person(id: 1, name: "Name 1"),
                Person(id: 2, name: "Name 2"),
                Person(id: 3, name: "Name 3")
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
