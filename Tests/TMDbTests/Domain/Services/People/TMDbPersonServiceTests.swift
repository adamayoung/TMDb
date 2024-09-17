//
//  TMDbPersonServiceTests.swift
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

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .people))
struct TMDbPersonServiceTests {

    var service: TMDbPersonService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbPersonService(apiClient: apiClient)
    }

    @Test("details returns person")
    func detailsReturnsPerson() async throws {
        let expectedResult = Person.johnnyDepp
        let personID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PersonRequest(id: personID, language: nil)

        let result = try await service.details(forPerson: personID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? PersonRequest == expectedRequest)
    }

    @Test("details with language returns person")
    func detailsWithLanguageReturnsPerson() async throws {
        let expectedResult = Person.johnnyDepp
        let personID = expectedResult.id
        let language = "en"
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PersonRequest(id: personID, language: language)

        let result = try await service.details(forPerson: personID, language: language)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? PersonRequest == expectedRequest)
    }

    @Test("details when errors throws error")
    func detailsWhenErrorsThrowsError() async throws {
        let personID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.details(forPerson: personID)
        }
    }

    @Test("combinedCredits returns combinedCredits")
    func combinedCreditsReturnsCombinedCredits() async throws {
        let mock = PersonCombinedCredits.mock()
        let expectedResult = PersonCombinedCredits(id: mock.id, cast: mock.cast, crew: mock.crew)
        let personID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PersonCombinedCreditsRequest(id: personID, language: nil)

        let result = try await service.combinedCredits(forPerson: personID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? PersonCombinedCreditsRequest == expectedRequest)
    }

    @Test("combinedCredits with language returns combinedCredits")
    func combinedCreditsWithLanguageReturnsCombinedCredits() async throws {
        let mock = PersonCombinedCredits.mock()
        let expectedResult = PersonCombinedCredits(id: mock.id, cast: mock.cast, crew: mock.crew)
        let personID = expectedResult.id
        let language = "en"
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PersonCombinedCreditsRequest(id: personID, language: language)

        let result = try await service.combinedCredits(forPerson: personID, language: language)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? PersonCombinedCreditsRequest == expectedRequest)
    }

    @Test("combinedCredits when errors throws error")
    func combinedCreditsWhenErrorsThrowsError() async throws {
        let personID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.combinedCredits(forPerson: personID)
        }
    }

    @Test("movieCredits returns movie credits")
    func movieCreditsReturnsMovieCredits() async throws {
        let mock = PersonMovieCredits.mock()
        let expectedResult = PersonMovieCredits(id: mock.id, cast: mock.cast, crew: mock.crew)
        let personID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PersonMovieCreditsRequest(id: personID, language: nil)

        let result = try await service.movieCredits(forPerson: personID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? PersonMovieCreditsRequest == expectedRequest)
    }

    @Test("movieCredits with language returns movie credits")
    func movieCreditsWithLanguageReturnsMovieCredits() async throws {
        let mock = PersonMovieCredits.mock()
        let expectedResult = PersonMovieCredits(id: mock.id, cast: mock.cast, crew: mock.crew)
        let personID = expectedResult.id
        let language = "en"
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PersonMovieCreditsRequest(id: personID, language: language)

        let result = try await service.movieCredits(forPerson: personID, language: language)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? PersonMovieCreditsRequest == expectedRequest)
    }

    @Test("movieCredits when errors throws error")
    func movieCreditsWhenErrorsThrowsError() async throws {
        let personID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.movieCredits(forPerson: personID)
        }
    }

    @Test("tvSeriesCredits returns tv series credits")
    func tvSeriesCreditsReturnsTVSeriesCredits() async throws {
        let mock = PersonTVSeriesCredits.mock()
        let expectedResult = PersonTVSeriesCredits(id: mock.id, cast: mock.cast, crew: mock.crew)
        let personID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PersonTVSeriesCreditsRequest(id: personID, language: nil)

        let result = try await service.tvSeriesCredits(forPerson: personID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? PersonTVSeriesCreditsRequest == expectedRequest)
    }

    @Test("tvSeriesCredits with language returns tv series credits")
    func tvSeriesCreditsWithLanguageReturnsTVSeriesCredits() async throws {
        let mock = PersonTVSeriesCredits.mock()
        let expectedResult = PersonTVSeriesCredits(id: mock.id, cast: mock.cast, crew: mock.crew)
        let personID = expectedResult.id
        let language = "en"
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PersonTVSeriesCreditsRequest(id: personID, language: language)

        let result = try await service.tvSeriesCredits(forPerson: personID, language: language)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? PersonTVSeriesCreditsRequest == expectedRequest)
    }

    @Test("tvSeriesCredits when errors throws error")
    func tvSeriesCreditsWhenErrorsThrowsError() async throws {
        let personID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.tvSeriesCredits(forPerson: personID)
        }
    }

    @Test("images returns image collection")
    func imagesReturnsImageCollection() async throws {
        let expectedResult = PersonImageCollection.mock()
        let personID = expectedResult.id
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PersonImagesRequest(id: personID)

        let result = try await service.images(forPerson: personID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? PersonImagesRequest == expectedRequest)
    }

    @Test("images when errors throws error")
    func imagesWhenErrorsThrowsError() async throws {
        let personID = 1
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.images(forPerson: personID)
        }
    }

    @Test("popular returns people")
    func popularReturnsPeople() async throws {
        let expectedResult = PersonPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PopularPeopleRequest(page: nil, language: nil)

        let result = try await service.popular()

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? PopularPeopleRequest == expectedRequest)
    }

    @Test("popular with page and language returns people")
    func popularWithPageAndLanguageReturnsPeople() async throws {
        let page = 2
        let language = "en"
        let expectedResult = PersonPageableList.mock()
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PopularPeopleRequest(page: page, language: language)

        let result = try await service.popular(page: page, language: language)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? PopularPeopleRequest == expectedRequest)
    }

    @Test("popular when errors throws error")
    func popularWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.popular()
        }
    }

    @Test("externalLinks returns external links")
    func externalLinksReturnsExternalLinks() async throws {
        let expectedResult = PersonExternalLinksCollection.sydneySweeney
        let personID = 115_440
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PersonExternalLinksRequest(id: personID)

        let result = try await service.externalLinks(forPerson: personID)

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? PersonExternalLinksRequest == expectedRequest)
    }

    @Test("externalLinks when errors throws error")
    func externalLinksWhenErrorsThrowsError() async throws {
        let personID = 115_440
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.externalLinks(forPerson: personID)
        }
    }

}
