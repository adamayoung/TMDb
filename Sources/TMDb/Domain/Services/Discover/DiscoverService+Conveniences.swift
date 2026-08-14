//
//  DiscoverService+Conveniences.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

// swiftlint:disable file_length

import Foundation

///
/// Shorter forms of the ``DiscoverService`` requirements.
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
public extension DiscoverService {

    ///
    /// Returns movies to be discovered.
    ///
    /// [TMDb API - Discover: Movie](https://developer.themoviedb.org/reference/discover-movie)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - filter: Movie filter.
    ///    - sortedBy: How results should be sorted.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Matching movies as a pageable list.
    ///
    /// - Note: This convenience omits `language` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `language`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func movies(
        filter: DiscoverMovieFilter?,
        sortedBy: MovieSort?,
        page: Int?
    ) async throws(TMDbError) -> MoviePageableList {
        try await movies(filter: filter, sortedBy: sortedBy, page: page, language: nil)
    }

    ///
    /// Returns movies to be discovered.
    ///
    /// [TMDb API - Discover: Movie](https://developer.themoviedb.org/reference/discover-movie)
    ///
    /// - Parameters:
    ///    - filter: Movie filter.
    ///    - sortedBy: How results should be sorted.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Matching movies as a pageable list.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func movies(
        filter: DiscoverMovieFilter?,
        sortedBy: MovieSort?,
        language: String?
    ) async throws(TMDbError) -> MoviePageableList {
        try await movies(filter: filter, sortedBy: sortedBy, page: nil, language: language)
    }

    ///
    /// Returns movies to be discovered.
    ///
    /// [TMDb API - Discover: Movie](https://developer.themoviedb.org/reference/discover-movie)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - filter: Movie filter.
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Matching movies as a pageable list.
    ///
    /// - Note: This convenience omits `sortedBy` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `sortedBy`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func movies(
        filter: DiscoverMovieFilter?,
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> MoviePageableList {
        try await movies(filter: filter, sortedBy: nil, page: page, language: language)
    }

    ///
    /// Returns movies to be discovered.
    ///
    /// [TMDb API - Discover: Movie](https://developer.themoviedb.org/reference/discover-movie)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - sortedBy: How results should be sorted.
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Matching movies as a pageable list.
    ///
    /// - Note: This convenience omits `filter` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `filter`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func movies(
        sortedBy: MovieSort?,
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> MoviePageableList {
        try await movies(filter: nil, sortedBy: sortedBy, page: page, language: language)
    }

    ///
    /// Returns movies to be discovered.
    ///
    /// [TMDb API - Discover: Movie](https://developer.themoviedb.org/reference/discover-movie)
    ///
    /// - Parameters:
    ///    - filter: Movie filter.
    ///    - sortedBy: How results should be sorted.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Matching movies as a pageable list.
    ///
    /// - Note: This convenience omits `page` and `language` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `page` and `language`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func movies(
        filter: DiscoverMovieFilter?,
        sortedBy: MovieSort?
    ) async throws(TMDbError) -> MoviePageableList {
        try await movies(filter: filter, sortedBy: sortedBy, page: nil, language: nil)
    }

    ///
    /// Returns movies to be discovered.
    ///
    /// [TMDb API - Discover: Movie](https://developer.themoviedb.org/reference/discover-movie)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - filter: Movie filter.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Matching movies as a pageable list.
    ///
    /// - Note: This convenience omits `sortedBy` and `language` rather than defaulting them, so that its signature
    /// stays distinct from the requirement it forwards to; it calls the requirement with `nil` for `sortedBy` and
    /// `language`. A defaulted overload would instead become that requirement's default implementation.
    ///
    func movies(
        filter: DiscoverMovieFilter?,
        page: Int?
    ) async throws(TMDbError) -> MoviePageableList {
        try await movies(filter: filter, sortedBy: nil, page: page, language: nil)
    }

    ///
    /// Returns movies to be discovered.
    ///
    /// [TMDb API - Discover: Movie](https://developer.themoviedb.org/reference/discover-movie)
    ///
    /// - Parameters:
    ///    - filter: Movie filter.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Matching movies as a pageable list.
    ///
    /// - Note: This convenience omits `sortedBy` and `page` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `sortedBy` and `page`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func movies(
        filter: DiscoverMovieFilter?,
        language: String?
    ) async throws(TMDbError) -> MoviePageableList {
        try await movies(filter: filter, sortedBy: nil, page: nil, language: language)
    }

    ///
    /// Returns movies to be discovered.
    ///
    /// [TMDb API - Discover: Movie](https://developer.themoviedb.org/reference/discover-movie)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - sortedBy: How results should be sorted.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Matching movies as a pageable list.
    ///
    /// - Note: This convenience omits `filter` and `language` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `filter` and `language`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func movies(
        sortedBy: MovieSort?,
        page: Int?
    ) async throws(TMDbError) -> MoviePageableList {
        try await movies(filter: nil, sortedBy: sortedBy, page: page, language: nil)
    }

    ///
    /// Returns movies to be discovered.
    ///
    /// [TMDb API - Discover: Movie](https://developer.themoviedb.org/reference/discover-movie)
    ///
    /// - Parameters:
    ///    - sortedBy: How results should be sorted.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Matching movies as a pageable list.
    ///
    /// - Note: This convenience omits `filter` and `page` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `filter` and `page`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func movies(
        sortedBy: MovieSort?,
        language: String?
    ) async throws(TMDbError) -> MoviePageableList {
        try await movies(filter: nil, sortedBy: sortedBy, page: nil, language: language)
    }

    ///
    /// Returns movies to be discovered.
    ///
    /// [TMDb API - Discover: Movie](https://developer.themoviedb.org/reference/discover-movie)
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
    /// - Returns: Matching movies as a pageable list.
    ///
    /// - Note: This convenience omits `filter` and `sortedBy` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `filter` and `sortedBy`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func movies(
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> MoviePageableList {
        try await movies(filter: nil, sortedBy: nil, page: page, language: language)
    }

    ///
    /// Returns movies to be discovered.
    ///
    /// [TMDb API - Discover: Movie](https://developer.themoviedb.org/reference/discover-movie)
    ///
    /// - Parameter filter: Movie filter.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Matching movies as a pageable list.
    ///
    /// - Note: This convenience omits `sortedBy`, `page` and `language` rather than defaulting them, so that its
    /// signature stays distinct from the requirement it forwards to; it calls the requirement with `nil` for
    /// `sortedBy`, `page` and `language`. A defaulted overload would instead become that requirement's default
    /// implementation.
    ///
    func movies(filter: DiscoverMovieFilter?) async throws(TMDbError) -> MoviePageableList {
        try await movies(filter: filter, sortedBy: nil, page: nil, language: nil)
    }

    ///
    /// Returns movies to be discovered.
    ///
    /// [TMDb API - Discover: Movie](https://developer.themoviedb.org/reference/discover-movie)
    ///
    /// - Parameter sortedBy: How results should be sorted.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Matching movies as a pageable list.
    ///
    /// - Note: This convenience omits `filter`, `page` and `language` rather than defaulting them, so that its
    /// signature stays distinct from the requirement it forwards to; it calls the requirement with `nil` for `filter`,
    /// `page` and `language`. A defaulted overload would instead become that requirement's default implementation.
    ///
    func movies(sortedBy: MovieSort?) async throws(TMDbError) -> MoviePageableList {
        try await movies(filter: nil, sortedBy: sortedBy, page: nil, language: nil)
    }

    ///
    /// Returns movies to be discovered.
    ///
    /// [TMDb API - Discover: Movie](https://developer.themoviedb.org/reference/discover-movie)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameter page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Matching movies as a pageable list.
    ///
    /// - Note: This convenience omits `filter`, `sortedBy` and `language` rather than defaulting them, so that its
    /// signature stays distinct from the requirement it forwards to; it calls the requirement with `nil` for `filter`,
    /// `sortedBy` and `language`. A defaulted overload would instead become that requirement's default implementation.
    ///
    func movies(page: Int?) async throws(TMDbError) -> MoviePageableList {
        try await movies(filter: nil, sortedBy: nil, page: page, language: nil)
    }

    ///
    /// Returns movies to be discovered.
    ///
    /// [TMDb API - Discover: Movie](https://developer.themoviedb.org/reference/discover-movie)
    ///
    /// - Parameter language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Matching movies as a pageable list.
    ///
    /// - Note: This convenience omits `filter`, `sortedBy` and `page` rather than defaulting them, so that its
    /// signature stays distinct from the requirement it forwards to; it calls the requirement with `nil` for `filter`,
    /// `sortedBy` and `page`. A defaulted overload would instead become that requirement's default implementation.
    ///
    func movies(language: String?) async throws(TMDbError) -> MoviePageableList {
        try await movies(filter: nil, sortedBy: nil, page: nil, language: language)
    }

    ///
    /// Returns movies to be discovered.
    ///
    /// [TMDb API - Discover: Movie](https://developer.themoviedb.org/reference/discover-movie)
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Matching movies as a pageable list.
    ///
    /// - Note: This convenience omits `filter`, `sortedBy`, `page` and `language` rather than defaulting them, so that
    /// its signature stays distinct from the requirement it forwards to; it calls the requirement with `nil` for
    /// `filter`, `sortedBy`, `page` and `language`. A defaulted overload would instead become that requirement's
    /// default implementation.
    ///
    func movies() async throws(TMDbError) -> MoviePageableList {
        try await movies(filter: nil, sortedBy: nil, page: nil, language: nil)
    }

    ///
    /// Returns TV series to be discovered.
    ///
    /// [TMDb API - Discover: TV Series](https://developer.themoviedb.org/reference/discover-tv)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - filter: TV series filter.
    ///    - sortedBy: How results should be sorted.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Matching TV series as a pageable list.
    ///
    /// - Note: This convenience omits `language` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `language`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func tvSeries(
        filter: DiscoverTVSeriesFilter?,
        sortedBy: TVSeriesSort?,
        page: Int?
    ) async throws(TMDbError) -> TVSeriesPageableList {
        try await tvSeries(filter: filter, sortedBy: sortedBy, page: page, language: nil)
    }

    ///
    /// Returns TV series to be discovered.
    ///
    /// [TMDb API - Discover: TV Series](https://developer.themoviedb.org/reference/discover-tv)
    ///
    /// - Parameters:
    ///    - filter: TV series filter.
    ///    - sortedBy: How results should be sorted.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Matching TV series as a pageable list.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func tvSeries(
        filter: DiscoverTVSeriesFilter?,
        sortedBy: TVSeriesSort?,
        language: String?
    ) async throws(TMDbError) -> TVSeriesPageableList {
        try await tvSeries(filter: filter, sortedBy: sortedBy, page: nil, language: language)
    }

    ///
    /// Returns TV series to be discovered.
    ///
    /// [TMDb API - Discover: TV Series](https://developer.themoviedb.org/reference/discover-tv)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - filter: TV series filter.
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Matching TV series as a pageable list.
    ///
    /// - Note: This convenience omits `sortedBy` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `sortedBy`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func tvSeries(
        filter: DiscoverTVSeriesFilter?,
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> TVSeriesPageableList {
        try await tvSeries(filter: filter, sortedBy: nil, page: page, language: language)
    }

    ///
    /// Returns TV series to be discovered.
    ///
    /// [TMDb API - Discover: TV Series](https://developer.themoviedb.org/reference/discover-tv)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - sortedBy: How results should be sorted.
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Matching TV series as a pageable list.
    ///
    /// - Note: This convenience omits `filter` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `filter`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func tvSeries(
        sortedBy: TVSeriesSort?,
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> TVSeriesPageableList {
        try await tvSeries(filter: nil, sortedBy: sortedBy, page: page, language: language)
    }

    ///
    /// Returns TV series to be discovered.
    ///
    /// [TMDb API - Discover: TV Series](https://developer.themoviedb.org/reference/discover-tv)
    ///
    /// - Parameters:
    ///    - filter: TV series filter.
    ///    - sortedBy: How results should be sorted.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Matching TV series as a pageable list.
    ///
    /// - Note: This convenience omits `page` and `language` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `page` and `language`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func tvSeries(
        filter: DiscoverTVSeriesFilter?,
        sortedBy: TVSeriesSort?
    ) async throws(TMDbError) -> TVSeriesPageableList {
        try await tvSeries(filter: filter, sortedBy: sortedBy, page: nil, language: nil)
    }

    ///
    /// Returns TV series to be discovered.
    ///
    /// [TMDb API - Discover: TV Series](https://developer.themoviedb.org/reference/discover-tv)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - filter: TV series filter.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Matching TV series as a pageable list.
    ///
    /// - Note: This convenience omits `sortedBy` and `language` rather than defaulting them, so that its signature
    /// stays distinct from the requirement it forwards to; it calls the requirement with `nil` for `sortedBy` and
    /// `language`. A defaulted overload would instead become that requirement's default implementation.
    ///
    func tvSeries(
        filter: DiscoverTVSeriesFilter?,
        page: Int?
    ) async throws(TMDbError) -> TVSeriesPageableList {
        try await tvSeries(filter: filter, sortedBy: nil, page: page, language: nil)
    }

    ///
    /// Returns TV series to be discovered.
    ///
    /// [TMDb API - Discover: TV Series](https://developer.themoviedb.org/reference/discover-tv)
    ///
    /// - Parameters:
    ///    - filter: TV series filter.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Matching TV series as a pageable list.
    ///
    /// - Note: This convenience omits `sortedBy` and `page` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `sortedBy` and `page`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func tvSeries(
        filter: DiscoverTVSeriesFilter?,
        language: String?
    ) async throws(TMDbError) -> TVSeriesPageableList {
        try await tvSeries(filter: filter, sortedBy: nil, page: nil, language: language)
    }

    ///
    /// Returns TV series to be discovered.
    ///
    /// [TMDb API - Discover: TV Series](https://developer.themoviedb.org/reference/discover-tv)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - sortedBy: How results should be sorted.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Matching TV series as a pageable list.
    ///
    /// - Note: This convenience omits `filter` and `language` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `filter` and `language`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func tvSeries(
        sortedBy: TVSeriesSort?,
        page: Int?
    ) async throws(TMDbError) -> TVSeriesPageableList {
        try await tvSeries(filter: nil, sortedBy: sortedBy, page: page, language: nil)
    }

    ///
    /// Returns TV series to be discovered.
    ///
    /// [TMDb API - Discover: TV Series](https://developer.themoviedb.org/reference/discover-tv)
    ///
    /// - Parameters:
    ///    - sortedBy: How results should be sorted.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Matching TV series as a pageable list.
    ///
    /// - Note: This convenience omits `filter` and `page` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `filter` and `page`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func tvSeries(
        sortedBy: TVSeriesSort?,
        language: String?
    ) async throws(TMDbError) -> TVSeriesPageableList {
        try await tvSeries(filter: nil, sortedBy: sortedBy, page: nil, language: language)
    }

    ///
    /// Returns TV series to be discovered.
    ///
    /// [TMDb API - Discover: TV Series](https://developer.themoviedb.org/reference/discover-tv)
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
    /// - Returns: Matching TV series as a pageable list.
    ///
    /// - Note: This convenience omits `filter` and `sortedBy` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `filter` and `sortedBy`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func tvSeries(
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> TVSeriesPageableList {
        try await tvSeries(filter: nil, sortedBy: nil, page: page, language: language)
    }

    ///
    /// Returns TV series to be discovered.
    ///
    /// [TMDb API - Discover: TV Series](https://developer.themoviedb.org/reference/discover-tv)
    ///
    /// - Parameter filter: TV series filter.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Matching TV series as a pageable list.
    ///
    /// - Note: This convenience omits `sortedBy`, `page` and `language` rather than defaulting them, so that its
    /// signature stays distinct from the requirement it forwards to; it calls the requirement with `nil` for
    /// `sortedBy`, `page` and `language`. A defaulted overload would instead become that requirement's default
    /// implementation.
    ///
    func tvSeries(filter: DiscoverTVSeriesFilter?) async throws(TMDbError) -> TVSeriesPageableList {
        try await tvSeries(filter: filter, sortedBy: nil, page: nil, language: nil)
    }

    ///
    /// Returns TV series to be discovered.
    ///
    /// [TMDb API - Discover: TV Series](https://developer.themoviedb.org/reference/discover-tv)
    ///
    /// - Parameter sortedBy: How results should be sorted.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Matching TV series as a pageable list.
    ///
    /// - Note: This convenience omits `filter`, `page` and `language` rather than defaulting them, so that its
    /// signature stays distinct from the requirement it forwards to; it calls the requirement with `nil` for `filter`,
    /// `page` and `language`. A defaulted overload would instead become that requirement's default implementation.
    ///
    func tvSeries(sortedBy: TVSeriesSort?) async throws(TMDbError) -> TVSeriesPageableList {
        try await tvSeries(filter: nil, sortedBy: sortedBy, page: nil, language: nil)
    }

    ///
    /// Returns TV series to be discovered.
    ///
    /// [TMDb API - Discover: TV Series](https://developer.themoviedb.org/reference/discover-tv)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameter page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Matching TV series as a pageable list.
    ///
    /// - Note: This convenience omits `filter`, `sortedBy` and `language` rather than defaulting them, so that its
    /// signature stays distinct from the requirement it forwards to; it calls the requirement with `nil` for `filter`,
    /// `sortedBy` and `language`. A defaulted overload would instead become that requirement's default implementation.
    ///
    func tvSeries(page: Int?) async throws(TMDbError) -> TVSeriesPageableList {
        try await tvSeries(filter: nil, sortedBy: nil, page: page, language: nil)
    }

    ///
    /// Returns TV series to be discovered.
    ///
    /// [TMDb API - Discover: TV Series](https://developer.themoviedb.org/reference/discover-tv)
    ///
    /// - Parameter language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Matching TV series as a pageable list.
    ///
    /// - Note: This convenience omits `filter`, `sortedBy` and `page` rather than defaulting them, so that its
    /// signature stays distinct from the requirement it forwards to; it calls the requirement with `nil` for `filter`,
    /// `sortedBy` and `page`. A defaulted overload would instead become that requirement's default implementation.
    ///
    func tvSeries(language: String?) async throws(TMDbError) -> TVSeriesPageableList {
        try await tvSeries(filter: nil, sortedBy: nil, page: nil, language: language)
    }

    ///
    /// Returns TV series to be discovered.
    ///
    /// [TMDb API - Discover: TV Series](https://developer.themoviedb.org/reference/discover-tv)
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Matching TV series as a pageable list.
    ///
    /// - Note: This convenience omits `filter`, `sortedBy`, `page` and `language` rather than defaulting them, so that
    /// its signature stays distinct from the requirement it forwards to; it calls the requirement with `nil` for
    /// `filter`, `sortedBy`, `page` and `language`. A defaulted overload would instead become that requirement's
    /// default implementation.
    ///
    func tvSeries() async throws(TMDbError) -> TVSeriesPageableList {
        try await tvSeries(filter: nil, sortedBy: nil, page: nil, language: nil)
    }

}
