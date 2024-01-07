import TMDb
import XCTest

final class PersonIntegrationTests: XCTestCase {

    var personService: PersonService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        try configureTMDb()
        personService = PersonService()
    }

    override func tearDown() {
        personService = nil
        super.tearDown()
    }

    func testDetails() async throws {
        let personID = 500

        let person = try await personService.details(forPerson: personID)

        XCTAssertEqual(person.id, personID)
        XCTAssertEqual(person.name, "Tom Cruise")
    }

    func testCombinedCredits() async throws {
        let personID = 500

        let credits = try await personService.combinedCredits(forPerson: personID)

        XCTAssertEqual(credits.id, personID)
        XCTAssertFalse(credits.cast.isEmpty)
        XCTAssertFalse(credits.crew.isEmpty)
    }

    func testMovieCredits() async throws {
        let personID = 500

        let credits = try await personService.movieCredits(forPerson: personID)

        XCTAssertEqual(credits.id, personID)
        XCTAssertFalse(credits.cast.isEmpty)
        XCTAssertFalse(credits.crew.isEmpty)
    }

    func testTVSeriesCredits() async throws {
        let personID = 500

        let credits = try await personService.tvSeriesCredits(forPerson: personID)

        XCTAssertEqual(credits.id, personID)
        XCTAssertFalse(credits.cast.isEmpty)
        XCTAssertFalse(credits.crew.isEmpty)
    }

    func testImages() async throws {
        let personID = 500

        let imageCollection = try await personService.images(forPerson: personID)

        XCTAssertEqual(imageCollection.id, personID)
        XCTAssertFalse(imageCollection.profiles.isEmpty)
    }

    func testKnownFor() async throws {
        let personID = 500

        let shows = try await personService.knownFor(forPerson: personID)

        XCTAssertFalse(shows.isEmpty)
    }

    func testPopular() async throws {
        let personList = try await personService.popular()

        XCTAssertFalse(personList.results.isEmpty)
    }

    func testExternalLinks() async throws {
        let personID = 115440

        let linksCollection = try await personService.externalLinks(forPerson: personID)

        XCTAssertEqual(linksCollection.id, personID)
        XCTAssertNotNil(linksCollection.imdb)
        XCTAssertNotNil(linksCollection.wikiData)
        XCTAssertNil(linksCollection.facebook)
        XCTAssertNotNil(linksCollection.instagram)
        XCTAssertNotNil(linksCollection.twitter)
        XCTAssertNotNil(linksCollection.tikTok)
    }

}
