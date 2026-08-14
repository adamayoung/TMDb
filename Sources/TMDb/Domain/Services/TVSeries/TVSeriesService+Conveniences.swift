//
//  TVSeriesService+Conveniences.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

// swiftlint:disable file_length

import Foundation

///
/// Shorter forms of the ``TVSeriesService`` requirements.
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
public extension TVSeriesService {

    ///
    /// Returns a list of TV series that are airing today.
    ///
    /// [TMDb API - TV Series Lists: Airing
    /// Today](https://developer.themoviedb.org/reference/tv-series-airing-today-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - page: The page of results to return.
    ///    - timezone: A valid timezone to filter the day by. Defaults to "America/New_York".
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: TV series airing today as a pageable list.
    ///
    /// - Note: This convenience omits `language` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `language`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func airingToday(
        page: Int?,
        timezone: String?
    ) async throws(TMDbError) -> TVSeriesPageableList {
        try await airingToday(page: page, timezone: timezone, language: nil)
    }

    ///
    /// Returns a list of TV series that are airing today.
    ///
    /// [TMDb API - TV Series Lists: Airing
    /// Today](https://developer.themoviedb.org/reference/tv-series-airing-today-list)
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
    /// - Returns: TV series airing today as a pageable list.
    ///
    /// - Note: This convenience omits `timezone` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `timezone`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func airingToday(
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> TVSeriesPageableList {
        try await airingToday(page: page, timezone: nil, language: language)
    }

    ///
    /// Returns a list of TV series that are airing today.
    ///
    /// [TMDb API - TV Series Lists: Airing
    /// Today](https://developer.themoviedb.org/reference/tv-series-airing-today-list)
    ///
    /// - Parameters:
    ///    - timezone: A valid timezone to filter the day by. Defaults to "America/New_York".
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: TV series airing today as a pageable list.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func airingToday(
        timezone: String?,
        language: String?
    ) async throws(TMDbError) -> TVSeriesPageableList {
        try await airingToday(page: nil, timezone: timezone, language: language)
    }

    ///
    /// Returns a list of TV series that are airing today.
    ///
    /// [TMDb API - TV Series Lists: Airing
    /// Today](https://developer.themoviedb.org/reference/tv-series-airing-today-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameter page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: TV series airing today as a pageable list.
    ///
    /// - Note: This convenience omits `timezone` and `language` rather than defaulting them, so that its signature
    /// stays distinct from the requirement it forwards to; it calls the requirement with `nil` for `timezone` and
    /// `language`. A defaulted overload would instead become that requirement's default implementation.
    ///
    func airingToday(page: Int?) async throws(TMDbError) -> TVSeriesPageableList {
        try await airingToday(page: page, timezone: nil, language: nil)
    }

    ///
    /// Returns a list of TV series that are airing today.
    ///
    /// [TMDb API - TV Series Lists: Airing
    /// Today](https://developer.themoviedb.org/reference/tv-series-airing-today-list)
    ///
    /// - Parameter timezone: A valid timezone to filter the day by. Defaults to "America/New_York".
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: TV series airing today as a pageable list.
    ///
    /// - Note: This convenience omits `page` and `language` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `page` and `language`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func airingToday(timezone: String?) async throws(TMDbError) -> TVSeriesPageableList {
        try await airingToday(page: nil, timezone: timezone, language: nil)
    }

    ///
    /// Returns a list of TV series that are airing today.
    ///
    /// [TMDb API - TV Series Lists: Airing
    /// Today](https://developer.themoviedb.org/reference/tv-series-airing-today-list)
    ///
    /// - Parameter language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: TV series airing today as a pageable list.
    ///
    /// - Note: This convenience omits `page` and `timezone` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `page` and `timezone`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func airingToday(language: String?) async throws(TMDbError) -> TVSeriesPageableList {
        try await airingToday(page: nil, timezone: nil, language: language)
    }

    ///
    /// Returns a list of TV series that are airing today.
    ///
    /// [TMDb API - TV Series Lists: Airing
    /// Today](https://developer.themoviedb.org/reference/tv-series-airing-today-list)
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: TV series airing today as a pageable list.
    ///
    /// - Note: This convenience omits `page`, `timezone` and `language` rather than defaulting them, so that its
    /// signature stays distinct from the requirement it forwards to; it calls the requirement with `nil` for `page`,
    /// `timezone` and `language`. A defaulted overload would instead become that requirement's default implementation.
    ///
    func airingToday() async throws(TMDbError) -> TVSeriesPageableList {
        try await airingToday(page: nil, timezone: nil, language: nil)
    }

    ///
    /// Returns change history for a TV series.
    ///
    /// [TMDb API - TV Series: Changes](https://developer.themoviedb.org/reference/tv-series-changes)
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - startDate: The start date for changes.
    ///    - endDate: The end date for changes.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of changes for the TV series.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func changes(
        forTVSeries tvSeriesID: TVSeries.ID,
        startDate: Date?,
        endDate: Date?
    ) async throws(TMDbError) -> ChangeCollection {
        try await changes(forTVSeries: tvSeriesID, startDate: startDate, endDate: endDate, page: nil)
    }

    ///
    /// Returns change history for a TV series.
    ///
    /// [TMDb API - TV Series: Changes](https://developer.themoviedb.org/reference/tv-series-changes)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - startDate: The start date for changes.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of changes for the TV series.
    ///
    /// - Note: This convenience omits `endDate` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `endDate`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func changes(
        forTVSeries tvSeriesID: TVSeries.ID,
        startDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection {
        try await changes(forTVSeries: tvSeriesID, startDate: startDate, endDate: nil, page: page)
    }

    ///
    /// Returns change history for a TV series.
    ///
    /// [TMDb API - TV Series: Changes](https://developer.themoviedb.org/reference/tv-series-changes)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - endDate: The end date for changes.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of changes for the TV series.
    ///
    /// - Note: This convenience omits `startDate` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `startDate`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func changes(
        forTVSeries tvSeriesID: TVSeries.ID,
        endDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection {
        try await changes(forTVSeries: tvSeriesID, startDate: nil, endDate: endDate, page: page)
    }

    ///
    /// Returns change history for a TV series.
    ///
    /// [TMDb API - TV Series: Changes](https://developer.themoviedb.org/reference/tv-series-changes)
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - startDate: The start date for changes.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of changes for the TV series.
    ///
    /// - Note: This convenience omits `endDate` and `page` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `endDate` and `page`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func changes(
        forTVSeries tvSeriesID: TVSeries.ID,
        startDate: Date?
    ) async throws(TMDbError) -> ChangeCollection {
        try await changes(forTVSeries: tvSeriesID, startDate: startDate, endDate: nil, page: nil)
    }

    ///
    /// Returns change history for a TV series.
    ///
    /// [TMDb API - TV Series: Changes](https://developer.themoviedb.org/reference/tv-series-changes)
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - endDate: The end date for changes.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of changes for the TV series.
    ///
    /// - Note: This convenience omits `startDate` and `page` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `startDate` and `page`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func changes(
        forTVSeries tvSeriesID: TVSeries.ID,
        endDate: Date?
    ) async throws(TMDbError) -> ChangeCollection {
        try await changes(forTVSeries: tvSeriesID, startDate: nil, endDate: endDate, page: nil)
    }

    ///
    /// Returns change history for a TV series.
    ///
    /// [TMDb API - TV Series: Changes](https://developer.themoviedb.org/reference/tv-series-changes)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of changes for the TV series.
    ///
    /// - Note: This convenience omits `startDate` and `endDate` rather than defaulting them, so that its signature
    /// stays distinct from the requirement it forwards to; it calls the requirement with `nil` for `startDate` and
    /// `endDate`. A defaulted overload would instead become that requirement's default implementation.
    ///
    func changes(
        forTVSeries tvSeriesID: TVSeries.ID,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection {
        try await changes(forTVSeries: tvSeriesID, startDate: nil, endDate: nil, page: page)
    }

    ///
    /// Returns change history for a TV series.
    ///
    /// [TMDb API - TV Series: Changes](https://developer.themoviedb.org/reference/tv-series-changes)
    ///
    /// - Parameter tvSeriesID: The identifier of the TV series.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of changes for the TV series.
    ///
    /// - Note: This convenience omits `startDate`, `endDate` and `page` rather than defaulting them, so that its
    /// signature stays distinct from the requirement it forwards to; it calls the requirement with `nil` for
    /// `startDate`, `endDate` and `page`. A defaulted overload would instead become that requirement's default
    /// implementation.
    ///
    func changes(forTVSeries tvSeriesID: TVSeries.ID) async throws(TMDbError) -> ChangeCollection {
        try await changes(forTVSeries: tvSeriesID, startDate: nil, endDate: nil, page: nil)
    }

    ///
    /// Returns a list of TV series IDs that have changed.
    ///
    /// [TMDb API - Changes: TV List](https://developer.themoviedb.org/reference/changes-tv-list)
    ///
    /// - Parameters:
    ///    - startDate: The start date for changes.
    ///    - endDate: The end date for changes.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of TV series IDs that have changed.
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
    /// Returns a list of TV series IDs that have changed.
    ///
    /// [TMDb API - Changes: TV List](https://developer.themoviedb.org/reference/changes-tv-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - startDate: The start date for changes.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of TV series IDs that have changed.
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
    /// Returns a list of TV series IDs that have changed.
    ///
    /// [TMDb API - Changes: TV List](https://developer.themoviedb.org/reference/changes-tv-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - endDate: The end date for changes.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of TV series IDs that have changed.
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
    /// Returns a list of TV series IDs that have changed.
    ///
    /// [TMDb API - Changes: TV List](https://developer.themoviedb.org/reference/changes-tv-list)
    ///
    /// - Parameter startDate: The start date for changes.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of TV series IDs that have changed.
    ///
    /// - Note: This convenience omits `endDate` and `page` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `endDate` and `page`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func changes(startDate: Date?) async throws(TMDbError) -> ChangedIDCollection {
        try await changes(startDate: startDate, endDate: nil, page: nil)
    }

    ///
    /// Returns a list of TV series IDs that have changed.
    ///
    /// [TMDb API - Changes: TV List](https://developer.themoviedb.org/reference/changes-tv-list)
    ///
    /// - Parameter endDate: The end date for changes.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of TV series IDs that have changed.
    ///
    /// - Note: This convenience omits `startDate` and `page` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `startDate` and `page`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func changes(endDate: Date?) async throws(TMDbError) -> ChangedIDCollection {
        try await changes(startDate: nil, endDate: endDate, page: nil)
    }

    ///
    /// Returns a list of TV series IDs that have changed.
    ///
    /// [TMDb API - Changes: TV List](https://developer.themoviedb.org/reference/changes-tv-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameter page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of TV series IDs that have changed.
    ///
    /// - Note: This convenience omits `startDate` and `endDate` rather than defaulting them, so that its signature
    /// stays distinct from the requirement it forwards to; it calls the requirement with `nil` for `startDate` and
    /// `endDate`. A defaulted overload would instead become that requirement's default implementation.
    ///
    func changes(page: Int?) async throws(TMDbError) -> ChangedIDCollection {
        try await changes(startDate: nil, endDate: nil, page: page)
    }

    ///
    /// Returns a list of TV series IDs that have changed.
    ///
    /// [TMDb API - Changes: TV List](https://developer.themoviedb.org/reference/changes-tv-list)
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of TV series IDs that have changed.
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
    /// Returns lists that contain the TV series.
    ///
    /// [TMDb API - TV Series: Lists](https://developer.themoviedb.org/reference/tv-series-lists)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Lists containing the TV series as a pageable list.
    ///
    /// - Note: This convenience omits `language` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `language`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func lists(
        forTVSeries tvSeriesID: TVSeries.ID,
        page: Int?
    ) async throws(TMDbError) -> MediaListSummaryPageableList {
        try await lists(forTVSeries: tvSeriesID, page: page, language: nil)
    }

    ///
    /// Returns lists that contain the TV series.
    ///
    /// [TMDb API - TV Series: Lists](https://developer.themoviedb.org/reference/tv-series-lists)
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Lists containing the TV series as a pageable list.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func lists(
        forTVSeries tvSeriesID: TVSeries.ID,
        language: String?
    ) async throws(TMDbError) -> MediaListSummaryPageableList {
        try await lists(forTVSeries: tvSeriesID, page: nil, language: language)
    }

    ///
    /// Returns lists that contain the TV series.
    ///
    /// [TMDb API - TV Series: Lists](https://developer.themoviedb.org/reference/tv-series-lists)
    ///
    /// - Parameter tvSeriesID: The identifier of the TV series.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Lists containing the TV series as a pageable list.
    ///
    /// - Note: This convenience omits `page` and `language` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `page` and `language`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func lists(forTVSeries tvSeriesID: TVSeries.ID) async throws(TMDbError) -> MediaListSummaryPageableList {
        try await lists(forTVSeries: tvSeriesID, page: nil, language: nil)
    }

    ///
    /// Returns a list of TV series that are currently on the air.
    ///
    /// This returns TV series that have episodes airing within the next 7 days.
    ///
    /// [TMDb API - TV Series Lists: On The Air](https://developer.themoviedb.org/reference/tv-series-on-the-air-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - page: The page of results to return.
    ///    - timezone: A valid timezone to filter the day by. Defaults to "America/New_York".
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: TV series on the air as a pageable list.
    ///
    /// - Note: This convenience omits `language` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `language`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func onTheAir(
        page: Int?,
        timezone: String?
    ) async throws(TMDbError) -> TVSeriesPageableList {
        try await onTheAir(page: page, timezone: timezone, language: nil)
    }

    ///
    /// Returns a list of TV series that are currently on the air.
    ///
    /// This returns TV series that have episodes airing within the next 7 days.
    ///
    /// [TMDb API - TV Series Lists: On The Air](https://developer.themoviedb.org/reference/tv-series-on-the-air-list)
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
    /// - Returns: TV series on the air as a pageable list.
    ///
    /// - Note: This convenience omits `timezone` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `timezone`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func onTheAir(
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> TVSeriesPageableList {
        try await onTheAir(page: page, timezone: nil, language: language)
    }

    ///
    /// Returns a list of TV series that are currently on the air.
    ///
    /// This returns TV series that have episodes airing within the next 7 days.
    ///
    /// [TMDb API - TV Series Lists: On The Air](https://developer.themoviedb.org/reference/tv-series-on-the-air-list)
    ///
    /// - Parameters:
    ///    - timezone: A valid timezone to filter the day by. Defaults to "America/New_York".
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: TV series on the air as a pageable list.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func onTheAir(
        timezone: String?,
        language: String?
    ) async throws(TMDbError) -> TVSeriesPageableList {
        try await onTheAir(page: nil, timezone: timezone, language: language)
    }

    ///
    /// Returns a list of TV series that are currently on the air.
    ///
    /// This returns TV series that have episodes airing within the next 7 days.
    ///
    /// [TMDb API - TV Series Lists: On The Air](https://developer.themoviedb.org/reference/tv-series-on-the-air-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameter page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: TV series on the air as a pageable list.
    ///
    /// - Note: This convenience omits `timezone` and `language` rather than defaulting them, so that its signature
    /// stays distinct from the requirement it forwards to; it calls the requirement with `nil` for `timezone` and
    /// `language`. A defaulted overload would instead become that requirement's default implementation.
    ///
    func onTheAir(page: Int?) async throws(TMDbError) -> TVSeriesPageableList {
        try await onTheAir(page: page, timezone: nil, language: nil)
    }

    ///
    /// Returns a list of TV series that are currently on the air.
    ///
    /// This returns TV series that have episodes airing within the next 7 days.
    ///
    /// [TMDb API - TV Series Lists: On The Air](https://developer.themoviedb.org/reference/tv-series-on-the-air-list)
    ///
    /// - Parameter timezone: A valid timezone to filter the day by. Defaults to "America/New_York".
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: TV series on the air as a pageable list.
    ///
    /// - Note: This convenience omits `page` and `language` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `page` and `language`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func onTheAir(timezone: String?) async throws(TMDbError) -> TVSeriesPageableList {
        try await onTheAir(page: nil, timezone: timezone, language: nil)
    }

    ///
    /// Returns a list of TV series that are currently on the air.
    ///
    /// This returns TV series that have episodes airing within the next 7 days.
    ///
    /// [TMDb API - TV Series Lists: On The Air](https://developer.themoviedb.org/reference/tv-series-on-the-air-list)
    ///
    /// - Parameter language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: TV series on the air as a pageable list.
    ///
    /// - Note: This convenience omits `page` and `timezone` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `page` and `timezone`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func onTheAir(language: String?) async throws(TMDbError) -> TVSeriesPageableList {
        try await onTheAir(page: nil, timezone: nil, language: language)
    }

    ///
    /// Returns a list of TV series that are currently on the air.
    ///
    /// This returns TV series that have episodes airing within the next 7 days.
    ///
    /// [TMDb API - TV Series Lists: On The Air](https://developer.themoviedb.org/reference/tv-series-on-the-air-list)
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: TV series on the air as a pageable list.
    ///
    /// - Note: This convenience omits `page`, `timezone` and `language` rather than defaulting them, so that its
    /// signature stays distinct from the requirement it forwards to; it calls the requirement with `nil` for `page`,
    /// `timezone` and `language`. A defaulted overload would instead become that requirement's default implementation.
    ///
    func onTheAir() async throws(TMDbError) -> TVSeriesPageableList {
        try await onTheAir(page: nil, timezone: nil, language: nil)
    }

    ///
    /// Returns a list of current popular TV series.
    ///
    /// [TMDb API - TV Series Lists: Popular](https://developer.themoviedb.org/reference/tv-series-popular-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameter page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Current popular TV series as a pageable list.
    ///
    /// - Note: This convenience omits `language` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `language`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func popular(page: Int?) async throws(TMDbError) -> TVSeriesPageableList {
        try await popular(page: page, language: nil)
    }

    ///
    /// Returns a list of current popular TV series.
    ///
    /// [TMDb API - TV Series Lists: Popular](https://developer.themoviedb.org/reference/tv-series-popular-list)
    ///
    /// - Parameter language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Current popular TV series as a pageable list.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func popular(language: String?) async throws(TMDbError) -> TVSeriesPageableList {
        try await popular(page: nil, language: language)
    }

    ///
    /// Returns a list of current popular TV series.
    ///
    /// [TMDb API - TV Series Lists: Popular](https://developer.themoviedb.org/reference/tv-series-popular-list)
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Current popular TV series as a pageable list.
    ///
    /// - Note: This convenience omits `page` and `language` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `page` and `language`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func popular() async throws(TMDbError) -> TVSeriesPageableList {
        try await popular(page: nil, language: nil)
    }

    ///
    /// Returns a list of recommended TV series for a TV series.
    ///
    /// [TMDb API - TV Series: Recommendations](https://developer.themoviedb.org/reference/tv-series-recommendations)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Recommended TV series for the matching TV series as a pageable list.
    ///
    /// - Note: This convenience omits `language` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `language`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func recommendations(
        forTVSeries tvSeriesID: TVSeries.ID,
        page: Int?
    ) async throws(TMDbError) -> TVSeriesPageableList {
        try await recommendations(forTVSeries: tvSeriesID, page: page, language: nil)
    }

    ///
    /// Returns a list of recommended TV series for a TV series.
    ///
    /// [TMDb API - TV Series: Recommendations](https://developer.themoviedb.org/reference/tv-series-recommendations)
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Recommended TV series for the matching TV series as a pageable list.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func recommendations(
        forTVSeries tvSeriesID: TVSeries.ID,
        language: String?
    ) async throws(TMDbError) -> TVSeriesPageableList {
        try await recommendations(forTVSeries: tvSeriesID, page: nil, language: language)
    }

    ///
    /// Returns a list of recommended TV series for a TV series.
    ///
    /// [TMDb API - TV Series: Recommendations](https://developer.themoviedb.org/reference/tv-series-recommendations)
    ///
    /// - Parameter tvSeriesID: The identifier of the TV series.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Recommended TV series for the matching TV series as a pageable list.
    ///
    /// - Note: This convenience omits `page` and `language` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `page` and `language`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func recommendations(forTVSeries tvSeriesID: TVSeries.ID) async throws(TMDbError) -> TVSeriesPageableList {
        try await recommendations(forTVSeries: tvSeriesID, page: nil, language: nil)
    }

    ///
    /// Returns the user reviews for a TV series.
    ///
    /// [TMDb API - TV Series: Reviews](https://developer.themoviedb.org/reference/tv-series-reviews)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Reviews for the matching TV series as a pageable list.
    ///
    /// - Note: This convenience omits `language` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `language`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func reviews(
        forTVSeries tvSeriesID: TVSeries.ID,
        page: Int?
    ) async throws(TMDbError) -> ReviewPageableList {
        try await reviews(forTVSeries: tvSeriesID, page: page, language: nil)
    }

    ///
    /// Returns the user reviews for a TV series.
    ///
    /// [TMDb API - TV Series: Reviews](https://developer.themoviedb.org/reference/tv-series-reviews)
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Reviews for the matching TV series as a pageable list.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func reviews(
        forTVSeries tvSeriesID: TVSeries.ID,
        language: String?
    ) async throws(TMDbError) -> ReviewPageableList {
        try await reviews(forTVSeries: tvSeriesID, page: nil, language: language)
    }

    ///
    /// Returns the user reviews for a TV series.
    ///
    /// [TMDb API - TV Series: Reviews](https://developer.themoviedb.org/reference/tv-series-reviews)
    ///
    /// - Parameter tvSeriesID: The identifier of the TV series.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Reviews for the matching TV series as a pageable list.
    ///
    /// - Note: This convenience omits `page` and `language` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `page` and `language`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func reviews(forTVSeries tvSeriesID: TVSeries.ID) async throws(TMDbError) -> ReviewPageableList {
        try await reviews(forTVSeries: tvSeriesID, page: nil, language: nil)
    }

    ///
    /// Returns a list of similar TV series for a TV series.
    ///
    /// This is not the same as the *Recommendations*.
    ///
    /// [TMDb API - TV Series: Similar](https://developer.themoviedb.org/reference/tv-series-similar)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series for get similar TV series for.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Similar TV series for the matching TV series as a pageable list.
    ///
    /// - Note: This convenience omits `language` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `language`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func similar(
        toTVSeries tvSeriesID: TVSeries.ID,
        page: Int?
    ) async throws(TMDbError) -> TVSeriesPageableList {
        try await similar(toTVSeries: tvSeriesID, page: page, language: nil)
    }

    ///
    /// Returns a list of similar TV series for a TV series.
    ///
    /// This is not the same as the *Recommendations*.
    ///
    /// [TMDb API - TV Series: Similar](https://developer.themoviedb.org/reference/tv-series-similar)
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series for get similar TV series for.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Similar TV series for the matching TV series as a pageable list.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func similar(
        toTVSeries tvSeriesID: TVSeries.ID,
        language: String?
    ) async throws(TMDbError) -> TVSeriesPageableList {
        try await similar(toTVSeries: tvSeriesID, page: nil, language: language)
    }

    ///
    /// Returns a list of similar TV series for a TV series.
    ///
    /// This is not the same as the *Recommendations*.
    ///
    /// [TMDb API - TV Series: Similar](https://developer.themoviedb.org/reference/tv-series-similar)
    ///
    /// - Parameter tvSeriesID: The identifier of the TV series for get similar TV series for.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Similar TV series for the matching TV series as a pageable list.
    ///
    /// - Note: This convenience omits `page` and `language` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `page` and `language`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func similar(toTVSeries tvSeriesID: TVSeries.ID) async throws(TMDbError) -> TVSeriesPageableList {
        try await similar(toTVSeries: tvSeriesID, page: nil, language: nil)
    }

    ///
    /// Returns a list of top rated TV series.
    ///
    /// [TMDb API - TV Series Lists: Top Rated](https://developer.themoviedb.org/reference/tv-series-top-rated-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameter page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Top rated TV series as a pageable list.
    ///
    /// - Note: This convenience omits `language` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `language`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func topRated(page: Int?) async throws(TMDbError) -> TVSeriesPageableList {
        try await topRated(page: page, language: nil)
    }

    ///
    /// Returns a list of top rated TV series.
    ///
    /// [TMDb API - TV Series Lists: Top Rated](https://developer.themoviedb.org/reference/tv-series-top-rated-list)
    ///
    /// - Parameter language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Top rated TV series as a pageable list.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func topRated(language: String?) async throws(TMDbError) -> TVSeriesPageableList {
        try await topRated(page: nil, language: language)
    }

    ///
    /// Returns a list of top rated TV series.
    ///
    /// [TMDb API - TV Series Lists: Top Rated](https://developer.themoviedb.org/reference/tv-series-top-rated-list)
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Top rated TV series as a pageable list.
    ///
    /// - Note: This convenience omits `page` and `language` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `page` and `language`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func topRated() async throws(TMDbError) -> TVSeriesPageableList {
        try await topRated(page: nil, language: nil)
    }

}
