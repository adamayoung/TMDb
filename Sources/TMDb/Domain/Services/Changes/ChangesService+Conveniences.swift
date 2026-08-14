//
//  ChangesService+Conveniences.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

// swiftlint:disable file_length

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public extension ChangesService {

    ///
    /// Returns a list of movie IDs that have been changed in the past 24
    /// hours, or within the specified date range.
    ///
    /// [TMDb API - Changes: Movie List](https://developer.themoviedb.org/reference/changes-movie-list)
    ///
    /// - Parameters:
    ///    - startDate: Filter from this date.
    ///    - endDate: Filter to this date.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changed movie IDs.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func movieChanges(
        startDate: Date?,
        endDate: Date?
    ) async throws(TMDbError) -> ChangedIDCollection {
        try await movieChanges(startDate: startDate, endDate: endDate, page: nil)
    }

    ///
    /// Returns a list of movie IDs that have been changed in the past 24
    /// hours, or within the specified date range.
    ///
    /// [TMDb API - Changes: Movie List](https://developer.themoviedb.org/reference/changes-movie-list)
    ///
    /// - Parameters:
    ///    - startDate: Filter from this date.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changed movie IDs.
    ///
    /// - Note: This convenience omits `endDate` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `endDate`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func movieChanges(
        startDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangedIDCollection {
        try await movieChanges(startDate: startDate, endDate: nil, page: page)
    }

    ///
    /// Returns a list of movie IDs that have been changed in the past 24
    /// hours, or within the specified date range.
    ///
    /// [TMDb API - Changes: Movie List](https://developer.themoviedb.org/reference/changes-movie-list)
    ///
    /// - Parameters:
    ///    - endDate: Filter to this date.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changed movie IDs.
    ///
    /// - Note: This convenience omits `startDate` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `startDate`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func movieChanges(
        endDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangedIDCollection {
        try await movieChanges(startDate: nil, endDate: endDate, page: page)
    }

    ///
    /// Returns a list of movie IDs that have been changed in the past 24
    /// hours, or within the specified date range.
    ///
    /// [TMDb API - Changes: Movie List](https://developer.themoviedb.org/reference/changes-movie-list)
    ///
    /// - Parameter startDate: Filter from this date.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changed movie IDs.
    ///
    /// - Note: This convenience omits `endDate` and `page` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `endDate` and `page`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func movieChanges(startDate: Date?) async throws(TMDbError) -> ChangedIDCollection {
        try await movieChanges(startDate: startDate, endDate: nil, page: nil)
    }

    ///
    /// Returns a list of movie IDs that have been changed in the past 24
    /// hours, or within the specified date range.
    ///
    /// [TMDb API - Changes: Movie List](https://developer.themoviedb.org/reference/changes-movie-list)
    ///
    /// - Parameter endDate: Filter to this date.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changed movie IDs.
    ///
    /// - Note: This convenience omits `startDate` and `page` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `startDate` and `page`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func movieChanges(endDate: Date?) async throws(TMDbError) -> ChangedIDCollection {
        try await movieChanges(startDate: nil, endDate: endDate, page: nil)
    }

    ///
    /// Returns a list of movie IDs that have been changed in the past 24
    /// hours, or within the specified date range.
    ///
    /// [TMDb API - Changes: Movie List](https://developer.themoviedb.org/reference/changes-movie-list)
    ///
    /// - Parameter page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changed movie IDs.
    ///
    /// - Note: This convenience omits `startDate` and `endDate` rather than defaulting them, so that its signature
    /// stays distinct from the requirement it forwards to; it calls the requirement with `nil` for `startDate` and
    /// `endDate`. A defaulted overload would instead become that requirement's default implementation.
    ///
    func movieChanges(page: Int?) async throws(TMDbError) -> ChangedIDCollection {
        try await movieChanges(startDate: nil, endDate: nil, page: page)
    }

    ///
    /// Returns a list of movie IDs that have been changed in the past 24
    /// hours, or within the specified date range.
    ///
    /// [TMDb API - Changes: Movie List](https://developer.themoviedb.org/reference/changes-movie-list)
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changed movie IDs.
    ///
    /// - Note: This convenience omits `startDate`, `endDate` and `page` rather than defaulting them, so that its
    /// signature stays distinct from the requirement it forwards to; it calls the requirement with `nil` for
    /// `startDate`, `endDate` and `page`. A defaulted overload would instead become that requirement's default
    /// implementation.
    ///
    func movieChanges() async throws(TMDbError) -> ChangedIDCollection {
        try await movieChanges(startDate: nil, endDate: nil, page: nil)
    }

    ///
    /// Returns the changes for a specific movie.
    ///
    /// [TMDb API - Movies: Changes](https://developer.themoviedb.org/reference/movie-changes)
    ///
    /// - Parameters:
    ///    - id: The identifier of the movie.
    ///    - startDate: Filter from this date.
    ///    - endDate: Filter to this date.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changes for the movie.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func movieDetails(
        forMovie id: Movie.ID,
        startDate: Date?,
        endDate: Date?
    ) async throws(TMDbError) -> ChangeCollection {
        try await movieDetails(forMovie: id, startDate: startDate, endDate: endDate, page: nil)
    }

    ///
    /// Returns the changes for a specific movie.
    ///
    /// [TMDb API - Movies: Changes](https://developer.themoviedb.org/reference/movie-changes)
    ///
    /// - Parameters:
    ///    - id: The identifier of the movie.
    ///    - startDate: Filter from this date.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changes for the movie.
    ///
    /// - Note: This convenience omits `endDate` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `endDate`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func movieDetails(
        forMovie id: Movie.ID,
        startDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection {
        try await movieDetails(forMovie: id, startDate: startDate, endDate: nil, page: page)
    }

    ///
    /// Returns the changes for a specific movie.
    ///
    /// [TMDb API - Movies: Changes](https://developer.themoviedb.org/reference/movie-changes)
    ///
    /// - Parameters:
    ///    - id: The identifier of the movie.
    ///    - endDate: Filter to this date.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changes for the movie.
    ///
    /// - Note: This convenience omits `startDate` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `startDate`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func movieDetails(
        forMovie id: Movie.ID,
        endDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection {
        try await movieDetails(forMovie: id, startDate: nil, endDate: endDate, page: page)
    }

    ///
    /// Returns the changes for a specific movie.
    ///
    /// [TMDb API - Movies: Changes](https://developer.themoviedb.org/reference/movie-changes)
    ///
    /// - Parameters:
    ///    - id: The identifier of the movie.
    ///    - startDate: Filter from this date.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changes for the movie.
    ///
    /// - Note: This convenience omits `endDate` and `page` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `endDate` and `page`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func movieDetails(
        forMovie id: Movie.ID,
        startDate: Date?
    ) async throws(TMDbError) -> ChangeCollection {
        try await movieDetails(forMovie: id, startDate: startDate, endDate: nil, page: nil)
    }

    ///
    /// Returns the changes for a specific movie.
    ///
    /// [TMDb API - Movies: Changes](https://developer.themoviedb.org/reference/movie-changes)
    ///
    /// - Parameters:
    ///    - id: The identifier of the movie.
    ///    - endDate: Filter to this date.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changes for the movie.
    ///
    /// - Note: This convenience omits `startDate` and `page` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `startDate` and `page`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func movieDetails(
        forMovie id: Movie.ID,
        endDate: Date?
    ) async throws(TMDbError) -> ChangeCollection {
        try await movieDetails(forMovie: id, startDate: nil, endDate: endDate, page: nil)
    }

    ///
    /// Returns the changes for a specific movie.
    ///
    /// [TMDb API - Movies: Changes](https://developer.themoviedb.org/reference/movie-changes)
    ///
    /// - Parameters:
    ///    - id: The identifier of the movie.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changes for the movie.
    ///
    /// - Note: This convenience omits `startDate` and `endDate` rather than defaulting them, so that its signature
    /// stays distinct from the requirement it forwards to; it calls the requirement with `nil` for `startDate` and
    /// `endDate`. A defaulted overload would instead become that requirement's default implementation.
    ///
    func movieDetails(
        forMovie id: Movie.ID,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection {
        try await movieDetails(forMovie: id, startDate: nil, endDate: nil, page: page)
    }

    ///
    /// Returns the changes for a specific movie.
    ///
    /// [TMDb API - Movies: Changes](https://developer.themoviedb.org/reference/movie-changes)
    ///
    /// - Parameter id: The identifier of the movie.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changes for the movie.
    ///
    /// - Note: This convenience omits `startDate`, `endDate` and `page` rather than defaulting them, so that its
    /// signature stays distinct from the requirement it forwards to; it calls the requirement with `nil` for
    /// `startDate`, `endDate` and `page`. A defaulted overload would instead become that requirement's default
    /// implementation.
    ///
    func movieDetails(forMovie id: Movie.ID) async throws(TMDbError) -> ChangeCollection {
        try await movieDetails(forMovie: id, startDate: nil, endDate: nil, page: nil)
    }

    ///
    /// Returns a list of person IDs that have been changed in the past
    /// 24 hours, or within the specified date range.
    ///
    /// [TMDb API - Changes: Person List](https://developer.themoviedb.org/reference/changes-people-list)
    ///
    /// - Parameters:
    ///    - startDate: Filter from this date.
    ///    - endDate: Filter to this date.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changed person IDs.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func personChanges(
        startDate: Date?,
        endDate: Date?
    ) async throws(TMDbError) -> ChangedIDCollection {
        try await personChanges(startDate: startDate, endDate: endDate, page: nil)
    }

    ///
    /// Returns a list of person IDs that have been changed in the past
    /// 24 hours, or within the specified date range.
    ///
    /// [TMDb API - Changes: Person List](https://developer.themoviedb.org/reference/changes-people-list)
    ///
    /// - Parameters:
    ///    - startDate: Filter from this date.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changed person IDs.
    ///
    /// - Note: This convenience omits `endDate` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `endDate`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func personChanges(
        startDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangedIDCollection {
        try await personChanges(startDate: startDate, endDate: nil, page: page)
    }

    ///
    /// Returns a list of person IDs that have been changed in the past
    /// 24 hours, or within the specified date range.
    ///
    /// [TMDb API - Changes: Person List](https://developer.themoviedb.org/reference/changes-people-list)
    ///
    /// - Parameters:
    ///    - endDate: Filter to this date.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changed person IDs.
    ///
    /// - Note: This convenience omits `startDate` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `startDate`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func personChanges(
        endDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangedIDCollection {
        try await personChanges(startDate: nil, endDate: endDate, page: page)
    }

    ///
    /// Returns a list of person IDs that have been changed in the past
    /// 24 hours, or within the specified date range.
    ///
    /// [TMDb API - Changes: Person List](https://developer.themoviedb.org/reference/changes-people-list)
    ///
    /// - Parameter startDate: Filter from this date.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changed person IDs.
    ///
    /// - Note: This convenience omits `endDate` and `page` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `endDate` and `page`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func personChanges(startDate: Date?) async throws(TMDbError) -> ChangedIDCollection {
        try await personChanges(startDate: startDate, endDate: nil, page: nil)
    }

    ///
    /// Returns a list of person IDs that have been changed in the past
    /// 24 hours, or within the specified date range.
    ///
    /// [TMDb API - Changes: Person List](https://developer.themoviedb.org/reference/changes-people-list)
    ///
    /// - Parameter endDate: Filter to this date.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changed person IDs.
    ///
    /// - Note: This convenience omits `startDate` and `page` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `startDate` and `page`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func personChanges(endDate: Date?) async throws(TMDbError) -> ChangedIDCollection {
        try await personChanges(startDate: nil, endDate: endDate, page: nil)
    }

    ///
    /// Returns a list of person IDs that have been changed in the past
    /// 24 hours, or within the specified date range.
    ///
    /// [TMDb API - Changes: Person List](https://developer.themoviedb.org/reference/changes-people-list)
    ///
    /// - Parameter page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changed person IDs.
    ///
    /// - Note: This convenience omits `startDate` and `endDate` rather than defaulting them, so that its signature
    /// stays distinct from the requirement it forwards to; it calls the requirement with `nil` for `startDate` and
    /// `endDate`. A defaulted overload would instead become that requirement's default implementation.
    ///
    func personChanges(page: Int?) async throws(TMDbError) -> ChangedIDCollection {
        try await personChanges(startDate: nil, endDate: nil, page: page)
    }

    ///
    /// Returns a list of person IDs that have been changed in the past
    /// 24 hours, or within the specified date range.
    ///
    /// [TMDb API - Changes: Person List](https://developer.themoviedb.org/reference/changes-people-list)
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changed person IDs.
    ///
    /// - Note: This convenience omits `startDate`, `endDate` and `page` rather than defaulting them, so that its
    /// signature stays distinct from the requirement it forwards to; it calls the requirement with `nil` for
    /// `startDate`, `endDate` and `page`. A defaulted overload would instead become that requirement's default
    /// implementation.
    ///
    func personChanges() async throws(TMDbError) -> ChangedIDCollection {
        try await personChanges(startDate: nil, endDate: nil, page: nil)
    }

    ///
    /// Returns the changes for a specific person.
    ///
    /// [TMDb API - People: Changes](https://developer.themoviedb.org/reference/person-changes)
    ///
    /// - Parameters:
    ///    - id: The identifier of the person.
    ///    - startDate: Filter from this date.
    ///    - endDate: Filter to this date.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changes for the person.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func personDetails(
        forPerson id: Person.ID,
        startDate: Date?,
        endDate: Date?
    ) async throws(TMDbError) -> ChangeCollection {
        try await personDetails(forPerson: id, startDate: startDate, endDate: endDate, page: nil)
    }

    ///
    /// Returns the changes for a specific person.
    ///
    /// [TMDb API - People: Changes](https://developer.themoviedb.org/reference/person-changes)
    ///
    /// - Parameters:
    ///    - id: The identifier of the person.
    ///    - startDate: Filter from this date.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changes for the person.
    ///
    /// - Note: This convenience omits `endDate` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `endDate`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func personDetails(
        forPerson id: Person.ID,
        startDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection {
        try await personDetails(forPerson: id, startDate: startDate, endDate: nil, page: page)
    }

    ///
    /// Returns the changes for a specific person.
    ///
    /// [TMDb API - People: Changes](https://developer.themoviedb.org/reference/person-changes)
    ///
    /// - Parameters:
    ///    - id: The identifier of the person.
    ///    - endDate: Filter to this date.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changes for the person.
    ///
    /// - Note: This convenience omits `startDate` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `startDate`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func personDetails(
        forPerson id: Person.ID,
        endDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection {
        try await personDetails(forPerson: id, startDate: nil, endDate: endDate, page: page)
    }

    ///
    /// Returns the changes for a specific person.
    ///
    /// [TMDb API - People: Changes](https://developer.themoviedb.org/reference/person-changes)
    ///
    /// - Parameters:
    ///    - id: The identifier of the person.
    ///    - startDate: Filter from this date.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changes for the person.
    ///
    /// - Note: This convenience omits `endDate` and `page` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `endDate` and `page`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func personDetails(
        forPerson id: Person.ID,
        startDate: Date?
    ) async throws(TMDbError) -> ChangeCollection {
        try await personDetails(forPerson: id, startDate: startDate, endDate: nil, page: nil)
    }

    ///
    /// Returns the changes for a specific person.
    ///
    /// [TMDb API - People: Changes](https://developer.themoviedb.org/reference/person-changes)
    ///
    /// - Parameters:
    ///    - id: The identifier of the person.
    ///    - endDate: Filter to this date.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changes for the person.
    ///
    /// - Note: This convenience omits `startDate` and `page` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `startDate` and `page`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func personDetails(
        forPerson id: Person.ID,
        endDate: Date?
    ) async throws(TMDbError) -> ChangeCollection {
        try await personDetails(forPerson: id, startDate: nil, endDate: endDate, page: nil)
    }

    ///
    /// Returns the changes for a specific person.
    ///
    /// [TMDb API - People: Changes](https://developer.themoviedb.org/reference/person-changes)
    ///
    /// - Parameters:
    ///    - id: The identifier of the person.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changes for the person.
    ///
    /// - Note: This convenience omits `startDate` and `endDate` rather than defaulting them, so that its signature
    /// stays distinct from the requirement it forwards to; it calls the requirement with `nil` for `startDate` and
    /// `endDate`. A defaulted overload would instead become that requirement's default implementation.
    ///
    func personDetails(
        forPerson id: Person.ID,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection {
        try await personDetails(forPerson: id, startDate: nil, endDate: nil, page: page)
    }

    ///
    /// Returns the changes for a specific person.
    ///
    /// [TMDb API - People: Changes](https://developer.themoviedb.org/reference/person-changes)
    ///
    /// - Parameter id: The identifier of the person.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changes for the person.
    ///
    /// - Note: This convenience omits `startDate`, `endDate` and `page` rather than defaulting them, so that its
    /// signature stays distinct from the requirement it forwards to; it calls the requirement with `nil` for
    /// `startDate`, `endDate` and `page`. A defaulted overload would instead become that requirement's default
    /// implementation.
    ///
    func personDetails(forPerson id: Person.ID) async throws(TMDbError) -> ChangeCollection {
        try await personDetails(forPerson: id, startDate: nil, endDate: nil, page: nil)
    }

    ///
    /// Returns the changes for a specific TV episode.
    ///
    /// [TMDb API - TV Episodes: Changes](https://developer.themoviedb.org/reference/tv-episode-changes-by-id)
    ///
    /// - Parameters:
    ///    - episodeID: The identifier of the TV episode.
    ///    - startDate: Filter from this date.
    ///    - endDate: Filter to this date.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changes for the TV episode.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func tvEpisodeDetails(
        forEpisode episodeID: Int,
        startDate: Date?,
        endDate: Date?
    ) async throws(TMDbError) -> ChangeCollection {
        try await tvEpisodeDetails(forEpisode: episodeID, startDate: startDate, endDate: endDate, page: nil)
    }

    ///
    /// Returns the changes for a specific TV episode.
    ///
    /// [TMDb API - TV Episodes: Changes](https://developer.themoviedb.org/reference/tv-episode-changes-by-id)
    ///
    /// - Parameters:
    ///    - episodeID: The identifier of the TV episode.
    ///    - startDate: Filter from this date.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changes for the TV episode.
    ///
    /// - Note: This convenience omits `endDate` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `endDate`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func tvEpisodeDetails(
        forEpisode episodeID: Int,
        startDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection {
        try await tvEpisodeDetails(forEpisode: episodeID, startDate: startDate, endDate: nil, page: page)
    }

    ///
    /// Returns the changes for a specific TV episode.
    ///
    /// [TMDb API - TV Episodes: Changes](https://developer.themoviedb.org/reference/tv-episode-changes-by-id)
    ///
    /// - Parameters:
    ///    - episodeID: The identifier of the TV episode.
    ///    - endDate: Filter to this date.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changes for the TV episode.
    ///
    /// - Note: This convenience omits `startDate` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `startDate`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func tvEpisodeDetails(
        forEpisode episodeID: Int,
        endDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection {
        try await tvEpisodeDetails(forEpisode: episodeID, startDate: nil, endDate: endDate, page: page)
    }

    ///
    /// Returns the changes for a specific TV episode.
    ///
    /// [TMDb API - TV Episodes: Changes](https://developer.themoviedb.org/reference/tv-episode-changes-by-id)
    ///
    /// - Parameters:
    ///    - episodeID: The identifier of the TV episode.
    ///    - startDate: Filter from this date.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changes for the TV episode.
    ///
    /// - Note: This convenience omits `endDate` and `page` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `endDate` and `page`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func tvEpisodeDetails(
        forEpisode episodeID: Int,
        startDate: Date?
    ) async throws(TMDbError) -> ChangeCollection {
        try await tvEpisodeDetails(forEpisode: episodeID, startDate: startDate, endDate: nil, page: nil)
    }

    ///
    /// Returns the changes for a specific TV episode.
    ///
    /// [TMDb API - TV Episodes: Changes](https://developer.themoviedb.org/reference/tv-episode-changes-by-id)
    ///
    /// - Parameters:
    ///    - episodeID: The identifier of the TV episode.
    ///    - endDate: Filter to this date.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changes for the TV episode.
    ///
    /// - Note: This convenience omits `startDate` and `page` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `startDate` and `page`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func tvEpisodeDetails(
        forEpisode episodeID: Int,
        endDate: Date?
    ) async throws(TMDbError) -> ChangeCollection {
        try await tvEpisodeDetails(forEpisode: episodeID, startDate: nil, endDate: endDate, page: nil)
    }

    ///
    /// Returns the changes for a specific TV episode.
    ///
    /// [TMDb API - TV Episodes: Changes](https://developer.themoviedb.org/reference/tv-episode-changes-by-id)
    ///
    /// - Parameters:
    ///    - episodeID: The identifier of the TV episode.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changes for the TV episode.
    ///
    /// - Note: This convenience omits `startDate` and `endDate` rather than defaulting them, so that its signature
    /// stays distinct from the requirement it forwards to; it calls the requirement with `nil` for `startDate` and
    /// `endDate`. A defaulted overload would instead become that requirement's default implementation.
    ///
    func tvEpisodeDetails(
        forEpisode episodeID: Int,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection {
        try await tvEpisodeDetails(forEpisode: episodeID, startDate: nil, endDate: nil, page: page)
    }

    ///
    /// Returns the changes for a specific TV episode.
    ///
    /// [TMDb API - TV Episodes: Changes](https://developer.themoviedb.org/reference/tv-episode-changes-by-id)
    ///
    /// - Parameter episodeID: The identifier of the TV episode.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changes for the TV episode.
    ///
    /// - Note: This convenience omits `startDate`, `endDate` and `page` rather than defaulting them, so that its
    /// signature stays distinct from the requirement it forwards to; it calls the requirement with `nil` for
    /// `startDate`, `endDate` and `page`. A defaulted overload would instead become that requirement's default
    /// implementation.
    ///
    func tvEpisodeDetails(forEpisode episodeID: Int) async throws(TMDbError) -> ChangeCollection {
        try await tvEpisodeDetails(forEpisode: episodeID, startDate: nil, endDate: nil, page: nil)
    }

    ///
    /// Returns the changes for a specific TV season.
    ///
    /// [TMDb API - TV Seasons: Changes](https://developer.themoviedb.org/reference/tv-season-changes-by-id)
    ///
    /// - Parameters:
    ///    - seasonID: The identifier of the TV season.
    ///    - startDate: Filter from this date.
    ///    - endDate: Filter to this date.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changes for the TV season.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func tvSeasonDetails(
        forSeason seasonID: Int,
        startDate: Date?,
        endDate: Date?
    ) async throws(TMDbError) -> ChangeCollection {
        try await tvSeasonDetails(forSeason: seasonID, startDate: startDate, endDate: endDate, page: nil)
    }

    ///
    /// Returns the changes for a specific TV season.
    ///
    /// [TMDb API - TV Seasons: Changes](https://developer.themoviedb.org/reference/tv-season-changes-by-id)
    ///
    /// - Parameters:
    ///    - seasonID: The identifier of the TV season.
    ///    - startDate: Filter from this date.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changes for the TV season.
    ///
    /// - Note: This convenience omits `endDate` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `endDate`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func tvSeasonDetails(
        forSeason seasonID: Int,
        startDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection {
        try await tvSeasonDetails(forSeason: seasonID, startDate: startDate, endDate: nil, page: page)
    }

    ///
    /// Returns the changes for a specific TV season.
    ///
    /// [TMDb API - TV Seasons: Changes](https://developer.themoviedb.org/reference/tv-season-changes-by-id)
    ///
    /// - Parameters:
    ///    - seasonID: The identifier of the TV season.
    ///    - endDate: Filter to this date.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changes for the TV season.
    ///
    /// - Note: This convenience omits `startDate` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `startDate`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func tvSeasonDetails(
        forSeason seasonID: Int,
        endDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection {
        try await tvSeasonDetails(forSeason: seasonID, startDate: nil, endDate: endDate, page: page)
    }

    ///
    /// Returns the changes for a specific TV season.
    ///
    /// [TMDb API - TV Seasons: Changes](https://developer.themoviedb.org/reference/tv-season-changes-by-id)
    ///
    /// - Parameters:
    ///    - seasonID: The identifier of the TV season.
    ///    - startDate: Filter from this date.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changes for the TV season.
    ///
    /// - Note: This convenience omits `endDate` and `page` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `endDate` and `page`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func tvSeasonDetails(
        forSeason seasonID: Int,
        startDate: Date?
    ) async throws(TMDbError) -> ChangeCollection {
        try await tvSeasonDetails(forSeason: seasonID, startDate: startDate, endDate: nil, page: nil)
    }

    ///
    /// Returns the changes for a specific TV season.
    ///
    /// [TMDb API - TV Seasons: Changes](https://developer.themoviedb.org/reference/tv-season-changes-by-id)
    ///
    /// - Parameters:
    ///    - seasonID: The identifier of the TV season.
    ///    - endDate: Filter to this date.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changes for the TV season.
    ///
    /// - Note: This convenience omits `startDate` and `page` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `startDate` and `page`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func tvSeasonDetails(
        forSeason seasonID: Int,
        endDate: Date?
    ) async throws(TMDbError) -> ChangeCollection {
        try await tvSeasonDetails(forSeason: seasonID, startDate: nil, endDate: endDate, page: nil)
    }

    ///
    /// Returns the changes for a specific TV season.
    ///
    /// [TMDb API - TV Seasons: Changes](https://developer.themoviedb.org/reference/tv-season-changes-by-id)
    ///
    /// - Parameters:
    ///    - seasonID: The identifier of the TV season.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changes for the TV season.
    ///
    /// - Note: This convenience omits `startDate` and `endDate` rather than defaulting them, so that its signature
    /// stays distinct from the requirement it forwards to; it calls the requirement with `nil` for `startDate` and
    /// `endDate`. A defaulted overload would instead become that requirement's default implementation.
    ///
    func tvSeasonDetails(
        forSeason seasonID: Int,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection {
        try await tvSeasonDetails(forSeason: seasonID, startDate: nil, endDate: nil, page: page)
    }

    ///
    /// Returns the changes for a specific TV season.
    ///
    /// [TMDb API - TV Seasons: Changes](https://developer.themoviedb.org/reference/tv-season-changes-by-id)
    ///
    /// - Parameter seasonID: The identifier of the TV season.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changes for the TV season.
    ///
    /// - Note: This convenience omits `startDate`, `endDate` and `page` rather than defaulting them, so that its
    /// signature stays distinct from the requirement it forwards to; it calls the requirement with `nil` for
    /// `startDate`, `endDate` and `page`. A defaulted overload would instead become that requirement's default
    /// implementation.
    ///
    func tvSeasonDetails(forSeason seasonID: Int) async throws(TMDbError) -> ChangeCollection {
        try await tvSeasonDetails(forSeason: seasonID, startDate: nil, endDate: nil, page: nil)
    }

    ///
    /// Returns a list of TV series IDs that have been changed in the past
    /// 24 hours, or within the specified date range.
    ///
    /// [TMDb API - Changes: TV List](https://developer.themoviedb.org/reference/changes-tv-list)
    ///
    /// - Parameters:
    ///    - startDate: Filter from this date.
    ///    - endDate: Filter to this date.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changed TV series IDs.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func tvSeriesChanges(
        startDate: Date?,
        endDate: Date?
    ) async throws(TMDbError) -> ChangedIDCollection {
        try await tvSeriesChanges(startDate: startDate, endDate: endDate, page: nil)
    }

    ///
    /// Returns a list of TV series IDs that have been changed in the past
    /// 24 hours, or within the specified date range.
    ///
    /// [TMDb API - Changes: TV List](https://developer.themoviedb.org/reference/changes-tv-list)
    ///
    /// - Parameters:
    ///    - startDate: Filter from this date.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changed TV series IDs.
    ///
    /// - Note: This convenience omits `endDate` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `endDate`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func tvSeriesChanges(
        startDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangedIDCollection {
        try await tvSeriesChanges(startDate: startDate, endDate: nil, page: page)
    }

    ///
    /// Returns a list of TV series IDs that have been changed in the past
    /// 24 hours, or within the specified date range.
    ///
    /// [TMDb API - Changes: TV List](https://developer.themoviedb.org/reference/changes-tv-list)
    ///
    /// - Parameters:
    ///    - endDate: Filter to this date.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changed TV series IDs.
    ///
    /// - Note: This convenience omits `startDate` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `startDate`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func tvSeriesChanges(
        endDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangedIDCollection {
        try await tvSeriesChanges(startDate: nil, endDate: endDate, page: page)
    }

    ///
    /// Returns a list of TV series IDs that have been changed in the past
    /// 24 hours, or within the specified date range.
    ///
    /// [TMDb API - Changes: TV List](https://developer.themoviedb.org/reference/changes-tv-list)
    ///
    /// - Parameter startDate: Filter from this date.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changed TV series IDs.
    ///
    /// - Note: This convenience omits `endDate` and `page` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `endDate` and `page`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func tvSeriesChanges(startDate: Date?) async throws(TMDbError) -> ChangedIDCollection {
        try await tvSeriesChanges(startDate: startDate, endDate: nil, page: nil)
    }

    ///
    /// Returns a list of TV series IDs that have been changed in the past
    /// 24 hours, or within the specified date range.
    ///
    /// [TMDb API - Changes: TV List](https://developer.themoviedb.org/reference/changes-tv-list)
    ///
    /// - Parameter endDate: Filter to this date.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changed TV series IDs.
    ///
    /// - Note: This convenience omits `startDate` and `page` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `startDate` and `page`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func tvSeriesChanges(endDate: Date?) async throws(TMDbError) -> ChangedIDCollection {
        try await tvSeriesChanges(startDate: nil, endDate: endDate, page: nil)
    }

    ///
    /// Returns a list of TV series IDs that have been changed in the past
    /// 24 hours, or within the specified date range.
    ///
    /// [TMDb API - Changes: TV List](https://developer.themoviedb.org/reference/changes-tv-list)
    ///
    /// - Parameter page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changed TV series IDs.
    ///
    /// - Note: This convenience omits `startDate` and `endDate` rather than defaulting them, so that its signature
    /// stays distinct from the requirement it forwards to; it calls the requirement with `nil` for `startDate` and
    /// `endDate`. A defaulted overload would instead become that requirement's default implementation.
    ///
    func tvSeriesChanges(page: Int?) async throws(TMDbError) -> ChangedIDCollection {
        try await tvSeriesChanges(startDate: nil, endDate: nil, page: page)
    }

    ///
    /// Returns a list of TV series IDs that have been changed in the past
    /// 24 hours, or within the specified date range.
    ///
    /// [TMDb API - Changes: TV List](https://developer.themoviedb.org/reference/changes-tv-list)
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changed TV series IDs.
    ///
    /// - Note: This convenience omits `startDate`, `endDate` and `page` rather than defaulting them, so that its
    /// signature stays distinct from the requirement it forwards to; it calls the requirement with `nil` for
    /// `startDate`, `endDate` and `page`. A defaulted overload would instead become that requirement's default
    /// implementation.
    ///
    func tvSeriesChanges() async throws(TMDbError) -> ChangedIDCollection {
        try await tvSeriesChanges(startDate: nil, endDate: nil, page: nil)
    }

    ///
    /// Returns the changes for a specific TV series.
    ///
    /// [TMDb API - TV Series: Changes](https://developer.themoviedb.org/reference/tv-series-changes)
    ///
    /// - Parameters:
    ///    - id: The identifier of the TV series.
    ///    - startDate: Filter from this date.
    ///    - endDate: Filter to this date.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changes for the TV series.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func tvSeriesDetails(
        forTVSeries id: TVSeries.ID,
        startDate: Date?,
        endDate: Date?
    ) async throws(TMDbError) -> ChangeCollection {
        try await tvSeriesDetails(forTVSeries: id, startDate: startDate, endDate: endDate, page: nil)
    }

    ///
    /// Returns the changes for a specific TV series.
    ///
    /// [TMDb API - TV Series: Changes](https://developer.themoviedb.org/reference/tv-series-changes)
    ///
    /// - Parameters:
    ///    - id: The identifier of the TV series.
    ///    - startDate: Filter from this date.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changes for the TV series.
    ///
    /// - Note: This convenience omits `endDate` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `endDate`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func tvSeriesDetails(
        forTVSeries id: TVSeries.ID,
        startDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection {
        try await tvSeriesDetails(forTVSeries: id, startDate: startDate, endDate: nil, page: page)
    }

    ///
    /// Returns the changes for a specific TV series.
    ///
    /// [TMDb API - TV Series: Changes](https://developer.themoviedb.org/reference/tv-series-changes)
    ///
    /// - Parameters:
    ///    - id: The identifier of the TV series.
    ///    - endDate: Filter to this date.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changes for the TV series.
    ///
    /// - Note: This convenience omits `startDate` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `startDate`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func tvSeriesDetails(
        forTVSeries id: TVSeries.ID,
        endDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection {
        try await tvSeriesDetails(forTVSeries: id, startDate: nil, endDate: endDate, page: page)
    }

    ///
    /// Returns the changes for a specific TV series.
    ///
    /// [TMDb API - TV Series: Changes](https://developer.themoviedb.org/reference/tv-series-changes)
    ///
    /// - Parameters:
    ///    - id: The identifier of the TV series.
    ///    - startDate: Filter from this date.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changes for the TV series.
    ///
    /// - Note: This convenience omits `endDate` and `page` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `endDate` and `page`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func tvSeriesDetails(
        forTVSeries id: TVSeries.ID,
        startDate: Date?
    ) async throws(TMDbError) -> ChangeCollection {
        try await tvSeriesDetails(forTVSeries: id, startDate: startDate, endDate: nil, page: nil)
    }

    ///
    /// Returns the changes for a specific TV series.
    ///
    /// [TMDb API - TV Series: Changes](https://developer.themoviedb.org/reference/tv-series-changes)
    ///
    /// - Parameters:
    ///    - id: The identifier of the TV series.
    ///    - endDate: Filter to this date.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changes for the TV series.
    ///
    /// - Note: This convenience omits `startDate` and `page` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `startDate` and `page`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func tvSeriesDetails(
        forTVSeries id: TVSeries.ID,
        endDate: Date?
    ) async throws(TMDbError) -> ChangeCollection {
        try await tvSeriesDetails(forTVSeries: id, startDate: nil, endDate: endDate, page: nil)
    }

    ///
    /// Returns the changes for a specific TV series.
    ///
    /// [TMDb API - TV Series: Changes](https://developer.themoviedb.org/reference/tv-series-changes)
    ///
    /// - Parameters:
    ///    - id: The identifier of the TV series.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changes for the TV series.
    ///
    /// - Note: This convenience omits `startDate` and `endDate` rather than defaulting them, so that its signature
    /// stays distinct from the requirement it forwards to; it calls the requirement with `nil` for `startDate` and
    /// `endDate`. A defaulted overload would instead become that requirement's default implementation.
    ///
    func tvSeriesDetails(
        forTVSeries id: TVSeries.ID,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection {
        try await tvSeriesDetails(forTVSeries: id, startDate: nil, endDate: nil, page: page)
    }

    ///
    /// Returns the changes for a specific TV series.
    ///
    /// [TMDb API - TV Series: Changes](https://developer.themoviedb.org/reference/tv-series-changes)
    ///
    /// - Parameter id: The identifier of the TV series.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changes for the TV series.
    ///
    /// - Note: This convenience omits `startDate`, `endDate` and `page` rather than defaulting them, so that its
    /// signature stays distinct from the requirement it forwards to; it calls the requirement with `nil` for
    /// `startDate`, `endDate` and `page`. A defaulted overload would instead become that requirement's default
    /// implementation.
    ///
    func tvSeriesDetails(forTVSeries id: TVSeries.ID) async throws(TMDbError) -> ChangeCollection {
        try await tvSeriesDetails(forTVSeries: id, startDate: nil, endDate: nil, page: nil)
    }

}
