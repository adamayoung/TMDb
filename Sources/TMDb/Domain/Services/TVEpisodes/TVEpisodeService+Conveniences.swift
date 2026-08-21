//
//  TVEpisodeService+Conveniences.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Shorter forms of the ``TVEpisodeService`` requirements.
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
public extension TVEpisodeService {

    ///
    /// Returns change history for a TV episode.
    ///
    /// [TMDb API - TV Episode:
    /// Changes](https://developer.themoviedb.org/reference/tv-episode-changes-by-id)
    ///
    /// - Parameters:
    ///    - episodeID: The identifier of the TV episode.
    ///    - startDate: The start date for changes. Interpreted as its GMT calendar day.
    ///    - endDate: The end date for changes. Interpreted as its GMT calendar day.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of changes for the TV episode.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func changes(
        forEpisode episodeID: Int,
        startDate: Date?,
        endDate: Date?
    ) async throws(TMDbError) -> ChangeCollection {
        try await changes(forEpisode: episodeID, startDate: startDate, endDate: endDate, page: nil)
    }

    ///
    /// Returns change history for a TV episode.
    ///
    /// [TMDb API - TV Episode:
    /// Changes](https://developer.themoviedb.org/reference/tv-episode-changes-by-id)
    ///
    /// - Parameters:
    ///    - episodeID: The identifier of the TV episode.
    ///    - startDate: The start date for changes. Interpreted as its GMT calendar day.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of changes for the TV episode.
    ///
    /// - Note: This convenience omits `endDate` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `endDate`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func changes(
        forEpisode episodeID: Int,
        startDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection {
        try await changes(forEpisode: episodeID, startDate: startDate, endDate: nil, page: page)
    }

    ///
    /// Returns change history for a TV episode.
    ///
    /// [TMDb API - TV Episode:
    /// Changes](https://developer.themoviedb.org/reference/tv-episode-changes-by-id)
    ///
    /// - Parameters:
    ///    - episodeID: The identifier of the TV episode.
    ///    - endDate: The end date for changes. Interpreted as its GMT calendar day.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of changes for the TV episode.
    ///
    /// - Note: This convenience omits `startDate` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `startDate`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func changes(
        forEpisode episodeID: Int,
        endDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection {
        try await changes(forEpisode: episodeID, startDate: nil, endDate: endDate, page: page)
    }

    ///
    /// Returns change history for a TV episode.
    ///
    /// [TMDb API - TV Episode:
    /// Changes](https://developer.themoviedb.org/reference/tv-episode-changes-by-id)
    ///
    /// - Parameters:
    ///    - episodeID: The identifier of the TV episode.
    ///    - startDate: The start date for changes. Interpreted as its GMT calendar day.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of changes for the TV episode.
    ///
    /// - Note: This convenience omits `endDate` and `page` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `endDate` and `page`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func changes(
        forEpisode episodeID: Int,
        startDate: Date?
    ) async throws(TMDbError) -> ChangeCollection {
        try await changes(forEpisode: episodeID, startDate: startDate, endDate: nil, page: nil)
    }

    ///
    /// Returns change history for a TV episode.
    ///
    /// [TMDb API - TV Episode:
    /// Changes](https://developer.themoviedb.org/reference/tv-episode-changes-by-id)
    ///
    /// - Parameters:
    ///    - episodeID: The identifier of the TV episode.
    ///    - endDate: The end date for changes. Interpreted as its GMT calendar day.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of changes for the TV episode.
    ///
    /// - Note: This convenience omits `startDate` and `page` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `startDate` and `page`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func changes(
        forEpisode episodeID: Int,
        endDate: Date?
    ) async throws(TMDbError) -> ChangeCollection {
        try await changes(forEpisode: episodeID, startDate: nil, endDate: endDate, page: nil)
    }

    ///
    /// Returns change history for a TV episode.
    ///
    /// [TMDb API - TV Episode:
    /// Changes](https://developer.themoviedb.org/reference/tv-episode-changes-by-id)
    ///
    /// - Parameters:
    ///    - episodeID: The identifier of the TV episode.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of changes for the TV episode.
    ///
    /// - Note: This convenience omits `startDate` and `endDate` rather than defaulting them, so that its signature
    /// stays distinct from the requirement it forwards to; it calls the requirement with `nil` for `startDate` and
    /// `endDate`. A defaulted overload would instead become that requirement's default implementation.
    ///
    func changes(
        forEpisode episodeID: Int,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection {
        try await changes(forEpisode: episodeID, startDate: nil, endDate: nil, page: page)
    }

    ///
    /// Returns change history for a TV episode.
    ///
    /// [TMDb API - TV Episode:
    /// Changes](https://developer.themoviedb.org/reference/tv-episode-changes-by-id)
    ///
    /// - Parameter episodeID: The identifier of the TV episode.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of changes for the TV episode.
    ///
    /// - Note: This convenience omits `startDate`, `endDate` and `page` rather than defaulting them, so that its
    /// signature stays distinct from the requirement it forwards to; it calls the requirement with `nil` for
    /// `startDate`, `endDate` and `page`. A defaulted overload would instead become that requirement's default
    /// implementation.
    ///
    func changes(forEpisode episodeID: Int) async throws(TMDbError) -> ChangeCollection {
        try await changes(forEpisode: episodeID, startDate: nil, endDate: nil, page: nil)
    }

}
