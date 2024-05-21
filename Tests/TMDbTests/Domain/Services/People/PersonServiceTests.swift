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

    func testDetailsReturnsPerson() async throws {
        let expectedResult = Person.johnnyDepp
        let personID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PersonRequest(id: personID, language: nil)

        let result = try await service.details(forPerson: personID)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? PersonRequest, expectedRequest)
    }

    func testDetailsWithLanguageReturnsPerson() async throws {
        let expectedResult = Person.johnnyDepp
        let personID = expectedResult.id
        let language = "en"
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PersonRequest(id: personID, language: language)

        let result = try await service.details(forPerson: personID, language: language)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? PersonRequest, expectedRequest)
    }

    func testDetailsWhenErrorsThrowsError() async throws {
        let personID = 1
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.details(forPerson: personID)
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
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

    func testCombinedCreditsWithLanguageReturnsCombinedCredits() async throws {
        let mock = PersonCombinedCredits.mock()
        let expectedResult = PersonCombinedCredits(id: mock.id, cast: mock.cast, crew: mock.crew)
        let personID = expectedResult.id
        let language = "en"
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PersonCombinedCreditsRequest(id: personID, language: language)

        let result = try await service.combinedCredits(forPerson: personID, language: language)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? PersonCombinedCreditsRequest, expectedRequest)
    }

    func testCombinedCreditsWhenErrorsThrowsError() async throws {
        let personID = 1
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.combinedCredits(forPerson: personID)
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
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

    func testMovieCreditsWithLanguageReturnsMovieCredits() async throws {
        let mock = PersonMovieCredits.mock()
        let expectedResult = PersonMovieCredits(id: mock.id, cast: mock.cast, crew: mock.crew)
        let personID = expectedResult.id
        let language = "en"
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PersonMovieCreditsRequest(id: personID, language: language)

        let result = try await service.movieCredits(forPerson: personID, language: language)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? PersonMovieCreditsRequest, expectedRequest)
    }

    func testMovieCreditsWhenErrorsThrowsError() async throws {
        let personID = 1
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.movieCredits(forPerson: personID)
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
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

    func testTVSeriesCreditsWithLanguageReturnsTVSeriesCredits() async throws {
        let mock = PersonTVSeriesCredits.mock()
        let expectedResult = PersonTVSeriesCredits(id: mock.id, cast: mock.cast, crew: mock.crew)
        let personID = expectedResult.id
        let language = "en"
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PersonTVSeriesCreditsRequest(id: personID, language: language)

        let result = try await service.tvSeriesCredits(forPerson: personID, language: language)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? PersonTVSeriesCreditsRequest, expectedRequest)
    }

    func testTVSeriesCreditsWhenErrorsThrowsError() async throws {
        let personID = 1
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.tvSeriesCredits(forPerson: personID)
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
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

    func testImagesWhenErrorsThrowsError() async throws {
        let personID = 1
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.images(forPerson: personID)
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

    func testPopularReturnsPeople() async throws {
        let expectedResult = PersonPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PopularPeopleRequest(page: nil, language: nil)

        let result = try await service.popular()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? PopularPeopleRequest, expectedRequest)
    }

    func testPopularWithPageAndLanguageReturnsPeople() async throws {
        let page = 2
        let language = "en"
        let expectedResult = PersonPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PopularPeopleRequest(page: page, language: language)

        let result = try await service.popular(page: page, language: language)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequest as? PopularPeopleRequest, expectedRequest)
    }

    func testPopularWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.popular()
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
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

    func testExternalLinksWhenErrorsThrowsError() async throws {
        let personID = 115_440
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.externalLinks(forPerson: personID)
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

}
