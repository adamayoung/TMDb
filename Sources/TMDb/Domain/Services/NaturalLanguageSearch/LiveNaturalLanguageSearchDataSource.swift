//
//  LiveNaturalLanguageSearchDataSource.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A ``NaturalLanguageSearchDataSource`` backed by the concrete TMDb services.
///
/// This adapter has no dependency on Foundation Models, so it builds on every
/// platform. Each service is invoked with default parameters, so the client's
/// configured default language and country apply.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
struct LiveNaturalLanguageSearchDataSource: NaturalLanguageSearchDataSource {

    private let discover: any DiscoverService
    private let search: any SearchService
    private let genres: any GenreService
    private let movies: any MovieService
    private let tvSeries: any TVSeriesService
    private let people: any PersonService
    private let trending: any TrendingService

    init(
        discover: any DiscoverService,
        search: any SearchService,
        genres: any GenreService,
        movies: any MovieService,
        tvSeries: any TVSeriesService,
        people: any PersonService,
        trending: any TrendingService
    ) {
        self.discover = discover
        self.search = search
        self.genres = genres
        self.movies = movies
        self.tvSeries = tvSeries
        self.people = people
        self.trending = trending
    }

    func movieGenres() async throws -> [Genre] {
        try await genres.movieGenres()
    }

    func tvSeriesGenres() async throws -> [Genre] {
        try await genres.tvSeriesGenres()
    }

    func discoverMovies(filter: DiscoverMovieFilter, sortedBy: MovieSort?) async throws -> [MovieListItem] {
        try await discover.movies(filter: filter, sortedBy: sortedBy).results
    }

    func discoverTVSeries(
        filter: DiscoverTVSeriesFilter,
        sortedBy: TVSeriesSort?
    ) async throws -> [TVSeriesListItem] {
        try await discover.tvSeries(filter: filter, sortedBy: sortedBy).results
    }

    func searchMovies(query: String) async throws -> [MovieListItem] {
        try await search.searchMovies(query: query).results
    }

    func searchTVSeries(query: String) async throws -> [TVSeriesListItem] {
        try await search.searchTVSeries(query: query).results
    }

    func searchPeople(query: String) async throws -> [PersonListItem] {
        try await search.searchPeople(query: query).results
    }

    func searchCompanies(query: String) async throws -> [ProductionCompany] {
        try await search.searchCompanies(query: query).results
    }

    func searchAll(
        query: String
    ) async throws -> (movies: [MovieListItem], tvSeries: [TVSeriesListItem], people: [PersonListItem]) {
        // Use the typed search endpoints so full list items (not Media items) are
        // returned, and so adult content is never included.
        async let movieResults = search.searchMovies(query: query)
        async let tvResults = search.searchTVSeries(query: query)
        async let peopleResults = search.searchPeople(query: query)
        return try await (
            movieResults.results,
            tvResults.results,
            peopleResults.results
        )
    }

    func recommendedMovies(forMovie id: Movie.ID) async throws -> [MovieListItem] {
        try await movies.recommendations(forMovie: id).results
    }

    func recommendedTVSeries(forTVSeries id: TVSeries.ID) async throws -> [TVSeriesListItem] {
        try await tvSeries.recommendations(forTVSeries: id).results
    }

    func tvSeriesCredits(forPerson id: Person.ID) async throws -> [TVSeriesListItem] {
        let credits = try await people.tvSeriesCredits(forPerson: id)
        // Rank by episode count first: a regular role (Breaking Bad, 62 eps) is far
        // more relevant to "shows X is in" than a one-off guest spot on a hugely
        // popular show (The Simpsons). Popularity breaks ties.
        return credits.cast
            .sorted { lhs, rhs in
                let lhsEpisodes = lhs.episodeCount ?? 0
                let rhsEpisodes = rhs.episodeCount ?? 0
                if lhsEpisodes != rhsEpisodes {
                    return lhsEpisodes > rhsEpisodes
                }
                return (lhs.popularity ?? 0) > (rhs.popularity ?? 0)
            }
            .map { credit in
                TVSeriesListItem(
                    id: credit.id,
                    name: credit.name,
                    originalName: credit.originalName,
                    originalLanguage: credit.originalLanguage,
                    overview: credit.overview,
                    genreIDs: credit.genreIDs,
                    firstAirDate: credit.firstAirDate,
                    originCountries: credit.originCountries,
                    posterPath: credit.posterPath,
                    backdropPath: credit.backdropPath,
                    popularity: credit.popularity,
                    voteAverage: credit.voteAverage,
                    voteCount: credit.voteCount,
                    isAdultOnly: credit.isAdultOnly
                )
            }
    }

    func movieCredits(forMovie id: Movie.ID) async throws -> ShowCredits {
        try await movies.credits(forMovie: id)
    }

    func tvSeriesCredits(forTVSeries id: TVSeries.ID) async throws -> ShowCredits {
        try await tvSeries.credits(forTVSeries: id)
    }

    func curatedMovies(_ kind: SearchPlan.ListKind) async throws -> [MovieListItem] {
        switch kind {
        case .trending: try await trending.movies().results
        case .popular: try await movies.popular().results
        case .topRated: try await movies.topRated().results
        case .nowPlaying, .airingToday: try await movies.nowPlaying().results
        case .upcoming: try await movies.upcoming().results
        }
    }

    func curatedTVSeries(_ kind: SearchPlan.ListKind) async throws -> [TVSeriesListItem] {
        switch kind {
        case .trending: try await trending.tvSeries().results
        case .popular: try await tvSeries.popular().results
        case .topRated: try await tvSeries.topRated().results
        case .airingToday: try await tvSeries.airingToday().results
        case .nowPlaying, .upcoming: try await tvSeries.onTheAir().results
        }
    }

    func trendingPeople() async throws -> [PersonListItem] {
        try await trending.people().results
    }

}
