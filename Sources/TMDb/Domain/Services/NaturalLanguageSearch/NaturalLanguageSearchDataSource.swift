//
//  NaturalLanguageSearchDataSource.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A narrow facade over the TMDb services used by ``SearchPlanExecutor``.
///
/// This protocol exists so the executor can be tested deterministically without
/// the networking stack and without the on-device language model. A live
/// implementation adapts the concrete TMDb services; tests provide a mock.
///
protocol NaturalLanguageSearchDataSource: Sendable {

    /// The official movie genres.
    func movieGenres() async throws -> [Genre]

    /// The official TV series genres.
    func tvSeriesGenres() async throws -> [Genre]

    /// Discovers movies matching a filter.
    func discoverMovies(
        filter: DiscoverMovieFilter,
        sortedBy: MovieSort?
    ) async throws -> [MovieListItem]

    /// Discovers TV series matching a filter.
    func discoverTVSeries(
        filter: DiscoverTVSeriesFilter,
        sortedBy: TVSeriesSort?
    ) async throws -> [TVSeriesListItem]

    /// Searches for movies by title.
    func searchMovies(query: String) async throws -> [MovieListItem]

    /// Searches for TV series by title.
    func searchTVSeries(query: String) async throws -> [TVSeriesListItem]

    /// Searches for people by name.
    func searchPeople(query: String) async throws -> [PersonListItem]

    /// Searches for companies by name.
    func searchCompanies(query: String) async throws -> [ProductionCompany]

    /// Searches across movies, TV series, and people (literal fallback).
    func searchAll(
        query: String
    ) async throws -> (movies: [MovieListItem], tvSeries: [TVSeriesListItem], people: [PersonListItem])

    /// Movies similar to a movie.
    func similarMovies(toMovie id: Movie.ID) async throws -> [MovieListItem]

    /// TV series similar to a TV series.
    func similarTVSeries(toTVSeries id: TVSeries.ID) async throws -> [TVSeriesListItem]

    /// The credits for a movie.
    func movieCredits(forMovie id: Movie.ID) async throws -> ShowCredits

    /// The credits for a TV series.
    func tvSeriesCredits(forTVSeries id: TVSeries.ID) async throws -> ShowCredits

    /// A curated movie list.
    func curatedMovies(_ kind: SearchPlan.ListKind) async throws -> [MovieListItem]

    /// A curated TV series list.
    func curatedTVSeries(_ kind: SearchPlan.ListKind) async throws -> [TVSeriesListItem]

    /// Trending people.
    func trendingPeople() async throws -> [PersonListItem]

}
