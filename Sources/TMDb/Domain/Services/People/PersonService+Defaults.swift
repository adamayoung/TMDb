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
    /// - Parameter personID: The identifier of the person.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching person.
    ///
    /// - Note: This convenience omits `language` rather than defaulting it, so
    /// that its signature stays distinct from the requirement it forwards to. A
    /// defaulted overload would instead become that requirement's default
    /// implementation.
    ///
    func details(forPerson personID: Person.ID) async throws(TMDbError) -> Person {
        try await details(forPerson: personID, language: nil)
    }

    ///
    /// Returns the primary information about a person with
    /// appended data.
    ///
    /// [TMDb API - People: Details](https://developer.themoviedb.org/reference/person-details)
    ///
    /// - Parameters:
    ///    - personID: The identifier of the person.
    ///    - appending: The additional data to append.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching person with appended data.
    ///
    /// - Note: This convenience omits `language` rather than defaulting it, so
    /// that its signature stays distinct from the requirement it forwards to. A
    /// defaulted overload would instead become that requirement's default
    /// implementation.
    ///
    func details(
        forPerson personID: Person.ID,
        appending: PersonAppendOption
    ) async throws(TMDbError) -> PersonDetailsResponse {
        try await details(
            forPerson: personID,
            appending: appending,
            language: nil
        )
    }

    ///
    /// Returns the combined movie and TV series credits of a person.
    ///
    /// [TMDb API - People: Combined Credits](https://developer.themoviedb.org/reference/person-combined-credits)
    ///
    /// - Parameter personID: The identifier of the person.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching person's combined movie and TV series credits.
    ///
    /// - Note: This convenience omits `language` rather than defaulting it, so
    /// that its signature stays distinct from the requirement it forwards to. A
    /// defaulted overload would instead become that requirement's default
    /// implementation.
    ///
    func combinedCredits(
        forPerson personID: Person.ID
    ) async throws(TMDbError) -> PersonCombinedCredits {
        try await combinedCredits(forPerson: personID, language: nil)
    }

    ///
    /// Returns the movie credits of a person.
    ///
    /// [TMDb API - People: Movie Credits](https://developer.themoviedb.org/reference/person-movie-credits)
    ///
    /// - Parameter personID: The identifier of the person.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching person's movie credits.
    ///
    /// - Note: This convenience omits `language` rather than defaulting it, so
    /// that its signature stays distinct from the requirement it forwards to. A
    /// defaulted overload would instead become that requirement's default
    /// implementation.
    ///
    func movieCredits(
        forPerson personID: Person.ID
    ) async throws(TMDbError) -> PersonMovieCredits {
        try await movieCredits(forPerson: personID, language: nil)
    }

    ///
    /// Returns the TV series credits of a person.
    ///
    /// [TMDb API - People: TV Credits](https://developer.themoviedb.org/reference/person-tv-credits)
    ///
    /// - Parameter personID: The identifier of the person.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching person's TV series credits.
    ///
    /// - Note: This convenience omits `language` rather than defaulting it, so
    /// that its signature stays distinct from the requirement it forwards to. A
    /// defaulted overload would instead become that requirement's default
    /// implementation.
    ///
    func tvSeriesCredits(
        forPerson personID: Person.ID
    ) async throws(TMDbError) -> PersonTVSeriesCredits {
        try await tvSeriesCredits(forPerson: personID, language: nil)
    }

    ///
    /// Returns the tagged images for a person.
    ///
    /// [TMDb API - People: Tagged Images](https://developer.themoviedb.org/reference/person-tagged-images)
    ///
    /// - Parameter personID: The identifier of the person.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching person's tagged images.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that
    /// its signature stays distinct from the requirement it forwards to. A
    /// defaulted overload would instead become that requirement's default
    /// implementation.
    ///
    func taggedImages(
        forPerson personID: Person.ID
    ) async throws(TMDbError) -> TaggedImagePageableList {
        try await taggedImages(
            forPerson: personID, page: nil
        )
    }

    ///
    /// Returns the latest person added to TMDb.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The latest person.
    ///
    @available(*, deprecated, renamed: "latest()")
    func latestPerson() async throws(TMDbError) -> Person {
        try await latest()
    }

    ///
    /// Returns a list of person IDs that have changed.
    ///
    /// - Parameters:
    ///    - startDate: Filter changes after this date. Interpreted as its GMT calendar day.
    ///    - endDate: Filter changes before this date. Interpreted as its GMT calendar day.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of person IDs that have changed.
    ///
    @available(*, deprecated, renamed: "changes(startDate:endDate:page:)")
    func personChanges(
        startDate: Date? = nil,
        endDate: Date? = nil,
        page: Int? = nil
    ) async throws(TMDbError) -> ChangedIDCollection {
        try await changes(
            startDate: startDate,
            endDate: endDate,
            page: page
        )
    }

}
