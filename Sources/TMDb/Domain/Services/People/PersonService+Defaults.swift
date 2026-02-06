//
//  PersonService+Defaults.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public extension PersonService {

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
    func details(forPerson id: Person.ID, language: String? = nil) async throws -> Person {
        try await details(forPerson: id, language: language)
    }

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
        language: String? = nil
    ) async throws -> PersonDetailsResponse {
        try await details(
            forPerson: id,
            appending: appending,
            language: language
        )
    }

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
        language: String? = nil
    ) async throws -> PersonCombinedCredits {
        try await combinedCredits(forPerson: personID, language: language)
    }

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
        language: String? = nil
    ) async throws -> PersonMovieCredits {
        try await movieCredits(forPerson: personID, language: language)
    }

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
        language: String? = nil
    ) async throws -> PersonTVSeriesCredits {
        try await tvSeriesCredits(forPerson: personID, language: language)
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
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Current popular people as a pageable list.
    ///
    func popular(
        page: Int? = nil,
        language: String? = nil
    ) async throws -> PersonPageableList {
        try await popular(page: page, language: language)
    }

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
        page: Int? = nil
    ) async throws -> TaggedImagePageableList {
        try await taggedImages(
            forPerson: personID, page: page
        )
    }

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
        startDate: Date? = nil,
        endDate: Date? = nil,
        page: Int? = nil
    ) async throws -> ChangeCollection {
        try await changes(
            forPerson: personID,
            startDate: startDate,
            endDate: endDate,
            page: page
        )
    }

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
        startDate: Date? = nil,
        endDate: Date? = nil,
        page: Int? = nil
    ) async throws -> ChangedIDCollection {
        try await personChanges(
            startDate: startDate,
            endDate: endDate,
            page: page
        )
    }

}
