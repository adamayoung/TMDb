//
//  GenreService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Provides an interface for obtaining movie and TV series genres from TMDb.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public protocol GenreService: Sendable {

    ///
    /// Returns the list of official genres for movies.
    ///
    /// [TMDb API - Genres: Movie List](https://developer.themoviedb.org/reference/genre-movie-list)
    ///
    /// - Parameter language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A list of genres.
    ///
    func movieGenres(language: String?) async throws -> [Genre]

    ///
    /// Returns the list of official genres for TV series.
    ///
    /// [TMDb API - Genres: TV List](https://developer.themoviedb.org/reference/genre-tv-list)
    ///
    /// - Parameter language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A list of genres.
    ///
    func tvSeriesGenres(language: String?) async throws -> [Genre]

}

public extension GenreService {

    ///
    /// Returns the list of official genres for movies.
    ///
    /// [TMDb API - Genres: Movie List](https://developer.themoviedb.org/reference/genre-movie-list)
    ///
    /// - Parameter language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A list of genres.
    ///
    func movieGenres(language: String? = nil) async throws -> [Genre] {
        try await movieGenres(language: language)
    }

    ///
    /// Returns the list of official genres for TV series.
    ///
    /// [TMDb API - Genres: TV List](https://developer.themoviedb.org/reference/genre-tv-list)
    ///
    /// - Parameter language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A list of genres.
    ///
    func tvSeriesGenres(language: String? = nil) async throws -> [Genre] {
        try await tvSeriesGenres(language: language)
    }

}
