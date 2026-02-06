//
//  GuestSessionService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Provides an interface for obtaining guest session rated content
/// data from TMDb.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public protocol GuestSessionService: Sendable {

    ///
    /// Returns a list of movies rated by a guest session.
    ///
    /// [TMDb API - Guest Sessions: Rated Movies](https://developer.themoviedb.org/reference/guest-session-rated-movies)
    ///
    /// - Parameters:
    ///   - sortedBy: How results should be sorted.
    ///   - page: The page of results to return.
    ///   - guestSessionID: The guest session identifier.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A list of rated movies.
    ///
    func ratedMovies(
        sortedBy: RatedSort?,
        page: Int?,
        guestSessionID: String
    ) async throws -> MoviePageableList

    ///
    /// Returns a list of TV series rated by a guest session.
    ///
    /// [TMDb API - Guest Sessions: Rated TV](https://developer.themoviedb.org/reference/guest-session-rated-tv)
    ///
    /// - Parameters:
    ///   - sortedBy: How results should be sorted.
    ///   - page: The page of results to return.
    ///   - guestSessionID: The guest session identifier.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A list of rated TV series.
    ///
    func ratedTVSeries(
        sortedBy: RatedSort?,
        page: Int?,
        guestSessionID: String
    ) async throws -> TVSeriesPageableList

    ///
    /// Returns a list of TV episodes rated by a guest session.
    ///
    /// [TMDb API - Guest Sessions: Rated TV
    /// Episodes](https://developer.themoviedb.org/reference/guest-session-rated-tv-episodes)
    ///
    /// - Parameters:
    ///   - sortedBy: How results should be sorted.
    ///   - page: The page of results to return.
    ///   - guestSessionID: The guest session identifier.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A list of rated TV episodes.
    ///
    func ratedTVEpisodes(
        sortedBy: RatedSort?,
        page: Int?,
        guestSessionID: String
    ) async throws -> TVEpisodePageableList

}
