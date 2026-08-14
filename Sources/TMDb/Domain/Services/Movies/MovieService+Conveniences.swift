//
//  MovieService+Conveniences.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

// swiftlint:disable file_length

import Foundation

///
/// Shorter forms of the ``MovieService`` requirements.
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
public extension MovieService {

    ///
    /// Returns alternative titles for a movie.
    ///
    /// [TMDb API - Movies: Alternative Titles](https://developer.themoviedb.org/reference/movie-alternative-titles)
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie.
    ///    - country: ISO 3166-1 country code to filter results.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of alternative titles for the movie.
    ///
    /// - Note: This convenience omits `language` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `language`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func alternativeTitles(
        forMovie movieID: Movie.ID,
        country: String?
    ) async throws(TMDbError) -> AlternativeTitleCollection {
        try await alternativeTitles(forMovie: movieID, country: country, language: nil)
    }

    ///
    /// Returns alternative titles for a movie.
    ///
    /// [TMDb API - Movies: Alternative Titles](https://developer.themoviedb.org/reference/movie-alternative-titles)
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of alternative titles for the movie.
    ///
    /// - Note: This convenience omits `country` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `country`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func alternativeTitles(
        forMovie movieID: Movie.ID,
        language: String?
    ) async throws(TMDbError) -> AlternativeTitleCollection {
        try await alternativeTitles(forMovie: movieID, country: nil, language: language)
    }

    ///
    /// Returns alternative titles for a movie.
    ///
    /// [TMDb API - Movies: Alternative Titles](https://developer.themoviedb.org/reference/movie-alternative-titles)
    ///
    /// - Parameter movieID: The identifier of the movie.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of alternative titles for the movie.
    ///
    /// - Note: This convenience omits `country` and `language` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `country` and `language`.
    /// A defaulted overload would instead become that requirement's default implementation.
    ///
    func alternativeTitles(forMovie movieID: Movie.ID) async throws(TMDbError) -> AlternativeTitleCollection {
        try await alternativeTitles(forMovie: movieID, country: nil, language: nil)
    }

    ///
    /// Returns change history for a movie.
    ///
    /// [TMDb API - Movies: Changes](https://developer.themoviedb.org/reference/movie-changes)
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie.
    ///    - startDate: The start date for changes.
    ///    - endDate: The end date for changes.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of changes for the movie.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func changes(
        forMovie movieID: Movie.ID,
        startDate: Date?,
        endDate: Date?
    ) async throws(TMDbError) -> ChangeCollection {
        try await changes(forMovie: movieID, startDate: startDate, endDate: endDate, page: nil)
    }

    ///
    /// Returns change history for a movie.
    ///
    /// [TMDb API - Movies: Changes](https://developer.themoviedb.org/reference/movie-changes)
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie.
    ///    - startDate: The start date for changes.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of changes for the movie.
    ///
    /// - Note: This convenience omits `endDate` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `endDate`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func changes(
        forMovie movieID: Movie.ID,
        startDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection {
        try await changes(forMovie: movieID, startDate: startDate, endDate: nil, page: page)
    }

    ///
    /// Returns change history for a movie.
    ///
    /// [TMDb API - Movies: Changes](https://developer.themoviedb.org/reference/movie-changes)
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie.
    ///    - endDate: The end date for changes.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of changes for the movie.
    ///
    /// - Note: This convenience omits `startDate` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `startDate`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func changes(
        forMovie movieID: Movie.ID,
        endDate: Date?,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection {
        try await changes(forMovie: movieID, startDate: nil, endDate: endDate, page: page)
    }

    ///
    /// Returns change history for a movie.
    ///
    /// [TMDb API - Movies: Changes](https://developer.themoviedb.org/reference/movie-changes)
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie.
    ///    - startDate: The start date for changes.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of changes for the movie.
    ///
    /// - Note: This convenience omits `endDate` and `page` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `endDate` and `page`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func changes(
        forMovie movieID: Movie.ID,
        startDate: Date?
    ) async throws(TMDbError) -> ChangeCollection {
        try await changes(forMovie: movieID, startDate: startDate, endDate: nil, page: nil)
    }

    ///
    /// Returns change history for a movie.
    ///
    /// [TMDb API - Movies: Changes](https://developer.themoviedb.org/reference/movie-changes)
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie.
    ///    - endDate: The end date for changes.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of changes for the movie.
    ///
    /// - Note: This convenience omits `startDate` and `page` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `startDate` and `page`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func changes(
        forMovie movieID: Movie.ID,
        endDate: Date?
    ) async throws(TMDbError) -> ChangeCollection {
        try await changes(forMovie: movieID, startDate: nil, endDate: endDate, page: nil)
    }

    ///
    /// Returns change history for a movie.
    ///
    /// [TMDb API - Movies: Changes](https://developer.themoviedb.org/reference/movie-changes)
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of changes for the movie.
    ///
    /// - Note: This convenience omits `startDate` and `endDate` rather than defaulting them, so that its signature
    /// stays distinct from the requirement it forwards to; it calls the requirement with `nil` for `startDate` and
    /// `endDate`. A defaulted overload would instead become that requirement's default implementation.
    ///
    func changes(
        forMovie movieID: Movie.ID,
        page: Int?
    ) async throws(TMDbError) -> ChangeCollection {
        try await changes(forMovie: movieID, startDate: nil, endDate: nil, page: page)
    }

    ///
    /// Returns change history for a movie.
    ///
    /// [TMDb API - Movies: Changes](https://developer.themoviedb.org/reference/movie-changes)
    ///
    /// - Parameter movieID: The identifier of the movie.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of changes for the movie.
    ///
    /// - Note: This convenience omits `startDate`, `endDate` and `page` rather than defaulting them, so that its
    /// signature stays distinct from the requirement it forwards to; it calls the requirement with `nil` for
    /// `startDate`, `endDate` and `page`. A defaulted overload would instead become that requirement's default
    /// implementation.
    ///
    func changes(forMovie movieID: Movie.ID) async throws(TMDbError) -> ChangeCollection {
        try await changes(forMovie: movieID, startDate: nil, endDate: nil, page: nil)
    }

    ///
    /// Returns a list of movie IDs that have changed.
    ///
    /// [TMDb API - Movie Changes: List](https://developer.themoviedb.org/reference/changes-movie-list)
    ///
    /// - Parameters:
    ///    - startDate: The start date for changes.
    ///    - endDate: The end date for changes.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A pageable collection of changed movie IDs.
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
    /// Returns a list of movie IDs that have changed.
    ///
    /// [TMDb API - Movie Changes: List](https://developer.themoviedb.org/reference/changes-movie-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - startDate: The start date for changes.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A pageable collection of changed movie IDs.
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
    /// Returns a list of movie IDs that have changed.
    ///
    /// [TMDb API - Movie Changes: List](https://developer.themoviedb.org/reference/changes-movie-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - endDate: The end date for changes.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A pageable collection of changed movie IDs.
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
    /// Returns a list of movie IDs that have changed.
    ///
    /// [TMDb API - Movie Changes: List](https://developer.themoviedb.org/reference/changes-movie-list)
    ///
    /// - Parameter startDate: The start date for changes.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A pageable collection of changed movie IDs.
    ///
    /// - Note: This convenience omits `endDate` and `page` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `endDate` and `page`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func changes(startDate: Date?) async throws(TMDbError) -> ChangedIDCollection {
        try await changes(startDate: startDate, endDate: nil, page: nil)
    }

    ///
    /// Returns a list of movie IDs that have changed.
    ///
    /// [TMDb API - Movie Changes: List](https://developer.themoviedb.org/reference/changes-movie-list)
    ///
    /// - Parameter endDate: The end date for changes.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A pageable collection of changed movie IDs.
    ///
    /// - Note: This convenience omits `startDate` and `page` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `startDate` and `page`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func changes(endDate: Date?) async throws(TMDbError) -> ChangedIDCollection {
        try await changes(startDate: nil, endDate: endDate, page: nil)
    }

    ///
    /// Returns a list of movie IDs that have changed.
    ///
    /// [TMDb API - Movie Changes: List](https://developer.themoviedb.org/reference/changes-movie-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameter page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A pageable collection of changed movie IDs.
    ///
    /// - Note: This convenience omits `startDate` and `endDate` rather than defaulting them, so that its signature
    /// stays distinct from the requirement it forwards to; it calls the requirement with `nil` for `startDate` and
    /// `endDate`. A defaulted overload would instead become that requirement's default implementation.
    ///
    func changes(page: Int?) async throws(TMDbError) -> ChangedIDCollection {
        try await changes(startDate: nil, endDate: nil, page: page)
    }

    ///
    /// Returns a list of movie IDs that have changed.
    ///
    /// [TMDb API - Movie Changes: List](https://developer.themoviedb.org/reference/changes-movie-list)
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A pageable collection of changed movie IDs.
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
    /// Returns lists that contain the movie.
    ///
    /// [TMDb API - Movies: Lists](https://developer.themoviedb.org/reference/movie-lists)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Lists containing the movie as a pageable list.
    ///
    /// - Note: This convenience omits `language` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `language`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func lists(
        forMovie movieID: Movie.ID,
        page: Int?
    ) async throws(TMDbError) -> MediaListSummaryPageableList {
        try await lists(forMovie: movieID, page: page, language: nil)
    }

    ///
    /// Returns lists that contain the movie.
    ///
    /// [TMDb API - Movies: Lists](https://developer.themoviedb.org/reference/movie-lists)
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Lists containing the movie as a pageable list.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func lists(
        forMovie movieID: Movie.ID,
        language: String?
    ) async throws(TMDbError) -> MediaListSummaryPageableList {
        try await lists(forMovie: movieID, page: nil, language: language)
    }

    ///
    /// Returns lists that contain the movie.
    ///
    /// [TMDb API - Movies: Lists](https://developer.themoviedb.org/reference/movie-lists)
    ///
    /// - Parameter movieID: The identifier of the movie.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Lists containing the movie as a pageable list.
    ///
    /// - Note: This convenience omits `page` and `language` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `page` and `language`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func lists(forMovie movieID: Movie.ID) async throws(TMDbError) -> MediaListSummaryPageableList {
        try await lists(forMovie: movieID, page: nil, language: nil)
    }

    ///
    /// Returns a list of currently playing movies.
    ///
    /// [TMDb API - Movie Lists: Now Playing](https://developer.themoviedb.org/reference/movie-now-playing-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - page: The page of results to return.
    ///    - country: ISO-3166-1 country code to fetch results for. Defaults to the client's configured default country.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Now playing movies as a pageable list.
    ///
    /// - Note: This convenience omits `language` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `language`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func nowPlaying(
        page: Int?,
        country: String?
    ) async throws(TMDbError) -> MoviePageableList {
        try await nowPlaying(page: page, country: country, language: nil)
    }

    ///
    /// Returns a list of currently playing movies.
    ///
    /// [TMDb API - Movie Lists: Now Playing](https://developer.themoviedb.org/reference/movie-now-playing-list)
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
    /// - Returns: Now playing movies as a pageable list.
    ///
    /// - Note: This convenience omits `country` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `country`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func nowPlaying(
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> MoviePageableList {
        try await nowPlaying(page: page, country: nil, language: language)
    }

    ///
    /// Returns a list of currently playing movies.
    ///
    /// [TMDb API - Movie Lists: Now Playing](https://developer.themoviedb.org/reference/movie-now-playing-list)
    ///
    /// - Parameters:
    ///    - country: ISO-3166-1 country code to fetch results for. Defaults to the client's configured default country.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Now playing movies as a pageable list.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func nowPlaying(
        country: String?,
        language: String?
    ) async throws(TMDbError) -> MoviePageableList {
        try await nowPlaying(page: nil, country: country, language: language)
    }

    ///
    /// Returns a list of currently playing movies.
    ///
    /// [TMDb API - Movie Lists: Now Playing](https://developer.themoviedb.org/reference/movie-now-playing-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameter page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Now playing movies as a pageable list.
    ///
    /// - Note: This convenience omits `country` and `language` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `country` and `language`.
    /// A defaulted overload would instead become that requirement's default implementation.
    ///
    func nowPlaying(page: Int?) async throws(TMDbError) -> MoviePageableList {
        try await nowPlaying(page: page, country: nil, language: nil)
    }

    ///
    /// Returns a list of currently playing movies.
    ///
    /// [TMDb API - Movie Lists: Now Playing](https://developer.themoviedb.org/reference/movie-now-playing-list)
    ///
    /// - Parameter country: ISO-3166-1 country code to fetch results for. Defaults to the client's configured default
    /// country.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Now playing movies as a pageable list.
    ///
    /// - Note: This convenience omits `page` and `language` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `page` and `language`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func nowPlaying(country: String?) async throws(TMDbError) -> MoviePageableList {
        try await nowPlaying(page: nil, country: country, language: nil)
    }

    ///
    /// Returns a list of currently playing movies.
    ///
    /// [TMDb API - Movie Lists: Now Playing](https://developer.themoviedb.org/reference/movie-now-playing-list)
    ///
    /// - Parameter language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Now playing movies as a pageable list.
    ///
    /// - Note: This convenience omits `page` and `country` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `page` and `country`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func nowPlaying(language: String?) async throws(TMDbError) -> MoviePageableList {
        try await nowPlaying(page: nil, country: nil, language: language)
    }

    ///
    /// Returns a list of currently playing movies.
    ///
    /// [TMDb API - Movie Lists: Now Playing](https://developer.themoviedb.org/reference/movie-now-playing-list)
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Now playing movies as a pageable list.
    ///
    /// - Note: This convenience omits `page`, `country` and `language` rather than defaulting them, so that its
    /// signature stays distinct from the requirement it forwards to; it calls the requirement with `nil` for `page`,
    /// `country` and `language`. A defaulted overload would instead become that requirement's default implementation.
    ///
    func nowPlaying() async throws(TMDbError) -> MoviePageableList {
        try await nowPlaying(page: nil, country: nil, language: nil)
    }

    ///
    /// Returns a list of current popular movies.
    ///
    /// [TMDb API - Movie List: Popular](https://developer.themoviedb.org/reference/movie-popular-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - page: The page of results to return.
    ///    - country: ISO-3166-1 country code to fetch results for. Defaults to the client's configured default country.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Current popular movies as a pageable list.
    ///
    /// - Note: This convenience omits `language` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `language`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func popular(
        page: Int?,
        country: String?
    ) async throws(TMDbError) -> MoviePageableList {
        try await popular(page: page, country: country, language: nil)
    }

    ///
    /// Returns a list of current popular movies.
    ///
    /// [TMDb API - Movie List: Popular](https://developer.themoviedb.org/reference/movie-popular-list)
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
    /// - Returns: Current popular movies as a pageable list.
    ///
    /// - Note: This convenience omits `country` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `country`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func popular(
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> MoviePageableList {
        try await popular(page: page, country: nil, language: language)
    }

    ///
    /// Returns a list of current popular movies.
    ///
    /// [TMDb API - Movie List: Popular](https://developer.themoviedb.org/reference/movie-popular-list)
    ///
    /// - Parameters:
    ///    - country: ISO-3166-1 country code to fetch results for. Defaults to the client's configured default country.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Current popular movies as a pageable list.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func popular(
        country: String?,
        language: String?
    ) async throws(TMDbError) -> MoviePageableList {
        try await popular(page: nil, country: country, language: language)
    }

    ///
    /// Returns a list of current popular movies.
    ///
    /// [TMDb API - Movie List: Popular](https://developer.themoviedb.org/reference/movie-popular-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameter page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Current popular movies as a pageable list.
    ///
    /// - Note: This convenience omits `country` and `language` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `country` and `language`.
    /// A defaulted overload would instead become that requirement's default implementation.
    ///
    func popular(page: Int?) async throws(TMDbError) -> MoviePageableList {
        try await popular(page: page, country: nil, language: nil)
    }

    ///
    /// Returns a list of current popular movies.
    ///
    /// [TMDb API - Movie List: Popular](https://developer.themoviedb.org/reference/movie-popular-list)
    ///
    /// - Parameter country: ISO-3166-1 country code to fetch results for. Defaults to the client's configured default
    /// country.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Current popular movies as a pageable list.
    ///
    /// - Note: This convenience omits `page` and `language` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `page` and `language`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func popular(country: String?) async throws(TMDbError) -> MoviePageableList {
        try await popular(page: nil, country: country, language: nil)
    }

    ///
    /// Returns a list of current popular movies.
    ///
    /// [TMDb API - Movie List: Popular](https://developer.themoviedb.org/reference/movie-popular-list)
    ///
    /// - Parameter language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Current popular movies as a pageable list.
    ///
    /// - Note: This convenience omits `page` and `country` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `page` and `country`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func popular(language: String?) async throws(TMDbError) -> MoviePageableList {
        try await popular(page: nil, country: nil, language: language)
    }

    ///
    /// Returns a list of current popular movies.
    ///
    /// [TMDb API - Movie List: Popular](https://developer.themoviedb.org/reference/movie-popular-list)
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Current popular movies as a pageable list.
    ///
    /// - Note: This convenience omits `page`, `country` and `language` rather than defaulting them, so that its
    /// signature stays distinct from the requirement it forwards to; it calls the requirement with `nil` for `page`,
    /// `country` and `language`. A defaulted overload would instead become that requirement's default implementation.
    ///
    func popular() async throws(TMDbError) -> MoviePageableList {
        try await popular(page: nil, country: nil, language: nil)
    }

    ///
    /// Returns a list of recommended movies for a movie.
    ///
    /// [TMDb API - Movies: Recommendations](https://developer.themoviedb.org/reference/movie-recommendations)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie for get recommendations for.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Recommended movies for the matching movie as a pageable list.
    ///
    /// - Note: This convenience omits `language` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `language`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func recommendations(
        forMovie movieID: Movie.ID,
        page: Int?
    ) async throws(TMDbError) -> MoviePageableList {
        try await recommendations(forMovie: movieID, page: page, language: nil)
    }

    ///
    /// Returns a list of recommended movies for a movie.
    ///
    /// [TMDb API - Movies: Recommendations](https://developer.themoviedb.org/reference/movie-recommendations)
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie for get recommendations for.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Recommended movies for the matching movie as a pageable list.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func recommendations(
        forMovie movieID: Movie.ID,
        language: String?
    ) async throws(TMDbError) -> MoviePageableList {
        try await recommendations(forMovie: movieID, page: nil, language: language)
    }

    ///
    /// Returns a list of recommended movies for a movie.
    ///
    /// [TMDb API - Movies: Recommendations](https://developer.themoviedb.org/reference/movie-recommendations)
    ///
    /// - Parameter movieID: The identifier of the movie for get recommendations for.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Recommended movies for the matching movie as a pageable list.
    ///
    /// - Note: This convenience omits `page` and `language` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `page` and `language`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func recommendations(forMovie movieID: Movie.ID) async throws(TMDbError) -> MoviePageableList {
        try await recommendations(forMovie: movieID, page: nil, language: nil)
    }

    ///
    /// Returns the user reviews for a movie.
    ///
    /// [TMDb API - Movies: Reviews](https://developer.themoviedb.org/reference/movie-reviews)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Reviews for the matching movie as a pageable list.
    ///
    /// - Note: This convenience omits `language` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `language`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func reviews(
        forMovie movieID: Movie.ID,
        page: Int?
    ) async throws(TMDbError) -> ReviewPageableList {
        try await reviews(forMovie: movieID, page: page, language: nil)
    }

    ///
    /// Returns the user reviews for a movie.
    ///
    /// [TMDb API - Movies: Reviews](https://developer.themoviedb.org/reference/movie-reviews)
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Reviews for the matching movie as a pageable list.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func reviews(
        forMovie movieID: Movie.ID,
        language: String?
    ) async throws(TMDbError) -> ReviewPageableList {
        try await reviews(forMovie: movieID, page: nil, language: language)
    }

    ///
    /// Returns the user reviews for a movie.
    ///
    /// [TMDb API - Movies: Reviews](https://developer.themoviedb.org/reference/movie-reviews)
    ///
    /// - Parameter movieID: The identifier of the movie.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Reviews for the matching movie as a pageable list.
    ///
    /// - Note: This convenience omits `page` and `language` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `page` and `language`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func reviews(forMovie movieID: Movie.ID) async throws(TMDbError) -> ReviewPageableList {
        try await reviews(forMovie: movieID, page: nil, language: nil)
    }

    ///
    /// Returns a list of similar movies for a movie.
    ///
    /// This is not the same as the *Recommendations*.
    ///
    /// [TMDb API - Movies: Similar](https://developer.themoviedb.org/reference/movie-similar)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie for get similar movies for.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Similar movies for the matching movie as a pageable list.
    ///
    /// - Note: This convenience omits `language` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `language`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func similar(
        toMovie movieID: Movie.ID,
        page: Int?
    ) async throws(TMDbError) -> MoviePageableList {
        try await similar(toMovie: movieID, page: page, language: nil)
    }

    ///
    /// Returns a list of similar movies for a movie.
    ///
    /// This is not the same as the *Recommendations*.
    ///
    /// [TMDb API - Movies: Similar](https://developer.themoviedb.org/reference/movie-similar)
    ///
    /// - Parameters:
    ///    - movieID: The identifier of the movie for get similar movies for.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Similar movies for the matching movie as a pageable list.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func similar(
        toMovie movieID: Movie.ID,
        language: String?
    ) async throws(TMDbError) -> MoviePageableList {
        try await similar(toMovie: movieID, page: nil, language: language)
    }

    ///
    /// Returns a list of similar movies for a movie.
    ///
    /// This is not the same as the *Recommendations*.
    ///
    /// [TMDb API - Movies: Similar](https://developer.themoviedb.org/reference/movie-similar)
    ///
    /// - Parameter movieID: The identifier of the movie for get similar movies for.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Similar movies for the matching movie as a pageable list.
    ///
    /// - Note: This convenience omits `page` and `language` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `page` and `language`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func similar(toMovie movieID: Movie.ID) async throws(TMDbError) -> MoviePageableList {
        try await similar(toMovie: movieID, page: nil, language: nil)
    }

    ///
    /// Returns a list of top rated movies.
    ///
    /// [TMDb API - Movie List: Top Rated](https://developer.themoviedb.org/reference/movie-top-rated-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - page: The page of results to return.
    ///    - country: ISO-3166-1 country code to fetch results for. Defaults to the client's configured default country.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Top rated movies as a pageable list.
    ///
    /// - Note: This convenience omits `language` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `language`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func topRated(
        page: Int?,
        country: String?
    ) async throws(TMDbError) -> MoviePageableList {
        try await topRated(page: page, country: country, language: nil)
    }

    ///
    /// Returns a list of top rated movies.
    ///
    /// [TMDb API - Movie List: Top Rated](https://developer.themoviedb.org/reference/movie-top-rated-list)
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
    /// - Returns: Top rated movies as a pageable list.
    ///
    /// - Note: This convenience omits `country` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `country`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func topRated(
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> MoviePageableList {
        try await topRated(page: page, country: nil, language: language)
    }

    ///
    /// Returns a list of top rated movies.
    ///
    /// [TMDb API - Movie List: Top Rated](https://developer.themoviedb.org/reference/movie-top-rated-list)
    ///
    /// - Parameters:
    ///    - country: ISO-3166-1 country code to fetch results for. Defaults to the client's configured default country.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Top rated movies as a pageable list.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func topRated(
        country: String?,
        language: String?
    ) async throws(TMDbError) -> MoviePageableList {
        try await topRated(page: nil, country: country, language: language)
    }

    ///
    /// Returns a list of top rated movies.
    ///
    /// [TMDb API - Movie List: Top Rated](https://developer.themoviedb.org/reference/movie-top-rated-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameter page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Top rated movies as a pageable list.
    ///
    /// - Note: This convenience omits `country` and `language` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `country` and `language`.
    /// A defaulted overload would instead become that requirement's default implementation.
    ///
    func topRated(page: Int?) async throws(TMDbError) -> MoviePageableList {
        try await topRated(page: page, country: nil, language: nil)
    }

    ///
    /// Returns a list of top rated movies.
    ///
    /// [TMDb API - Movie List: Top Rated](https://developer.themoviedb.org/reference/movie-top-rated-list)
    ///
    /// - Parameter country: ISO-3166-1 country code to fetch results for. Defaults to the client's configured default
    /// country.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Top rated movies as a pageable list.
    ///
    /// - Note: This convenience omits `page` and `language` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `page` and `language`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func topRated(country: String?) async throws(TMDbError) -> MoviePageableList {
        try await topRated(page: nil, country: country, language: nil)
    }

    ///
    /// Returns a list of top rated movies.
    ///
    /// [TMDb API - Movie List: Top Rated](https://developer.themoviedb.org/reference/movie-top-rated-list)
    ///
    /// - Parameter language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Top rated movies as a pageable list.
    ///
    /// - Note: This convenience omits `page` and `country` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `page` and `country`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func topRated(language: String?) async throws(TMDbError) -> MoviePageableList {
        try await topRated(page: nil, country: nil, language: language)
    }

    ///
    /// Returns a list of top rated movies.
    ///
    /// [TMDb API - Movie List: Top Rated](https://developer.themoviedb.org/reference/movie-top-rated-list)
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Top rated movies as a pageable list.
    ///
    /// - Note: This convenience omits `page`, `country` and `language` rather than defaulting them, so that its
    /// signature stays distinct from the requirement it forwards to; it calls the requirement with `nil` for `page`,
    /// `country` and `language`. A defaulted overload would instead become that requirement's default implementation.
    ///
    func topRated() async throws(TMDbError) -> MoviePageableList {
        try await topRated(page: nil, country: nil, language: nil)
    }

    ///
    /// Returns a list of upcoming movies.
    ///
    /// [TMDb API - Movie List: Upcoming](https://developer.themoviedb.org/reference/movie-upcoming-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - page: The page of results to return.
    ///    - country: ISO-3166-1 country code to fetch results for. Defaults to the client's configured default country.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Upcoming movies as a pageable list.
    ///
    /// - Note: This convenience omits `language` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `language`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func upcoming(
        page: Int?,
        country: String?
    ) async throws(TMDbError) -> MoviePageableList {
        try await upcoming(page: page, country: country, language: nil)
    }

    ///
    /// Returns a list of upcoming movies.
    ///
    /// [TMDb API - Movie List: Upcoming](https://developer.themoviedb.org/reference/movie-upcoming-list)
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
    /// - Returns: Upcoming movies as a pageable list.
    ///
    /// - Note: This convenience omits `country` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `country`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func upcoming(
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> MoviePageableList {
        try await upcoming(page: page, country: nil, language: language)
    }

    ///
    /// Returns a list of upcoming movies.
    ///
    /// [TMDb API - Movie List: Upcoming](https://developer.themoviedb.org/reference/movie-upcoming-list)
    ///
    /// - Parameters:
    ///    - country: ISO-3166-1 country code to fetch results for. Defaults to the client's configured default country.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Upcoming movies as a pageable list.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func upcoming(
        country: String?,
        language: String?
    ) async throws(TMDbError) -> MoviePageableList {
        try await upcoming(page: nil, country: country, language: language)
    }

    ///
    /// Returns a list of upcoming movies.
    ///
    /// [TMDb API - Movie List: Upcoming](https://developer.themoviedb.org/reference/movie-upcoming-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameter page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Upcoming movies as a pageable list.
    ///
    /// - Note: This convenience omits `country` and `language` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `country` and `language`.
    /// A defaulted overload would instead become that requirement's default implementation.
    ///
    func upcoming(page: Int?) async throws(TMDbError) -> MoviePageableList {
        try await upcoming(page: page, country: nil, language: nil)
    }

    ///
    /// Returns a list of upcoming movies.
    ///
    /// [TMDb API - Movie List: Upcoming](https://developer.themoviedb.org/reference/movie-upcoming-list)
    ///
    /// - Parameter country: ISO-3166-1 country code to fetch results for. Defaults to the client's configured default
    /// country.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Upcoming movies as a pageable list.
    ///
    /// - Note: This convenience omits `page` and `language` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `page` and `language`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func upcoming(country: String?) async throws(TMDbError) -> MoviePageableList {
        try await upcoming(page: nil, country: country, language: nil)
    }

    ///
    /// Returns a list of upcoming movies.
    ///
    /// [TMDb API - Movie List: Upcoming](https://developer.themoviedb.org/reference/movie-upcoming-list)
    ///
    /// - Parameter language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Upcoming movies as a pageable list.
    ///
    /// - Note: This convenience omits `page` and `country` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `page` and `country`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func upcoming(language: String?) async throws(TMDbError) -> MoviePageableList {
        try await upcoming(page: nil, country: nil, language: language)
    }

    ///
    /// Returns a list of upcoming movies.
    ///
    /// [TMDb API - Movie List: Upcoming](https://developer.themoviedb.org/reference/movie-upcoming-list)
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Upcoming movies as a pageable list.
    ///
    /// - Note: This convenience omits `page`, `country` and `language` rather than defaulting them, so that its
    /// signature stays distinct from the requirement it forwards to; it calls the requirement with `nil` for `page`,
    /// `country` and `language`. A defaulted overload would instead become that requirement's default implementation.
    ///
    func upcoming() async throws(TMDbError) -> MoviePageableList {
        try await upcoming(page: nil, country: nil, language: nil)
    }

}
