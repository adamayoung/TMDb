//
//  PersonService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Provides an interface for obtaining people from TMDb.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public protocol PersonService: Sendable {

    ///
    /// Returns the primary information about a person.
    ///
    /// [TMDb API - People: Details](https://developer.themoviedb.org/reference/person-details)
    ///
    /// - Parameters:
    ///    - id: The identifier of the person.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching person.
    ///
    func details(forPerson id: Person.ID, language: String?) async throws -> Person

    ///
    /// Returns the primary information about a person with
    /// appended data.
    ///
    /// [TMDb API - People: Details](https://developer.themoviedb.org/reference/person-details)
    ///
    /// - Parameters:
    ///    - id: The identifier of the person.
    ///    - appending: The additional data to append.
    ///    - language: ISO 639-1 language code to display results
    ///     in. Defaults to the client's configured default
    ///     language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching person with appended data.
    ///
    func details(
        forPerson id: Person.ID,
        appending: PersonAppendOption,
        language: String?
    ) async throws -> PersonDetailsResponse

    ///
    /// Returns the combined movie and TV series credits of a person.
    ///
    /// [TMDb API - People: Combined Credits](https://developer.themoviedb.org/reference/person-combined-credits)
    ///
    /// - Parameters:
    ///    - personID: The identifier of the person.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching person's combined movie and TV series credits.
    ///
    func combinedCredits(
        forPerson personID: Person.ID,
        language: String?
    ) async throws -> PersonCombinedCredits

    ///
    /// Returns the movie credits of a person.
    ///
    /// [TMDb API - People: Movie Credits](https://developer.themoviedb.org/reference/person-movie-credits)
    ///
    /// - Parameters:
    ///    - personID: The identifier of the person.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching person's movie credits.
    ///
    func movieCredits(
        forPerson personID: Person.ID,
        language: String?
    ) async throws -> PersonMovieCredits

    ///
    /// Returns the TV series credits of a person.
    ///
    /// [TMDb API - People: TV Credits](https://developer.themoviedb.org/reference/person-tv-credits)
    ///
    /// - Parameters:
    ///    - personID: The identifier of the person.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching person's TV series credits.
    ///
    func tvSeriesCredits(
        forPerson personID: Person.ID,
        language: String?
    ) async throws -> PersonTVSeriesCredits

    ///
    /// Returns the images for a person.
    ///
    /// [TMDb API - People: Images](https://developer.themoviedb.org/reference/person-images)
    ///
    /// - Parameter personID: The identifier of the person.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching person's images.
    ///
    func images(forPerson personID: Person.ID) async throws -> PersonImageCollection

    ///
    /// Returns the list of popular people.
    ///
    /// [TMDb API - People Lists: Popular](https://developer.themoviedb.org/reference/person-popular-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Current popular people as a pageable list.
    ///
    func popular(page: Int?, language: String?) async throws -> PersonPageableList

    ///
    /// Returns a collection of media databases and social links for a person.
    ///
    /// [TMDb API - People: External IDs](https://developer.themoviedb.org/reference/person-external-ids)
    ///
    /// - Parameter personID: The identifier of the person.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of external links for the specified person.
    ///
    func externalLinks(forPerson personID: Person.ID) async throws -> PersonExternalLinksCollection

    ///
    /// Returns the tagged images for a person.
    ///
    /// [TMDb API - People: Tagged Images](https://developer.themoviedb.org/reference/person-tagged-images)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - personID: The identifier of the person.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching person's tagged images.
    ///
    func taggedImages(
        forPerson personID: Person.ID,
        page: Int?
    ) async throws -> TaggedImagePageableList

    ///
    /// Returns the translations for a person.
    ///
    /// [TMDb API - People: Translations](https://developer.themoviedb.org/reference/translations)
    ///
    /// - Parameter personID: The identifier of the person.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of translations for the person.
    ///
    func translations(
        forPerson personID: Person.ID
    ) async throws -> TranslationCollection<PersonTranslationData>

    ///
    /// Returns the recent changes for a person.
    ///
    /// [TMDb API - People: Changes](https://developer.themoviedb.org/reference/person-changes)
    ///
    /// - Parameters:
    ///    - personID: The identifier of the person.
    ///    - startDate: Filter changes after this date.
    ///    - endDate: Filter changes before this date.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of changes for the person.
    ///
    func changes(
        forPerson personID: Person.ID,
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws -> ChangeCollection

    ///
    /// Returns the latest person added to TMDb.
    ///
    /// [TMDb API - People: Latest](https://developer.themoviedb.org/reference/person-latest-id)
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The latest person.
    ///
    func latestPerson() async throws -> Person

    ///
    /// Returns a list of person IDs that have changed.
    ///
    /// [TMDb API - Changes: People List](https://developer.themoviedb.org/reference/changes-people-list)
    ///
    /// - Parameters:
    ///    - startDate: Filter changes after this date.
    ///    - endDate: Filter changes before this date.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of person IDs that have changed.
    ///
    func personChanges(
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws -> ChangedIDCollection

}
