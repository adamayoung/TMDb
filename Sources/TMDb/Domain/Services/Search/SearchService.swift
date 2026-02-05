//
//  SearchService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Provides an interface for searching content from TMDb..
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public protocol SearchService: Sendable {

    ///
    /// Returns search results for movies, TV series and people based on a query.
    ///
    /// [TMDb API - Search: Multi](https://developer.themoviedb.org/reference/search-multi)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - filter: Search filter.
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Movies, TV series and people matching the query.
    ///
    func searchAll(
        query: String,
        filter: AllMediaSearchFilter?,
        page: Int?,
        language: String?
    ) async throws -> MediaPageableList

    ///
    /// Returns search results for movies.
    ///
    /// [TMDb API - Search: Movies](https://developer.themoviedb.org/reference/search-movie)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - filter: Search filter.
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Movies matching the query.
    ///
    func searchMovies(
        query: String,
        filter: MovieSearchFilter?,
        page: Int?,
        language: String?
    ) async throws -> MoviePageableList

    ///
    /// Returns search results for TV series.
    ///
    /// [TMDb API - Search: TV](https://developer.themoviedb.org/reference/search-tv)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - filter: Search filter.
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: TV series matching the query.
    ///
    func searchTVSeries(
        query: String,
        filter: TVSeriesSearchFilter?,
        page: Int?,
        language: String?
    ) async throws -> TVSeriesPageableList

    ///
    /// Returns search results for people.
    ///
    /// [TMDb API - Search: Person](https://developer.themoviedb.org/reference/search-person)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - filter: Search filter.
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: People matching the query.
    ///
    func searchPeople(
        query: String,
        filter: PersonSearchFilter?,
        page: Int?,
        language: String?
    ) async throws -> PersonPageableList

    ///
    /// Returns search results for collections.
    ///
    /// [TMDb API - Search: Collection](https://developer.themoviedb.org/reference/search-collection)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in.
    ///   Defaults to the client's configured default language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Collections matching the query.
    ///
    func searchCollections(
        query: String,
        page: Int?,
        language: String?
    ) async throws -> CollectionPageableList

    ///
    /// Returns search results for companies.
    ///
    /// [TMDb API - Search: Company](https://developer.themoviedb.org/reference/search-company)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Companies matching the query.
    ///
    func searchCompanies(
        query: String,
        page: Int?
    ) async throws -> CompanyPageableList

    ///
    /// Returns search results for keywords.
    ///
    /// [TMDb API - Search: Keyword](https://developer.themoviedb.org/reference/search-keyword)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Keywords matching the query.
    ///
    func searchKeywords(
        query: String,
        page: Int?
    ) async throws -> KeywordPageableList

}

public extension SearchService {

    ///
    /// Returns search results for movies, TV series and people based on a query.
    ///
    /// [TMDb API - Search: Multi](https://developer.themoviedb.org/reference/search-multi)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - filter: Search filter.
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Movies, TV series and people matching the query.
    ///
    func searchAll(
        query: String,
        filter: AllMediaSearchFilter? = nil,
        page: Int? = nil,
        language: String? = nil
    ) async throws -> MediaPageableList {
        try await searchAll(query: query, filter: filter, page: page, language: language)
    }

    ///
    /// Returns search results for movies.
    ///
    /// [TMDb API - Search: Movies](https://developer.themoviedb.org/reference/search-movie)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - filter: Search filter.
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Movies matching the query.
    ///
    func searchMovies(
        query: String,
        filter: MovieSearchFilter? = nil,
        page: Int? = nil,
        language: String? = nil
    ) async throws -> MoviePageableList {
        try await searchMovies(query: query, filter: filter, page: page, language: language)
    }

    ///
    /// Returns search results for TV series.
    ///
    /// [TMDb API - Search: TV](https://developer.themoviedb.org/reference/search-tv)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - filter: Search filter.
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: TV series matching the query.
    ///
    func searchTVSeries(
        query: String,
        filter: TVSeriesSearchFilter? = nil,
        page: Int? = nil,
        language: String? = nil
    ) async throws -> TVSeriesPageableList {
        try await searchTVSeries(query: query, filter: filter, page: page, language: language)
    }

    ///
    /// Returns search results for people.
    ///
    /// [TMDb API - Search: Person](https://developer.themoviedb.org/reference/search-person)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - filter: Search filter.
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: People matching the query.
    ///
    func searchPeople(
        query: String,
        filter: PersonSearchFilter? = nil,
        page: Int? = nil,
        language: String? = nil
    ) async throws -> PersonPageableList {
        try await searchPeople(query: query, filter: filter, page: page, language: language)
    }

    ///
    /// Returns search results for collections.
    ///
    /// [TMDb API - Search: Collection](https://developer.themoviedb.org/reference/search-collection)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in.
    ///   Defaults to the client's configured default language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Collections matching the query.
    ///
    func searchCollections(
        query: String,
        page: Int? = nil,
        language: String? = nil
    ) async throws -> CollectionPageableList {
        try await searchCollections(
            query: query, page: page, language: language
        )
    }

    ///
    /// Returns search results for companies.
    ///
    /// [TMDb API - Search: Company](https://developer.themoviedb.org/reference/search-company)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Companies matching the query.
    ///
    func searchCompanies(
        query: String,
        page: Int? = nil
    ) async throws -> CompanyPageableList {
        try await searchCompanies(query: query, page: page)
    }

    ///
    /// Returns search results for keywords.
    ///
    /// [TMDb API - Search: Keyword](https://developer.themoviedb.org/reference/search-keyword)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Keywords matching the query.
    ///
    func searchKeywords(
        query: String,
        page: Int? = nil
    ) async throws -> KeywordPageableList {
        try await searchKeywords(query: query, page: page)
    }

}
