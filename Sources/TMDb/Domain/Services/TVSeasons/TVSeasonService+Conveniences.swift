//
//  TVSeasonService+Conveniences.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public extension TVSeasonService {

    ///
    /// Returns change history for a TV season.
    ///
    /// [TMDb API - TV Season:
    /// Changes](https://developer.themoviedb.org/reference/tv-season-changes-by-id)
    ///
    /// - Parameters:
    ///    - seasonID: The identifier of the TV season.
    ///    - startDate: The start date for changes.
    ///    - endDate: The end date for changes.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of changes for the TV season.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func changes(
        forSeason seasonID: Int,
        startDate: Date?,
        endDate: Date?
    ) async throws(TMDbError) -> ChangeCollection {
        try await changes(forSeason: seasonID, startDate: startDate, endDate: endDate, page: nil)
    }

    ///
    /// Returns change history for a TV season.
    ///
    /// [TMDb API - TV Season:
    /// Changes](https://developer.themoviedb.org/reference/tv-season-changes-by-id)
    ///
    /// - Parameters:
    ///    - seasonID: The identifier of the TV season.
    ///    - startDate: The start date for changes.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of changes for the TV season.
    ///
    /// - Note: This convenience omits `endDate` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `endDate`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func changes(
        forSeason seasonID: Int,
        startDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection {
        try await changes(forSeason: seasonID, startDate: startDate, endDate: nil, page: page)
    }

    ///
    /// Returns change history for a TV season.
    ///
    /// [TMDb API - TV Season:
    /// Changes](https://developer.themoviedb.org/reference/tv-season-changes-by-id)
    ///
    /// - Parameters:
    ///    - seasonID: The identifier of the TV season.
    ///    - endDate: The end date for changes.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of changes for the TV season.
    ///
    /// - Note: This convenience omits `startDate` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `startDate`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func changes(
        forSeason seasonID: Int,
        endDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection {
        try await changes(forSeason: seasonID, startDate: nil, endDate: endDate, page: page)
    }

    ///
    /// Returns change history for a TV season.
    ///
    /// [TMDb API - TV Season:
    /// Changes](https://developer.themoviedb.org/reference/tv-season-changes-by-id)
    ///
    /// - Parameters:
    ///    - seasonID: The identifier of the TV season.
    ///    - startDate: The start date for changes.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of changes for the TV season.
    ///
    /// - Note: This convenience omits `endDate` and `page` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `endDate` and `page`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func changes(
        forSeason seasonID: Int,
        startDate: Date?
    ) async throws(TMDbError) -> ChangeCollection {
        try await changes(forSeason: seasonID, startDate: startDate, endDate: nil, page: nil)
    }

    ///
    /// Returns change history for a TV season.
    ///
    /// [TMDb API - TV Season:
    /// Changes](https://developer.themoviedb.org/reference/tv-season-changes-by-id)
    ///
    /// - Parameters:
    ///    - seasonID: The identifier of the TV season.
    ///    - endDate: The end date for changes.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of changes for the TV season.
    ///
    /// - Note: This convenience omits `startDate` and `page` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `startDate` and `page`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func changes(
        forSeason seasonID: Int,
        endDate: Date?
    ) async throws(TMDbError) -> ChangeCollection {
        try await changes(forSeason: seasonID, startDate: nil, endDate: endDate, page: nil)
    }

    ///
    /// Returns change history for a TV season.
    ///
    /// [TMDb API - TV Season:
    /// Changes](https://developer.themoviedb.org/reference/tv-season-changes-by-id)
    ///
    /// - Parameters:
    ///    - seasonID: The identifier of the TV season.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of changes for the TV season.
    ///
    /// - Note: This convenience omits `startDate` and `endDate` rather than defaulting them, so that its signature
    /// stays distinct from the requirement it forwards to; it calls the requirement with `nil` for `startDate` and
    /// `endDate`. A defaulted overload would instead become that requirement's default implementation.
    ///
    func changes(
        forSeason seasonID: Int,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection {
        try await changes(forSeason: seasonID, startDate: nil, endDate: nil, page: page)
    }

    ///
    /// Returns change history for a TV season.
    ///
    /// [TMDb API - TV Season:
    /// Changes](https://developer.themoviedb.org/reference/tv-season-changes-by-id)
    ///
    /// - Parameter seasonID: The identifier of the TV season.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of changes for the TV season.
    ///
    /// - Note: This convenience omits `startDate`, `endDate` and `page` rather than defaulting them, so that its
    /// signature stays distinct from the requirement it forwards to; it calls the requirement with `nil` for
    /// `startDate`, `endDate` and `page`. A defaulted overload would instead become that requirement's default
    /// implementation.
    ///
    func changes(forSeason seasonID: Int) async throws(TMDbError) -> ChangeCollection {
        try await changes(forSeason: seasonID, startDate: nil, endDate: nil, page: nil)
    }

}
