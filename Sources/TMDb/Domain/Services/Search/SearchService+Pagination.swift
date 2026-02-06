//
//  SearchService+Pagination.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Auto-pagination extensions for ``SearchService``.
///
/// These methods provide lazy `AsyncSequence`-based iteration over paginated search endpoints,
/// eliminating the need for manual pagination logic.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public extension SearchService {

    // MARK: - Item-Level Iteration

    ///
    /// Returns an async sequence of all multi-search results (movies, TV series, people) across all pages.
    ///
    /// Pages are fetched lazily as items are consumed from the sequence.
    ///
    /// [TMDb API - Search: Multi](https://developer.themoviedb.org/reference/search-multi)
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - filter: Search filter.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields individual ``Media`` objects.
    ///
    func allMulti(
        query: String,
        filter: AllMediaSearchFilter? = nil,
        language: String? = nil
    ) -> PagedAsyncSequence<Media> {
        PagedAsyncSequence { [self] page in
            try await searchAll(query: query, filter: filter, page: page, language: language)
        }
    }

    ///
    /// Returns an async sequence of all movie search results across all pages.
    ///
    /// Pages are fetched lazily as items are consumed from the sequence.
    ///
    /// [TMDb API - Search: Movies](https://developer.themoviedb.org/reference/search-movie)
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - filter: Search filter.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields individual ``MovieListItem`` objects.
    ///
    func allMovies(
        query: String,
        filter: MovieSearchFilter? = nil,
        language: String? = nil
    ) -> PagedAsyncSequence<MovieListItem> {
        PagedAsyncSequence { [self] page in
            try await searchMovies(query: query, filter: filter, page: page, language: language)
        }
    }

    ///
    /// Returns an async sequence of all TV series search results across all pages.
    ///
    /// Pages are fetched lazily as items are consumed from the sequence.
    ///
    /// [TMDb API - Search: TV](https://developer.themoviedb.org/reference/search-tv)
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - filter: Search filter.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields individual ``TVSeriesListItem`` objects.
    ///
    func allTVSeries(
        query: String,
        filter: TVSeriesSearchFilter? = nil,
        language: String? = nil
    ) -> PagedAsyncSequence<TVSeriesListItem> {
        PagedAsyncSequence { [self] page in
            try await searchTVSeries(query: query, filter: filter, page: page, language: language)
        }
    }

    ///
    /// Returns an async sequence of all people search results across all pages.
    ///
    /// Pages are fetched lazily as items are consumed from the sequence.
    ///
    /// [TMDb API - Search: Person](https://developer.themoviedb.org/reference/search-person)
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - filter: Search filter.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields individual ``PersonListItem`` objects.
    ///
    func allPeople(
        query: String,
        filter: PersonSearchFilter? = nil,
        language: String? = nil
    ) -> PagedAsyncSequence<PersonListItem> {
        PagedAsyncSequence { [self] page in
            try await searchPeople(query: query, filter: filter, page: page, language: language)
        }
    }

    ///
    /// Returns an async sequence of all collection search results across all pages.
    ///
    /// Pages are fetched lazily as items are consumed from the sequence.
    ///
    /// [TMDb API - Search: Collection](https://developer.themoviedb.org/reference/search-collection)
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields individual ``CollectionListItem`` objects.
    ///
    func allCollections(
        query: String,
        language: String? = nil
    ) -> PagedAsyncSequence<CollectionListItem> {
        PagedAsyncSequence { [self] page in
            try await searchCollections(query: query, page: page, language: language)
        }
    }

    ///
    /// Returns an async sequence of all company search results across all pages.
    ///
    /// Pages are fetched lazily as items are consumed from the sequence.
    ///
    /// [TMDb API - Search: Company](https://developer.themoviedb.org/reference/search-company)
    ///
    /// - Parameter query: A text query to search for.
    ///
    /// - Returns: An async sequence that yields individual ``ProductionCompany`` objects.
    ///
    func allCompanies(
        query: String
    ) -> PagedAsyncSequence<ProductionCompany> {
        PagedAsyncSequence { [self] page in
            try await searchCompanies(query: query, page: page)
        }
    }

    ///
    /// Returns an async sequence of all keyword search results across all pages.
    ///
    /// Pages are fetched lazily as items are consumed from the sequence.
    ///
    /// [TMDb API - Search: Keyword](https://developer.themoviedb.org/reference/search-keyword)
    ///
    /// - Parameter query: A text query to search for.
    ///
    /// - Returns: An async sequence that yields individual ``Keyword`` objects.
    ///
    func allKeywords(
        query: String
    ) -> PagedAsyncSequence<Keyword> {
        PagedAsyncSequence { [self] page in
            try await searchKeywords(query: query, page: page)
        }
    }

    // MARK: - Page-Level Iteration

    ///
    /// Returns an async sequence of all multi-search result pages (movies, TV series, people).
    ///
    /// Pages are fetched lazily as they are consumed from the sequence.
    ///
    /// [TMDb API - Search: Multi](https://developer.themoviedb.org/reference/search-multi)
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - filter: Search filter.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages containing ``Media`` objects.
    ///
    func allMultiPages(
        query: String,
        filter: AllMediaSearchFilter? = nil,
        language: String? = nil
    ) -> PagedPagesAsyncSequence<Media> {
        PagedPagesAsyncSequence { [self] page in
            try await searchAll(query: query, filter: filter, page: page, language: language)
        }
    }

    ///
    /// Returns an async sequence of all movie search result pages.
    ///
    /// Pages are fetched lazily as they are consumed from the sequence.
    ///
    /// [TMDb API - Search: Movies](https://developer.themoviedb.org/reference/search-movie)
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - filter: Search filter.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages containing ``MovieListItem`` objects.
    ///
    func allMoviesPages(
        query: String,
        filter: MovieSearchFilter? = nil,
        language: String? = nil
    ) -> PagedPagesAsyncSequence<MovieListItem> {
        PagedPagesAsyncSequence { [self] page in
            try await searchMovies(query: query, filter: filter, page: page, language: language)
        }
    }

    ///
    /// Returns an async sequence of all TV series search result pages.
    ///
    /// Pages are fetched lazily as they are consumed from the sequence.
    ///
    /// [TMDb API - Search: TV](https://developer.themoviedb.org/reference/search-tv)
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - filter: Search filter.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages containing ``TVSeriesListItem`` objects.
    ///
    func allTVSeriesPages(
        query: String,
        filter: TVSeriesSearchFilter? = nil,
        language: String? = nil
    ) -> PagedPagesAsyncSequence<TVSeriesListItem> {
        PagedPagesAsyncSequence { [self] page in
            try await searchTVSeries(query: query, filter: filter, page: page, language: language)
        }
    }

    ///
    /// Returns an async sequence of all people search result pages.
    ///
    /// Pages are fetched lazily as they are consumed from the sequence.
    ///
    /// [TMDb API - Search: Person](https://developer.themoviedb.org/reference/search-person)
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - filter: Search filter.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages containing ``PersonListItem`` objects.
    ///
    func allPeoplePages(
        query: String,
        filter: PersonSearchFilter? = nil,
        language: String? = nil
    ) -> PagedPagesAsyncSequence<PersonListItem> {
        PagedPagesAsyncSequence { [self] page in
            try await searchPeople(query: query, filter: filter, page: page, language: language)
        }
    }

    ///
    /// Returns an async sequence of all collection search result pages.
    ///
    /// Pages are fetched lazily as they are consumed from the sequence.
    ///
    /// [TMDb API - Search: Collection](https://developer.themoviedb.org/reference/search-collection)
    ///
    /// - Parameters:
    ///    - query: A text query to search for.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages containing ``CollectionListItem`` objects.
    ///
    func allCollectionsPages(
        query: String,
        language: String? = nil
    ) -> PagedPagesAsyncSequence<CollectionListItem> {
        PagedPagesAsyncSequence { [self] page in
            try await searchCollections(query: query, page: page, language: language)
        }
    }

    ///
    /// Returns an async sequence of all company search result pages.
    ///
    /// Pages are fetched lazily as they are consumed from the sequence.
    ///
    /// [TMDb API - Search: Company](https://developer.themoviedb.org/reference/search-company)
    ///
    /// - Parameter query: A text query to search for.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages containing ``ProductionCompany`` objects.
    ///
    func allCompaniesPages(
        query: String
    ) -> PagedPagesAsyncSequence<ProductionCompany> {
        PagedPagesAsyncSequence { [self] page in
            try await searchCompanies(query: query, page: page)
        }
    }

    ///
    /// Returns an async sequence of all keyword search result pages.
    ///
    /// Pages are fetched lazily as they are consumed from the sequence.
    ///
    /// [TMDb API - Search: Keyword](https://developer.themoviedb.org/reference/search-keyword)
    ///
    /// - Parameter query: A text query to search for.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages containing ``Keyword`` objects.
    ///
    func allKeywordsPages(
        query: String
    ) -> PagedPagesAsyncSequence<Keyword> {
        PagedPagesAsyncSequence { [self] page in
            try await searchKeywords(query: query, page: page)
        }
    }

}
