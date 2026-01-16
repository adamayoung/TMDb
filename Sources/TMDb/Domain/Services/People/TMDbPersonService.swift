//
//  TMDbPersonService.swift
//  TMDb
//
//  Copyright © 2025 Adam Young.
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

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
final class TMDbPersonService: PersonService {

    private let apiClient: any APIClient
    private let configuration: TMDbConfiguration

    init(apiClient: some APIClient, configuration: TMDbConfiguration = .default) {
        self.apiClient = apiClient
        self.configuration = configuration
    }

    func details(forPerson id: Person.ID, language: String? = nil) async throws -> Person {
        let languageCode = language ?? configuration.defaultLanguage
        let request = PersonRequest(id: id, language: languageCode)

        let person: Person
        do {
            person = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return person
    }

    func combinedCredits(
        forPerson personID: Person.ID,
        language: String? = nil
    ) async throws -> PersonCombinedCredits {
        let languageCode = language ?? configuration.defaultLanguage
        let request = PersonCombinedCreditsRequest(id: personID, language: languageCode)

        let credits: PersonCombinedCredits
        do {
            credits = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return credits
    }

    func movieCredits(
        forPerson personID: Person.ID,
        language: String? = nil
    ) async throws -> PersonMovieCredits {
        let languageCode = language ?? configuration.defaultLanguage
        let request = PersonMovieCreditsRequest(id: personID, language: languageCode)

        let credits: PersonMovieCredits
        do {
            credits = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return credits
    }

    func tvSeriesCredits(
        forPerson personID: Person.ID,
        language: String? = nil
    ) async throws -> PersonTVSeriesCredits {
        let languageCode = language ?? configuration.defaultLanguage
        let request = PersonTVSeriesCreditsRequest(id: personID, language: languageCode)

        let credits: PersonTVSeriesCredits
        do {
            credits = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return credits
    }

    func images(forPerson personID: Person.ID) async throws -> PersonImageCollection {
        let request = PersonImagesRequest(id: personID)

        let imageCollection: PersonImageCollection
        do {
            imageCollection = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return imageCollection
    }

    func popular(page: Int? = nil, language: String? = nil) async throws -> PersonPageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = PopularPeopleRequest(page: page, language: languageCode)

        let personList: PersonPageableList
        do {
            personList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return personList
    }

    func externalLinks(
        forPerson personID: Person.ID
    ) async throws -> PersonExternalLinksCollection {
        let request = PersonExternalLinksRequest(id: personID)

        let linksCollection: PersonExternalLinksCollection
        do {
            linksCollection = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return linksCollection
    }

}
