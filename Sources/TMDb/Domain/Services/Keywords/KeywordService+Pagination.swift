//
//  KeywordService+Pagination.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Auto-pagination extensions for ``KeywordService``.
///
/// These methods provide lazy `AsyncSequence`-based iteration over paginated keyword endpoints,
/// eliminating the need for manual pagination logic.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public extension KeywordService {

    // MARK: - Item-Level Iteration

    ///
    /// Returns an async sequence of all movies for a keyword across all pages.
    ///
    /// Pages are fetched lazily as items are consumed from the sequence.
    ///
    /// [TMDb API - Keywords: Movies](https://developer.themoviedb.org/reference/keyword-movies)
    ///
    /// - Parameters:
    ///    - keywordID: The identifier of the keyword.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields individual ``MovieListItem`` objects.
    ///
    func allMovies(
        forKeyword keywordID: Keyword.ID,
        language: String? = nil
    ) -> PagedAsyncSequence<MovieListItem> {
        PagedAsyncSequence { [self] page in
            try await movies(forKeyword: keywordID, page: page, language: language)
        }
    }

    // MARK: - Page-Level Iteration

    ///
    /// Returns an async sequence of all movie pages for a keyword.
    ///
    /// Pages are fetched lazily as they are consumed from the sequence.
    ///
    /// [TMDb API - Keywords: Movies](https://developer.themoviedb.org/reference/keyword-movies)
    ///
    /// - Parameters:
    ///    - keywordID: The identifier of the keyword.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Returns: An async sequence that yields ``PageableListResult`` pages containing ``MovieListItem`` objects.
    ///
    func allMoviesPages(
        forKeyword keywordID: Keyword.ID,
        language: String? = nil
    ) -> PagedPagesAsyncSequence<MovieListItem> {
        PagedPagesAsyncSequence { [self] page in
            try await movies(forKeyword: keywordID, page: page, language: language)
        }
    }

}
