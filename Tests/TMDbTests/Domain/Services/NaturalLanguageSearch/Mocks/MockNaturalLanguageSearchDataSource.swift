//
//  MockNaturalLanguageSearchDataSource.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import TMDb

final class MockNaturalLanguageSearchDataSource: NaturalLanguageSearchDataSource, @unchecked Sendable {

    // Configurable return values.
    var movieGenresResult: [Genre] = []
    var tvSeriesGenresResult: [Genre] = []
    var discoverMoviesResult: [MovieListItem] = []
    var discoverTVSeriesResult: [TVSeriesListItem] = []
    var searchMoviesResult: [MovieListItem] = []
    var searchTVSeriesResult: [TVSeriesListItem] = []
    var searchPeopleResult: [PersonListItem] = []
    var searchCompaniesResult: [ProductionCompany] = []
    var searchAllResult: (movies: [MovieListItem], tvSeries: [TVSeriesListItem], people: [PersonListItem]) = (
        [],
        [],
        []
    )
    var similarMoviesResult: [MovieListItem] = []
    var similarTVSeriesResult: [TVSeriesListItem] = []
    var movieCreditsResult = ShowCredits(id: 0, cast: [], crew: [])
    var tvSeriesCreditsResult = ShowCredits(id: 0, cast: [], crew: [])
    var curatedMoviesResult: [MovieListItem] = []
    var curatedTVSeriesResult: [TVSeriesListItem] = []
    var trendingPeopleResult: [PersonListItem] = []

    // Captured inputs.
    private(set) var lastMovieFilter: DiscoverMovieFilter?
    private(set) var lastTVFilter: DiscoverTVSeriesFilter?
    private(set) var lastCuratedMovieKind: SearchPlan.ListKind?
    private(set) var lastCuratedTVKind: SearchPlan.ListKind?
    private(set) var searchPeopleQueries: [String] = []
    private(set) var searchCompaniesQueries: [String] = []
    private(set) var searchAllQueries: [String] = []

    func movieGenres() async throws -> [Genre] {
        movieGenresResult
    }

    func tvSeriesGenres() async throws -> [Genre] {
        tvSeriesGenresResult
    }

    func discoverMovies(filter: DiscoverMovieFilter, sortedBy: MovieSort?) async throws -> [MovieListItem] {
        lastMovieFilter = filter
        return discoverMoviesResult
    }

    func discoverTVSeries(
        filter: DiscoverTVSeriesFilter,
        sortedBy: TVSeriesSort?
    ) async throws -> [TVSeriesListItem] {
        lastTVFilter = filter
        return discoverTVSeriesResult
    }

    func searchMovies(query: String) async throws -> [MovieListItem] {
        searchMoviesResult
    }

    func searchTVSeries(query: String) async throws -> [TVSeriesListItem] {
        searchTVSeriesResult
    }

    func searchPeople(query: String) async throws -> [PersonListItem] {
        searchPeopleQueries.append(query)
        return searchPeopleResult
    }

    func searchCompanies(query: String) async throws -> [ProductionCompany] {
        searchCompaniesQueries.append(query)
        return searchCompaniesResult
    }

    func searchAll(
        query: String
    ) async throws -> (movies: [MovieListItem], tvSeries: [TVSeriesListItem], people: [PersonListItem]) {
        searchAllQueries.append(query)
        return searchAllResult
    }

    func similarMovies(toMovie id: Movie.ID) async throws -> [MovieListItem] {
        similarMoviesResult
    }

    func similarTVSeries(toTVSeries id: TVSeries.ID) async throws -> [TVSeriesListItem] {
        similarTVSeriesResult
    }

    func movieCredits(forMovie id: Movie.ID) async throws -> ShowCredits {
        movieCreditsResult
    }

    func tvSeriesCredits(forTVSeries id: TVSeries.ID) async throws -> ShowCredits {
        tvSeriesCreditsResult
    }

    func curatedMovies(_ kind: SearchPlan.ListKind) async throws -> [MovieListItem] {
        lastCuratedMovieKind = kind
        return curatedMoviesResult
    }

    func curatedTVSeries(_ kind: SearchPlan.ListKind) async throws -> [TVSeriesListItem] {
        lastCuratedTVKind = kind
        return curatedTVSeriesResult
    }

    func trendingPeople() async throws -> [PersonListItem] {
        trendingPeopleResult
    }

}
