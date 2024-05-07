//
//  PersonService.swift
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

///
/// Provides an interface for obtaining people from TMDb.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public final class PersonService {

    private static let knownForShowsMaxCount = 10

    private let apiClient: any APIClient

    ///
    /// Creates a person service object.
    ///
    /// - Parameter configuration: A TMDb configuration object.
    ///
    public convenience init(configuration: TMDbConfiguration) {
        self.init(
            apiClient: TMDbFactory.apiClient(configuration: configuration)
        )
    }

    init(apiClient: some APIClient) {
        self.apiClient = apiClient
    }

    ///
    /// Returns the primary information about a person.
    ///
    /// [TMDb API - People: Details](https://developer.themoviedb.org/reference/person-details)
    ///
    /// - Parameters:
    ///    - id: The identifier of the person.
    ///    - language: ISO 639-1 language code to display results in. Defaults to `en`.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching person.
    ///
    public func details(forPerson id: Person.ID, language: String? = nil) async throws -> Person {
        let request = PersonRequest(id: id, language: language)

        let person: Person
        do {
            person = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return person
    }

    ///
    /// Returns the combined movie and TV series credits of a person.
    ///
    /// [TMDb API - People: Combined Credits](https://developer.themoviedb.org/reference/person-combined-credits)
    ///
    /// - Parameters:
    ///    - personID: The identifier of the person.
    ///    - language: ISO 639-1 language code to display results in. Defaults to `en`.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching person's combined movie and TV series credits.
    ///
    public func combinedCredits(
        forPerson personID: Person.ID,
        language: String? = nil
    ) async throws -> PersonCombinedCredits {
        let request = PersonCombinedCreditsRequest(id: personID, language: language)

        let credits: PersonCombinedCredits
        do {
            credits = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return credits
    }

    ///
    /// Returns the movie credits of a person.
    ///
    /// [TMDb API - People: Movie Credits](https://developer.themoviedb.org/reference/person-movie-credits)
    ///
    /// - Parameters:
    ///    - personID: The identifier of the person.
    ///    - language: ISO 639-1 language code to display results in. Defaults to `en`.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching person's movie credits.
    ///
    public func movieCredits(
        forPerson personID: Person.ID,
        language: String? = nil
    ) async throws -> PersonMovieCredits {
        let request = PersonMovieCreditsRequest(id: personID, language: language)

        let credits: PersonMovieCredits
        do {
            credits = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return credits
    }

    ///
    /// Returns the TV series credits of a person.
    ///
    /// [TMDb API - People: TV Credits](https://developer.themoviedb.org/reference/person-tv-credits)
    ///
    /// - Parameters:
    ///    - personID: The identifier of the person.
    ///    - language: ISO 639-1 language code to display results in. Defaults to `en`.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching person's TV series credits.
    ///
    public func tvSeriesCredits(
        forPerson personID: Person.ID,
        language: String? = nil
    ) async throws -> PersonTVSeriesCredits {
        let request = PersonTVSeriesCreditsRequest(id: personID, language: language)

        let credits: PersonTVSeriesCredits
        do {
            credits = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return credits
    }

    ///
    /// Returns the images for a person.
    ///
    /// [TMDb API - People: Images](https://developer.themoviedb.org/reference/person-images)
    ///
    /// - Parameters:
    ///    - personID: The identifier of the person.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching person's images.
    ///
    public func images(forPerson personID: Person.ID) async throws -> PersonImageCollection {
        let request = PersonImagesRequest(id: personID)

        let imageCollection: PersonImageCollection
        do {
            imageCollection = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return imageCollection
    }

    ///
    /// Returns the list of popular people.
    ///
    /// [TMDb API - People Lists: Popular](https://developer.themoviedb.org/reference/person-popular-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to `en`.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Current popular people as a pageable list.
    ///
    public func popular(page: Int? = nil, language: String? = nil) async throws -> PersonPageableList {
        let request = PopularPeopleRequest(page: page, language: language)

        let personList: PersonPageableList
        do {
            personList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return personList
    }

    ///
    /// Returns a collection of media databases and social links for a person.
    ///
    /// [TMDb API - People: External IDs](https://developer.themoviedb.org/reference/person-external-ids)
    ///
    /// - Parameters:
    ///    - personID: The identifier of the person.
    ///
    /// - Returns: A collection of external links for the specificed person.
    ///
    public func externalLinks(forPerson personID: Person.ID) async throws -> PersonExternalLinksCollection {
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
