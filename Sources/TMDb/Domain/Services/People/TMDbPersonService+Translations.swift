//
//  TMDbPersonService+Translations.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
extension TMDbPersonService {

    func translations(
        forPerson personID: Person.ID
    ) async throws(TMDbError) -> TranslationCollection<PersonTranslationData> {
        let request = PersonTranslationsRequest(id: personID)

        return try await apiClient.perform(request)
    }

}
