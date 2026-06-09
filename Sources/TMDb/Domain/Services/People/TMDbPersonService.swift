//
//  TMDbPersonService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
final class TMDbPersonService: PersonService {

    let apiClient: any APIClient
    let configuration: TMDbConfiguration

    init(apiClient: some APIClient, configuration: TMDbConfiguration = .default) {
        self.apiClient = apiClient
        self.configuration = configuration
    }

    func details(
        forPerson id: Person.ID,
        language: String? = nil
    ) async throws(TMDbError) -> Person {
        let languageCode = language ?? configuration.defaultLanguage
        let request = PersonRequest(id: id, language: languageCode)

        return try await apiClient.perform(request)
    }

    func details(
        forPerson id: Person.ID,
        appending: PersonAppendOption,
        language: String? = nil
    ) async throws(TMDbError) -> PersonDetailsResponse {
        let languageCode = language ?? configuration.defaultLanguage
        let request = PersonDetailsAppendRequest(
            id: id,
            appendToResponse: appending,
            language: languageCode
        )

        return try await apiClient.perform(request)
    }

    func combinedCredits(
        forPerson personID: Person.ID,
        language: String? = nil
    ) async throws(TMDbError) -> PersonCombinedCredits {
        let languageCode = language ?? configuration.defaultLanguage
        let request = PersonCombinedCreditsRequest(id: personID, language: languageCode)

        return try await apiClient.perform(request)
    }

    func movieCredits(
        forPerson personID: Person.ID,
        language: String? = nil
    ) async throws(TMDbError) -> PersonMovieCredits {
        let languageCode = language ?? configuration.defaultLanguage
        let request = PersonMovieCreditsRequest(id: personID, language: languageCode)

        return try await apiClient.perform(request)
    }

    func tvSeriesCredits(
        forPerson personID: Person.ID,
        language: String? = nil
    ) async throws(TMDbError) -> PersonTVSeriesCredits {
        let languageCode = language ?? configuration.defaultLanguage
        let request = PersonTVSeriesCreditsRequest(id: personID, language: languageCode)

        return try await apiClient.perform(request)
    }

    func images(forPerson personID: Person.ID) async throws(TMDbError) -> PersonImageCollection {
        let request = PersonImagesRequest(id: personID)

        return try await apiClient.perform(request)
    }

    func popular(
        page: Int? = nil,
        language: String? = nil
    ) async throws(TMDbError) -> PersonPageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = PopularPeopleRequest(page: page, language: languageCode)

        return try await apiClient.perform(request)
    }

    func externalLinks(
        forPerson personID: Person.ID
    ) async throws(TMDbError) -> PersonExternalLinksCollection {
        let request = PersonExternalLinksRequest(id: personID)

        return try await apiClient.perform(request)
    }

}
