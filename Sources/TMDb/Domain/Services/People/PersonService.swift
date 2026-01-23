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
    /// - Returns: A collection of external links for the specificed person.
    ///
    func externalLinks(forPerson personID: Person.ID) async throws -> PersonExternalLinksCollection

}

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

}
