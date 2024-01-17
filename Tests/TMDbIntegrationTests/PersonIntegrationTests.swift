//
//  PersonIntegrationTests.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

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
        let personID = 115_440

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
