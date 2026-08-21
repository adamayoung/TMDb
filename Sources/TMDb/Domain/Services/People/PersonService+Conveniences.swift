//
//  PersonService+Conveniences.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Shorter forms of the ``PersonService`` requirements.
///
/// Every one of these **drops** parameters rather than defaulting them, and
/// there is one for each combination a caller can leave out. A defaulted
/// overload would share its requirement's signature — default values are not
/// part of a signature for witness matching — and so would silently become that
/// requirement's default implementation, recursing forever for any conformer
/// that omitted it. `Scripts/check-defaulted-witnesses.py` fails the lint if one
/// is ever added here, and equally if one of these overloads is ever removed:
/// dropping a combination is a source break for anyone calling it.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public extension PersonService {

    ///
    /// Returns the recent changes for a person.
    ///
    /// [TMDb API - People: Changes](https://developer.themoviedb.org/reference/person-changes)
    ///
    /// - Parameters:
    ///    - personID: The identifier of the person.
    ///    - startDate: Filter changes after this date. Interpreted as its GMT calendar day.
    ///    - endDate: Filter changes before this date. Interpreted as its GMT calendar day.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of changes for the person.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func changes(
        forPerson personID: Person.ID,
        startDate: Date?,
        endDate: Date?
    ) async throws(TMDbError) -> ChangeCollection {
        try await changes(forPerson: personID, startDate: startDate, endDate: endDate, page: nil)
    }

    ///
    /// Returns the recent changes for a person.
    ///
    /// [TMDb API - People: Changes](https://developer.themoviedb.org/reference/person-changes)
    ///
    /// - Parameters:
    ///    - personID: The identifier of the person.
    ///    - startDate: Filter changes after this date. Interpreted as its GMT calendar day.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of changes for the person.
    ///
    /// - Note: This convenience omits `endDate` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `endDate`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func changes(
        forPerson personID: Person.ID,
        startDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection {
        try await changes(forPerson: personID, startDate: startDate, endDate: nil, page: page)
    }

    ///
    /// Returns the recent changes for a person.
    ///
    /// [TMDb API - People: Changes](https://developer.themoviedb.org/reference/person-changes)
    ///
    /// - Parameters:
    ///    - personID: The identifier of the person.
    ///    - endDate: Filter changes before this date. Interpreted as its GMT calendar day.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of changes for the person.
    ///
    /// - Note: This convenience omits `startDate` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `startDate`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func changes(
        forPerson personID: Person.ID,
        endDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection {
        try await changes(forPerson: personID, startDate: nil, endDate: endDate, page: page)
    }

    ///
    /// Returns the recent changes for a person.
    ///
    /// [TMDb API - People: Changes](https://developer.themoviedb.org/reference/person-changes)
    ///
    /// - Parameters:
    ///    - personID: The identifier of the person.
    ///    - startDate: Filter changes after this date. Interpreted as its GMT calendar day.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of changes for the person.
    ///
    /// - Note: This convenience omits `endDate` and `page` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `endDate` and `page`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func changes(
        forPerson personID: Person.ID,
        startDate: Date?
    ) async throws(TMDbError) -> ChangeCollection {
        try await changes(forPerson: personID, startDate: startDate, endDate: nil, page: nil)
    }

    ///
    /// Returns the recent changes for a person.
    ///
    /// [TMDb API - People: Changes](https://developer.themoviedb.org/reference/person-changes)
    ///
    /// - Parameters:
    ///    - personID: The identifier of the person.
    ///    - endDate: Filter changes before this date. Interpreted as its GMT calendar day.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of changes for the person.
    ///
    /// - Note: This convenience omits `startDate` and `page` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `startDate` and `page`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func changes(
        forPerson personID: Person.ID,
        endDate: Date?
    ) async throws(TMDbError) -> ChangeCollection {
        try await changes(forPerson: personID, startDate: nil, endDate: endDate, page: nil)
    }

    ///
    /// Returns the recent changes for a person.
    ///
    /// [TMDb API - People: Changes](https://developer.themoviedb.org/reference/person-changes)
    ///
    /// - Parameters:
    ///    - personID: The identifier of the person.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of changes for the person.
    ///
    /// - Note: This convenience omits `startDate` and `endDate` rather than defaulting them, so that its signature
    /// stays distinct from the requirement it forwards to; it calls the requirement with `nil` for `startDate` and
    /// `endDate`. A defaulted overload would instead become that requirement's default implementation.
    ///
    func changes(
        forPerson personID: Person.ID,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection {
        try await changes(forPerson: personID, startDate: nil, endDate: nil, page: page)
    }

    ///
    /// Returns the recent changes for a person.
    ///
    /// [TMDb API - People: Changes](https://developer.themoviedb.org/reference/person-changes)
    ///
    /// - Parameter personID: The identifier of the person.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of changes for the person.
    ///
    /// - Note: This convenience omits `startDate`, `endDate` and `page` rather than defaulting them, so that its
    /// signature stays distinct from the requirement it forwards to; it calls the requirement with `nil` for
    /// `startDate`, `endDate` and `page`. A defaulted overload would instead become that requirement's default
    /// implementation.
    ///
    func changes(forPerson personID: Person.ID) async throws(TMDbError) -> ChangeCollection {
        try await changes(forPerson: personID, startDate: nil, endDate: nil, page: nil)
    }

    ///
    /// Returns a list of person IDs that have changed.
    ///
    /// [TMDb API - Changes: People List](https://developer.themoviedb.org/reference/changes-people-list)
    ///
    /// - Parameters:
    ///    - startDate: Filter changes after this date. Interpreted as its GMT calendar day.
    ///    - endDate: Filter changes before this date. Interpreted as its GMT calendar day.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of person IDs that have changed.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func changes(
        startDate: Date?,
        endDate: Date?
    ) async throws(TMDbError) -> ChangedIDCollection {
        try await changes(startDate: startDate, endDate: endDate, page: nil)
    }

    ///
    /// Returns a list of person IDs that have changed.
    ///
    /// [TMDb API - Changes: People List](https://developer.themoviedb.org/reference/changes-people-list)
    ///
    /// - Parameters:
    ///    - startDate: Filter changes after this date. Interpreted as its GMT calendar day.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of person IDs that have changed.
    ///
    /// - Note: This convenience omits `endDate` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `endDate`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func changes(
        startDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangedIDCollection {
        try await changes(startDate: startDate, endDate: nil, page: page)
    }

    ///
    /// Returns a list of person IDs that have changed.
    ///
    /// [TMDb API - Changes: People List](https://developer.themoviedb.org/reference/changes-people-list)
    ///
    /// - Parameters:
    ///    - endDate: Filter changes before this date. Interpreted as its GMT calendar day.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of person IDs that have changed.
    ///
    /// - Note: This convenience omits `startDate` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `startDate`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func changes(
        endDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangedIDCollection {
        try await changes(startDate: nil, endDate: endDate, page: page)
    }

    ///
    /// Returns a list of person IDs that have changed.
    ///
    /// [TMDb API - Changes: People List](https://developer.themoviedb.org/reference/changes-people-list)
    ///
    /// - Parameter startDate: Filter changes after this date. Interpreted as its GMT calendar day.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of person IDs that have changed.
    ///
    /// - Note: This convenience omits `endDate` and `page` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `endDate` and `page`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func changes(startDate: Date?) async throws(TMDbError) -> ChangedIDCollection {
        try await changes(startDate: startDate, endDate: nil, page: nil)
    }

    ///
    /// Returns a list of person IDs that have changed.
    ///
    /// [TMDb API - Changes: People List](https://developer.themoviedb.org/reference/changes-people-list)
    ///
    /// - Parameter endDate: Filter changes before this date. Interpreted as its GMT calendar day.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of person IDs that have changed.
    ///
    /// - Note: This convenience omits `startDate` and `page` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `startDate` and `page`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func changes(endDate: Date?) async throws(TMDbError) -> ChangedIDCollection {
        try await changes(startDate: nil, endDate: endDate, page: nil)
    }

    ///
    /// Returns a list of person IDs that have changed.
    ///
    /// [TMDb API - Changes: People List](https://developer.themoviedb.org/reference/changes-people-list)
    ///
    /// - Parameter page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of person IDs that have changed.
    ///
    /// - Note: This convenience omits `startDate` and `endDate` rather than defaulting them, so that its signature
    /// stays distinct from the requirement it forwards to; it calls the requirement with `nil` for `startDate` and
    /// `endDate`. A defaulted overload would instead become that requirement's default implementation.
    ///
    func changes(page: Int?) async throws(TMDbError) -> ChangedIDCollection {
        try await changes(startDate: nil, endDate: nil, page: page)
    }

    ///
    /// Returns a list of person IDs that have changed.
    ///
    /// [TMDb API - Changes: People List](https://developer.themoviedb.org/reference/changes-people-list)
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of person IDs that have changed.
    ///
    /// - Note: This convenience omits `startDate`, `endDate` and `page` rather than defaulting them, so that its
    /// signature stays distinct from the requirement it forwards to; it calls the requirement with `nil` for
    /// `startDate`, `endDate` and `page`. A defaulted overload would instead become that requirement's default
    /// implementation.
    ///
    func changes() async throws(TMDbError) -> ChangedIDCollection {
        try await changes(startDate: nil, endDate: nil, page: nil)
    }

    ///
    /// Returns the list of popular people.
    ///
    /// [TMDb API - People Lists: Popular](https://developer.themoviedb.org/reference/person-popular-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameter page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Current popular people as a pageable list.
    ///
    /// - Note: This convenience omits `language` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `language`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func popular(page: Int?) async throws(TMDbError) -> PersonPageableList {
        try await popular(page: page, language: nil)
    }

    ///
    /// Returns the list of popular people.
    ///
    /// [TMDb API - People Lists: Popular](https://developer.themoviedb.org/reference/person-popular-list)
    ///
    /// - Parameter language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Current popular people as a pageable list.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func popular(language: String?) async throws(TMDbError) -> PersonPageableList {
        try await popular(page: nil, language: language)
    }

    ///
    /// Returns the list of popular people.
    ///
    /// [TMDb API - People Lists: Popular](https://developer.themoviedb.org/reference/person-popular-list)
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Current popular people as a pageable list.
    ///
    /// - Note: This convenience omits `page` and `language` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `page` and `language`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func popular() async throws(TMDbError) -> PersonPageableList {
        try await popular(page: nil, language: nil)
    }

}
