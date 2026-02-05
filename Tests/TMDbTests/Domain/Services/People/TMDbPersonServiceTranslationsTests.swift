//
//  TMDbPersonServiceTranslationsTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .people))
struct TMDbPersonServiceTranslationsTests {

    var service: TMDbPersonService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbPersonService(apiClient: apiClient)
    }

    @Test("translations returns translation collection")
    func translationsReturnsTranslationCollection() async throws {
        let personID = 500
        let expectedResult = TranslationCollection<
            PersonTranslationData
        >(
            id: personID,
            translations: [
                Translation<PersonTranslationData>(
                    countryCode: "US",
                    languageCode: "en",
                    name: "English",
                    englishName: "English",
                    data: PersonTranslationData(
                        biography: "Tom Cruise biography"
                    )
                )
            ]
        )
        apiClient.addResponse(.success(expectedResult))
        let expectedRequest = PersonTranslationsRequest(
            id: personID
        )

        let result = try await service.translations(
            forPerson: personID
        )

        #expect(result == expectedResult)
        #expect(
            apiClient.lastRequest as? PersonTranslationsRequest
                == expectedRequest
        )
    }

    @Test("translations when errors throws error")
    func translationsWhenErrorsThrowsError() async throws {
        let personID = 500
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.translations(forPerson: personID)
        }
    }

}
