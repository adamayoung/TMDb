//
//  SearchService+Conveniences.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

// swiftlint:disable file_length

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public extension SearchService {

    ///
    /// Returns search results for movies, TV series and people based on a query.
    ///
    /// [TMDb API - Search: Multi](https://developer.themoviedb.org/reference/search-multi)
    ///
    /// - Note: `query` must not be empty or whitespace-only. `page` can be
    ///   between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - filter: Search filter.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Movies, TV series and people matching the query.
    ///
    /// - Note: This convenience omits `language` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `language`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func searchAll(
        query: String,
        filter: AllMediaSearchFilter?,
        page: Int?
    ) async throws(TMDbError) -> MediaPageableList {
        try await searchAll(query: query, filter: filter, page: page, language: nil)
    }

    ///
    /// Returns search results for movies, TV series and people based on a query.
    ///
    /// [TMDb API - Search: Multi](https://developer.themoviedb.org/reference/search-multi)
    ///
    /// - Note: `query` must not be empty or whitespace-only. `page` can be
    ///   between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - filter: Search filter.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Movies, TV series and people matching the query.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func searchAll(
        query: String,
        filter: AllMediaSearchFilter?,
        language: String?
    ) async throws(TMDbError) -> MediaPageableList {
        try await searchAll(query: query, filter: filter, page: nil, language: language)
    }

    ///
    /// Returns search results for movies, TV series and people based on a query.
    ///
    /// [TMDb API - Search: Multi](https://developer.themoviedb.org/reference/search-multi)
    ///
    /// - Note: `query` must not be empty or whitespace-only. `page` can be
    ///   between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Movies, TV series and people matching the query.
    ///
    /// - Note: This convenience omits `filter` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `filter`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func searchAll(
        query: String,
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> MediaPageableList {
        try await searchAll(query: query, filter: nil, page: page, language: language)
    }

    ///
    /// Returns search results for movies, TV series and people based on a query.
    ///
    /// [TMDb API - Search: Multi](https://developer.themoviedb.org/reference/search-multi)
    ///
    /// - Note: `query` must not be empty or whitespace-only. `page` can be
    ///   between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - filter: Search filter.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Movies, TV series and people matching the query.
    ///
    /// - Note: This convenience omits `page` and `language` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `page` and `language`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func searchAll(
        query: String,
        filter: AllMediaSearchFilter?
    ) async throws(TMDbError) -> MediaPageableList {
        try await searchAll(query: query, filter: filter, page: nil, language: nil)
    }

    ///
    /// Returns search results for movies, TV series and people based on a query.
    ///
    /// [TMDb API - Search: Multi](https://developer.themoviedb.org/reference/search-multi)
    ///
    /// - Note: `query` must not be empty or whitespace-only. `page` can be
    ///   between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Movies, TV series and people matching the query.
    ///
    /// - Note: This convenience omits `filter` and `language` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `filter` and `language`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func searchAll(
        query: String,
        page: Int?
    ) async throws(TMDbError) -> MediaPageableList {
        try await searchAll(query: query, filter: nil, page: page, language: nil)
    }

    ///
    /// Returns search results for movies, TV series and people based on a query.
    ///
    /// [TMDb API - Search: Multi](https://developer.themoviedb.org/reference/search-multi)
    ///
    /// - Note: `query` must not be empty or whitespace-only. `page` can be
    ///   between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Movies, TV series and people matching the query.
    ///
    /// - Note: This convenience omits `filter` and `page` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `filter` and `page`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func searchAll(
        query: String,
        language: String?
    ) async throws(TMDbError) -> MediaPageableList {
        try await searchAll(query: query, filter: nil, page: nil, language: language)
    }

    ///
    /// Returns search results for movies, TV series and people based on a query.
    ///
    /// [TMDb API - Search: Multi](https://developer.themoviedb.org/reference/search-multi)
    ///
    /// - Note: `query` must not be empty or whitespace-only. `page` can be
    ///   between `1` and `1000`.
    ///
    /// - Parameter query: A text query to search for.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Movies, TV series and people matching the query.
    ///
    /// - Note: This convenience omits `filter`, `page` and `language` rather than defaulting them, so that its
    /// signature stays distinct from the requirement it forwards to; it calls the requirement with `nil` for `filter`,
    /// `page` and `language`. A defaulted overload would instead become that requirement's default implementation.
    ///
    func searchAll(query: String) async throws(TMDbError) -> MediaPageableList {
        try await searchAll(query: query, filter: nil, page: nil, language: nil)
    }

    ///
    /// Returns search results for collections.
    ///
    /// [TMDb API - Search: Collection](https://developer.themoviedb.org/reference/search-collection)
    ///
    /// - Note: `query` must not be empty or whitespace-only. `page` can be
    ///   between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Collections matching the query.
    ///
    /// - Note: This convenience omits `language` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `language`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func searchCollections(
        query: String,
        page: Int?
    ) async throws(TMDbError) -> CollectionPageableList {
        try await searchCollections(query: query, page: page, language: nil)
    }

    ///
    /// Returns search results for collections.
    ///
    /// [TMDb API - Search: Collection](https://developer.themoviedb.org/reference/search-collection)
    ///
    /// - Note: `query` must not be empty or whitespace-only. `page` can be
    ///   between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - language: ISO 639-1 language code to display results in.
    /// Defaults to the client's configured default language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Collections matching the query.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func searchCollections(
        query: String,
        language: String?
    ) async throws(TMDbError) -> CollectionPageableList {
        try await searchCollections(query: query, page: nil, language: language)
    }

    ///
    /// Returns search results for collections.
    ///
    /// [TMDb API - Search: Collection](https://developer.themoviedb.org/reference/search-collection)
    ///
    /// - Note: `query` must not be empty or whitespace-only. `page` can be
    ///   between `1` and `1000`.
    ///
    /// - Parameter query: A text query to search for.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Collections matching the query.
    ///
    /// - Note: This convenience omits `page` and `language` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `page` and `language`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func searchCollections(query: String) async throws(TMDbError) -> CollectionPageableList {
        try await searchCollections(query: query, page: nil, language: nil)
    }

    ///
    /// Returns search results for movies.
    ///
    /// [TMDb API - Search: Movies](https://developer.themoviedb.org/reference/search-movie)
    ///
    /// - Note: `query` must not be empty or whitespace-only. `page` can be
    ///   between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - filter: Search filter.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Movies matching the query.
    ///
    /// - Note: This convenience omits `language` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `language`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func searchMovies(
        query: String,
        filter: MovieSearchFilter?,
        page: Int?
    ) async throws(TMDbError) -> MoviePageableList {
        try await searchMovies(query: query, filter: filter, page: page, language: nil)
    }

    ///
    /// Returns search results for movies.
    ///
    /// [TMDb API - Search: Movies](https://developer.themoviedb.org/reference/search-movie)
    ///
    /// - Note: `query` must not be empty or whitespace-only. `page` can be
    ///   between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - filter: Search filter.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Movies matching the query.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func searchMovies(
        query: String,
        filter: MovieSearchFilter?,
        language: String?
    ) async throws(TMDbError) -> MoviePageableList {
        try await searchMovies(query: query, filter: filter, page: nil, language: language)
    }

    ///
    /// Returns search results for movies.
    ///
    /// [TMDb API - Search: Movies](https://developer.themoviedb.org/reference/search-movie)
    ///
    /// - Note: `query` must not be empty or whitespace-only. `page` can be
    ///   between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Movies matching the query.
    ///
    /// - Note: This convenience omits `filter` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `filter`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func searchMovies(
        query: String,
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> MoviePageableList {
        try await searchMovies(query: query, filter: nil, page: page, language: language)
    }

    ///
    /// Returns search results for movies.
    ///
    /// [TMDb API - Search: Movies](https://developer.themoviedb.org/reference/search-movie)
    ///
    /// - Note: `query` must not be empty or whitespace-only. `page` can be
    ///   between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - filter: Search filter.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Movies matching the query.
    ///
    /// - Note: This convenience omits `page` and `language` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `page` and `language`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func searchMovies(
        query: String,
        filter: MovieSearchFilter?
    ) async throws(TMDbError) -> MoviePageableList {
        try await searchMovies(query: query, filter: filter, page: nil, language: nil)
    }

    ///
    /// Returns search results for movies.
    ///
    /// [TMDb API - Search: Movies](https://developer.themoviedb.org/reference/search-movie)
    ///
    /// - Note: `query` must not be empty or whitespace-only. `page` can be
    ///   between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Movies matching the query.
    ///
    /// - Note: This convenience omits `filter` and `language` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `filter` and `language`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func searchMovies(
        query: String,
        page: Int?
    ) async throws(TMDbError) -> MoviePageableList {
        try await searchMovies(query: query, filter: nil, page: page, language: nil)
    }

    ///
    /// Returns search results for movies.
    ///
    /// [TMDb API - Search: Movies](https://developer.themoviedb.org/reference/search-movie)
    ///
    /// - Note: `query` must not be empty or whitespace-only. `page` can be
    ///   between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Movies matching the query.
    ///
    /// - Note: This convenience omits `filter` and `page` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `filter` and `page`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func searchMovies(
        query: String,
        language: String?
    ) async throws(TMDbError) -> MoviePageableList {
        try await searchMovies(query: query, filter: nil, page: nil, language: language)
    }

    ///
    /// Returns search results for movies.
    ///
    /// [TMDb API - Search: Movies](https://developer.themoviedb.org/reference/search-movie)
    ///
    /// - Note: `query` must not be empty or whitespace-only. `page` can be
    ///   between `1` and `1000`.
    ///
    /// - Parameter query: A text query to search for.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Movies matching the query.
    ///
    /// - Note: This convenience omits `filter`, `page` and `language` rather than defaulting them, so that its
    /// signature stays distinct from the requirement it forwards to; it calls the requirement with `nil` for `filter`,
    /// `page` and `language`. A defaulted overload would instead become that requirement's default implementation.
    ///
    func searchMovies(query: String) async throws(TMDbError) -> MoviePageableList {
        try await searchMovies(query: query, filter: nil, page: nil, language: nil)
    }

    ///
    /// Returns search results for people.
    ///
    /// [TMDb API - Search: Person](https://developer.themoviedb.org/reference/search-person)
    ///
    /// - Note: `query` must not be empty or whitespace-only. `page` can be
    ///   between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - filter: Search filter.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: People matching the query.
    ///
    /// - Note: This convenience omits `language` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `language`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func searchPeople(
        query: String,
        filter: PersonSearchFilter?,
        page: Int?
    ) async throws(TMDbError) -> PersonPageableList {
        try await searchPeople(query: query, filter: filter, page: page, language: nil)
    }

    ///
    /// Returns search results for people.
    ///
    /// [TMDb API - Search: Person](https://developer.themoviedb.org/reference/search-person)
    ///
    /// - Note: `query` must not be empty or whitespace-only. `page` can be
    ///   between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - filter: Search filter.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: People matching the query.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func searchPeople(
        query: String,
        filter: PersonSearchFilter?,
        language: String?
    ) async throws(TMDbError) -> PersonPageableList {
        try await searchPeople(query: query, filter: filter, page: nil, language: language)
    }

    ///
    /// Returns search results for people.
    ///
    /// [TMDb API - Search: Person](https://developer.themoviedb.org/reference/search-person)
    ///
    /// - Note: `query` must not be empty or whitespace-only. `page` can be
    ///   between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: People matching the query.
    ///
    /// - Note: This convenience omits `filter` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `filter`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func searchPeople(
        query: String,
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> PersonPageableList {
        try await searchPeople(query: query, filter: nil, page: page, language: language)
    }

    ///
    /// Returns search results for people.
    ///
    /// [TMDb API - Search: Person](https://developer.themoviedb.org/reference/search-person)
    ///
    /// - Note: `query` must not be empty or whitespace-only. `page` can be
    ///   between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - filter: Search filter.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: People matching the query.
    ///
    /// - Note: This convenience omits `page` and `language` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `page` and `language`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func searchPeople(
        query: String,
        filter: PersonSearchFilter?
    ) async throws(TMDbError) -> PersonPageableList {
        try await searchPeople(query: query, filter: filter, page: nil, language: nil)
    }

    ///
    /// Returns search results for people.
    ///
    /// [TMDb API - Search: Person](https://developer.themoviedb.org/reference/search-person)
    ///
    /// - Note: `query` must not be empty or whitespace-only. `page` can be
    ///   between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: People matching the query.
    ///
    /// - Note: This convenience omits `filter` and `language` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `filter` and `language`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func searchPeople(
        query: String,
        page: Int?
    ) async throws(TMDbError) -> PersonPageableList {
        try await searchPeople(query: query, filter: nil, page: page, language: nil)
    }

    ///
    /// Returns search results for people.
    ///
    /// [TMDb API - Search: Person](https://developer.themoviedb.org/reference/search-person)
    ///
    /// - Note: `query` must not be empty or whitespace-only. `page` can be
    ///   between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: People matching the query.
    ///
    /// - Note: This convenience omits `filter` and `page` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `filter` and `page`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func searchPeople(
        query: String,
        language: String?
    ) async throws(TMDbError) -> PersonPageableList {
        try await searchPeople(query: query, filter: nil, page: nil, language: language)
    }

    ///
    /// Returns search results for people.
    ///
    /// [TMDb API - Search: Person](https://developer.themoviedb.org/reference/search-person)
    ///
    /// - Note: `query` must not be empty or whitespace-only. `page` can be
    ///   between `1` and `1000`.
    ///
    /// - Parameter query: A text query to search for.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: People matching the query.
    ///
    /// - Note: This convenience omits `filter`, `page` and `language` rather than defaulting them, so that its
    /// signature stays distinct from the requirement it forwards to; it calls the requirement with `nil` for `filter`,
    /// `page` and `language`. A defaulted overload would instead become that requirement's default implementation.
    ///
    func searchPeople(query: String) async throws(TMDbError) -> PersonPageableList {
        try await searchPeople(query: query, filter: nil, page: nil, language: nil)
    }

    ///
    /// Returns search results for TV series.
    ///
    /// [TMDb API - Search: TV](https://developer.themoviedb.org/reference/search-tv)
    ///
    /// - Note: `query` must not be empty or whitespace-only. `page` can be
    ///   between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - filter: Search filter.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: TV series matching the query.
    ///
    /// - Note: This convenience omits `language` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `language`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func searchTVSeries(
        query: String,
        filter: TVSeriesSearchFilter?,
        page: Int?
    ) async throws(TMDbError) -> TVSeriesPageableList {
        try await searchTVSeries(query: query, filter: filter, page: page, language: nil)
    }

    ///
    /// Returns search results for TV series.
    ///
    /// [TMDb API - Search: TV](https://developer.themoviedb.org/reference/search-tv)
    ///
    /// - Note: `query` must not be empty or whitespace-only. `page` can be
    ///   between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - filter: Search filter.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: TV series matching the query.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func searchTVSeries(
        query: String,
        filter: TVSeriesSearchFilter?,
        language: String?
    ) async throws(TMDbError) -> TVSeriesPageableList {
        try await searchTVSeries(query: query, filter: filter, page: nil, language: language)
    }

    ///
    /// Returns search results for TV series.
    ///
    /// [TMDb API - Search: TV](https://developer.themoviedb.org/reference/search-tv)
    ///
    /// - Note: `query` must not be empty or whitespace-only. `page` can be
    ///   between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: TV series matching the query.
    ///
    /// - Note: This convenience omits `filter` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `filter`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func searchTVSeries(
        query: String,
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> TVSeriesPageableList {
        try await searchTVSeries(query: query, filter: nil, page: page, language: language)
    }

    ///
    /// Returns search results for TV series.
    ///
    /// [TMDb API - Search: TV](https://developer.themoviedb.org/reference/search-tv)
    ///
    /// - Note: `query` must not be empty or whitespace-only. `page` can be
    ///   between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - filter: Search filter.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: TV series matching the query.
    ///
    /// - Note: This convenience omits `page` and `language` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `page` and `language`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func searchTVSeries(
        query: String,
        filter: TVSeriesSearchFilter?
    ) async throws(TMDbError) -> TVSeriesPageableList {
        try await searchTVSeries(query: query, filter: filter, page: nil, language: nil)
    }

    ///
    /// Returns search results for TV series.
    ///
    /// [TMDb API - Search: TV](https://developer.themoviedb.org/reference/search-tv)
    ///
    /// - Note: `query` must not be empty or whitespace-only. `page` can be
    ///   between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: TV series matching the query.
    ///
    /// - Note: This convenience omits `filter` and `language` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `filter` and `language`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func searchTVSeries(
        query: String,
        page: Int?
    ) async throws(TMDbError) -> TVSeriesPageableList {
        try await searchTVSeries(query: query, filter: nil, page: page, language: nil)
    }

    ///
    /// Returns search results for TV series.
    ///
    /// [TMDb API - Search: TV](https://developer.themoviedb.org/reference/search-tv)
    ///
    /// - Note: `query` must not be empty or whitespace-only. `page` can be
    ///   between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: TV series matching the query.
    ///
    /// - Note: This convenience omits `filter` and `page` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `filter` and `page`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func searchTVSeries(
        query: String,
        language: String?
    ) async throws(TMDbError) -> TVSeriesPageableList {
        try await searchTVSeries(query: query, filter: nil, page: nil, language: language)
    }

    ///
    /// Returns search results for TV series.
    ///
    /// [TMDb API - Search: TV](https://developer.themoviedb.org/reference/search-tv)
    ///
    /// - Note: `query` must not be empty or whitespace-only. `page` can be
    ///   between `1` and `1000`.
    ///
    /// - Parameter query: A text query to search for.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: TV series matching the query.
    ///
    /// - Note: This convenience omits `filter`, `page` and `language` rather than defaulting them, so that its
    /// signature stays distinct from the requirement it forwards to; it calls the requirement with `nil` for `filter`,
    /// `page` and `language`. A defaulted overload would instead become that requirement's default implementation.
    ///
    func searchTVSeries(query: String) async throws(TMDbError) -> TVSeriesPageableList {
        try await searchTVSeries(query: query, filter: nil, page: nil, language: nil)
    }

}
