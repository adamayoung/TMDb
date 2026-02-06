//
//  ChangesService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Provides an interface for obtaining change data from TMDb.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public protocol ChangesService: Sendable {

    ///
    /// Returns a list of movie IDs that have been changed in the past 24
    /// hours, or within the specified date range.
    ///
    /// [TMDb API - Changes: Movie List](https://developer.themoviedb.org/reference/changes-movie-list)
    ///
    /// - Parameters:
    ///    - startDate: Filter from this date.
    ///    - endDate: Filter to this date.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changed movie IDs.
    ///
    func movieChanges(
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws -> ChangedIDCollection

    ///
    /// Returns a list of TV series IDs that have been changed in the past
    /// 24 hours, or within the specified date range.
    ///
    /// [TMDb API - Changes: TV List](https://developer.themoviedb.org/reference/changes-tv-list)
    ///
    /// - Parameters:
    ///    - startDate: Filter from this date.
    ///    - endDate: Filter to this date.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changed TV series IDs.
    ///
    func tvSeriesChanges(
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws -> ChangedIDCollection

    ///
    /// Returns a list of person IDs that have been changed in the past
    /// 24 hours, or within the specified date range.
    ///
    /// [TMDb API - Changes: Person List](https://developer.themoviedb.org/reference/changes-people-list)
    ///
    /// - Parameters:
    ///    - startDate: Filter from this date.
    ///    - endDate: Filter to this date.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changed person IDs.
    ///
    func personChanges(
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws -> ChangedIDCollection

    ///
    /// Returns the changes for a specific movie.
    ///
    /// [TMDb API - Movies: Changes](https://developer.themoviedb.org/reference/movie-changes)
    ///
    /// - Parameters:
    ///    - id: The identifier of the movie.
    ///    - startDate: Filter from this date.
    ///    - endDate: Filter to this date.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changes for the movie.
    ///
    func movieDetails(
        forMovie id: Movie.ID,
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws -> ChangeCollection

    ///
    /// Returns the changes for a specific TV series.
    ///
    /// [TMDb API - TV Series: Changes](https://developer.themoviedb.org/reference/tv-series-changes)
    ///
    /// - Parameters:
    ///    - id: The identifier of the TV series.
    ///    - startDate: Filter from this date.
    ///    - endDate: Filter to this date.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changes for the TV series.
    ///
    func tvSeriesDetails(
        forTVSeries id: TVSeries.ID,
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws -> ChangeCollection

    ///
    /// Returns the changes for a specific person.
    ///
    /// [TMDb API - People: Changes](https://developer.themoviedb.org/reference/person-changes)
    ///
    /// - Parameters:
    ///    - id: The identifier of the person.
    ///    - startDate: Filter from this date.
    ///    - endDate: Filter to this date.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changes for the person.
    ///
    func personDetails(
        forPerson id: Person.ID,
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws -> ChangeCollection

    ///
    /// Returns the changes for a specific TV season.
    ///
    /// [TMDb API - TV Seasons: Changes](https://developer.themoviedb.org/reference/tv-season-changes-by-id)
    ///
    /// - Parameters:
    ///    - seasonID: The identifier of the TV season.
    ///    - startDate: Filter from this date.
    ///    - endDate: Filter to this date.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changes for the TV season.
    ///
    func tvSeasonDetails(
        forSeason seasonID: Int,
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws -> ChangeCollection

    ///
    /// Returns the changes for a specific TV episode.
    ///
    /// [TMDb API - TV Episodes: Changes](https://developer.themoviedb.org/reference/tv-episode-changes-by-id)
    ///
    /// - Parameters:
    ///    - episodeID: The identifier of the TV episode.
    ///    - startDate: Filter from this date.
    ///    - endDate: Filter to this date.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Changes for the TV episode.
    ///
    func tvEpisodeDetails(
        forEpisode episodeID: Int,
        startDate: Date?,
        endDate: Date?,
        page: Int?
    ) async throws -> ChangeCollection

}

public extension ChangesService {

    func movieChanges(
        startDate: Date? = nil,
        endDate: Date? = nil,
        page: Int? = nil
    ) async throws -> ChangedIDCollection {
        try await movieChanges(
            startDate: startDate,
            endDate: endDate,
            page: page
        )
    }

    func tvSeriesChanges(
        startDate: Date? = nil,
        endDate: Date? = nil,
        page: Int? = nil
    ) async throws -> ChangedIDCollection {
        try await tvSeriesChanges(
            startDate: startDate,
            endDate: endDate,
            page: page
        )
    }

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

    func movieDetails(
        forMovie id: Movie.ID,
        startDate: Date? = nil,
        endDate: Date? = nil,
        page: Int? = nil
    ) async throws -> ChangeCollection {
        try await movieDetails(
            forMovie: id,
            startDate: startDate,
            endDate: endDate,
            page: page
        )
    }

    func tvSeriesDetails(
        forTVSeries id: TVSeries.ID,
        startDate: Date? = nil,
        endDate: Date? = nil,
        page: Int? = nil
    ) async throws -> ChangeCollection {
        try await tvSeriesDetails(
            forTVSeries: id,
            startDate: startDate,
            endDate: endDate,
            page: page
        )
    }

    func personDetails(
        forPerson id: Person.ID,
        startDate: Date? = nil,
        endDate: Date? = nil,
        page: Int? = nil
    ) async throws -> ChangeCollection {
        try await personDetails(
            forPerson: id,
            startDate: startDate,
            endDate: endDate,
            page: page
        )
    }

    func tvSeasonDetails(
        forSeason seasonID: Int,
        startDate: Date? = nil,
        endDate: Date? = nil,
        page: Int? = nil
    ) async throws -> ChangeCollection {
        try await tvSeasonDetails(
            forSeason: seasonID,
            startDate: startDate,
            endDate: endDate,
            page: page
        )
    }

    func tvEpisodeDetails(
        forEpisode episodeID: Int,
        startDate: Date? = nil,
        endDate: Date? = nil,
        page: Int? = nil
    ) async throws -> ChangeCollection {
        try await tvEpisodeDetails(
            forEpisode: episodeID,
            startDate: startDate,
            endDate: endDate,
            page: page
        )
    }

}
