//
//  GuestSessionService+Defaults.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public extension GuestSessionService {

    ///
    /// Returns a list of movies rated by a guest session.
    ///
    /// [TMDb API - Guest Sessions: Rated Movies](https://developer.themoviedb.org/reference/guest-session-rated-movies)
    ///
    /// - Parameter guestSessionID: The guest session identifier.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A list of rated movies.
    ///
    func ratedMovies(
        guestSessionID: String
    ) async throws -> MoviePageableList {
        try await ratedMovies(
            sortedBy: nil,
            page: nil,
            guestSessionID: guestSessionID
        )
    }

    ///
    /// Returns a list of TV series rated by a guest session.
    ///
    /// [TMDb API - Guest Sessions: Rated TV](https://developer.themoviedb.org/reference/guest-session-rated-tv)
    ///
    /// - Parameter guestSessionID: The guest session identifier.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A list of rated TV series.
    ///
    func ratedTVSeries(
        guestSessionID: String
    ) async throws -> TVSeriesPageableList {
        try await ratedTVSeries(
            sortedBy: nil,
            page: nil,
            guestSessionID: guestSessionID
        )
    }

    ///
    /// Returns a list of TV episodes rated by a guest session.
    ///
    /// [TMDb API - Guest Sessions: Rated TV
    /// Episodes](https://developer.themoviedb.org/reference/guest-session-rated-tv-episodes)
    ///
    /// - Parameter guestSessionID: The guest session identifier.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A list of rated TV episodes.
    ///
    func ratedTVEpisodes(
        guestSessionID: String
    ) async throws -> TVEpisodePageableList {
        try await ratedTVEpisodes(
            sortedBy: nil,
            page: nil,
            guestSessionID: guestSessionID
        )
    }

}
