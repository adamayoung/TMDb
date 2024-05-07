//
//  PersonServiceTests.swift
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

@testable import TMDb
import XCTest

final class PersonServiceTests: XCTestCase {

    var service: PersonService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        service = PersonService(apiClient: apiClient)
    }

    override func tearDown() {
        apiClient = nil
        service = nil
        super.tearDown()
    }

    func testDetailsReturnsPerson() async throws {
        let expectedResult = Person.johnnyDepp
        let personID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PersonRequest(id: personID, language: nil)

        let result = try await service.details(forPerson: personID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? PersonRequest, expectedRequest)
    }

    func testCombinedCreditsReturnsCombinedCredits() async throws {
        let mock = PersonCombinedCredits.mock()
        let expectedResult = PersonCombinedCredits(id: mock.id, cast: mock.cast, crew: mock.crew)
        let personID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PersonCombinedCreditsRequest(id: personID, language: nil)

        let result = try await service.combinedCredits(forPerson: personID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? PersonCombinedCreditsRequest, expectedRequest)
    }

    func testMovieCreditsReturnsMovieCredits() async throws {
        let mock = PersonMovieCredits.mock()
        let expectedResult = PersonMovieCredits(id: mock.id, cast: mock.cast, crew: mock.crew)
        let personID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PersonMovieCreditsRequest(id: personID, language: nil)

        let result = try await service.movieCredits(forPerson: personID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? PersonMovieCreditsRequest, expectedRequest)
    }

    func testTVSeriesCreditsReturnsTVSeriesCredits() async throws {
        let mock = PersonTVSeriesCredits.mock()
        let expectedResult = PersonTVSeriesCredits(id: mock.id, cast: mock.cast, crew: mock.crew)
        let personID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PersonTVSeriesCreditsRequest(id: personID, language: nil)

        let result = try await service.tvSeriesCredits(forPerson: personID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? PersonTVSeriesCreditsRequest, expectedRequest)
    }

    func testImagesReturnsImageCollection() async throws {
        let expectedResult = PersonImageCollection.mock()
        let personID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PersonImagesRequest(id: personID)

        let result = try await service.images(forPerson: personID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? PersonImagesRequest, expectedRequest)
    }

    func testPopularReturnsPeople() async throws {
        let expectedResult = PersonPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PopularPeopleRequest(page: nil, language: nil)

        let result = try await service.popular()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? PopularPeopleRequest, expectedRequest)
    }

    func testExternalLinksReturnsExternalLinks() async throws {
        let expectedResult = PersonExternalLinksCollection.sydneySweeney
        let personID = 115_440
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PersonExternalLinksRequest(id: personID)

        let result = try await service.externalLinks(forPerson: personID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? PersonExternalLinksRequest, expectedRequest)
    }

}
