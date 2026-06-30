//
//  TMDbMovieService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
final class TMDbMovieService: MovieService {

    private let apiClient: any APIClient
    private let configuration: TMDbConfiguration

    init(apiClient: some APIClient, configuration: TMDbConfiguration = .default) {
        self.apiClient = apiClient
        self.configuration = configuration
    }

    func details(forMovie movieID: Movie.ID, language: String? = nil) async throws(TMDbError) -> Movie {
        let languageCode = language ?? configuration.defaultLanguage
        let request = MovieRequest(id: movieID, language: languageCode)

        return try await apiClient.perform(request)
    }

    func details(
        forMovie movieID: Movie.ID,
        appending: MovieAppendOption,
        language: String? = nil
    ) async throws(TMDbError) -> MovieDetailsResponse {
        let languageCode = language ?? configuration.defaultLanguage
        let request = MovieDetailsAppendRequest(
            id: movieID,
            appendToResponse: appending,
            language: languageCode
        )

        return try await apiClient.perform(request)
    }

    func credits(
        forMovie movieID: Movie.ID,
        language: String? = nil
    ) async throws(TMDbError) -> ShowCredits {
        let languageCode = language ?? configuration.defaultLanguage
        let request = MovieCreditsRequest(id: movieID, language: languageCode)

        return try await apiClient.perform(request)
    }

    func reviews(
        forMovie movieID: Movie.ID,
        page: Int? = nil,
        language: String? = nil
    ) async throws(TMDbError) -> ReviewPageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = MovieReviewsRequest(id: movieID, page: page, language: languageCode)

        return try await apiClient.perform(request)
    }

    func images(forMovie movieID: Movie.ID, filter: MovieImageFilter? = nil) async throws(TMDbError)
    -> ImageCollection {
        let request = MovieImagesRequest(id: movieID, languages: filter?.languages)

        return try await apiClient.perform(request)
    }

    func videos(forMovie movieID: Movie.ID, filter: MovieVideoFilter? = nil) async throws(TMDbError)
    -> VideoCollection {
        let request = MovieVideosRequest(id: movieID, languages: filter?.languages)

        return try await apiClient.perform(request)
    }

    func recommendations(
        forMovie movieID: Movie.ID,
        page: Int? = nil,
        language: String? = nil
    ) async throws(TMDbError) -> MoviePageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = MovieRecommendationsRequest(id: movieID, page: page, language: languageCode)

        return try await apiClient.perform(request)
    }

    func similar(
        toMovie movieID: Movie.ID,
        page: Int? = nil,
        language: String? = nil
    ) async throws(TMDbError) -> MoviePageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = SimilarMoviesRequest(id: movieID, page: page, language: languageCode)

        return try await apiClient.perform(request)
    }

    func nowPlaying(
        page: Int? = nil,
        country: String? = nil,
        language: String? = nil
    ) async throws(TMDbError) -> MoviePageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let countryCode = country ?? configuration.defaultCountry
        let request = MoviesNowPlayingRequest(
            page: page, country: countryCode, language: languageCode
        )

        return try await apiClient.perform(request)
    }

    func popular(
        page: Int? = nil,
        country: String? = nil,
        language: String? = nil
    ) async throws(TMDbError) -> MoviePageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let countryCode = country ?? configuration.defaultCountry
        let request = PopularMoviesRequest(page: page, country: countryCode, language: languageCode)

        return try await apiClient.perform(request)
    }

    func topRated(
        page: Int? = nil,
        country: String? = nil,
        language: String? = nil
    ) async throws(TMDbError) -> MoviePageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let countryCode = country ?? configuration.defaultCountry
        let request = TopRatedMoviesRequest(
            page: page, country: countryCode, language: languageCode
        )

        return try await apiClient.perform(request)
    }

    func upcoming(
        page: Int? = nil,
        country: String? = nil,
        language: String? = nil
    ) async throws(TMDbError) -> MoviePageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let countryCode = country ?? configuration.defaultCountry
        let request = UpcomingMoviesRequest(
            page: page, country: countryCode, language: languageCode
        )

        return try await apiClient.perform(request)
    }

    func watchProviders(
        forMovie movieID: Movie.ID
    ) async throws(TMDbError) -> [ShowWatchProvidersByCountry] {
        let request = MovieWatchProvidersRequest(id: movieID)

        let result: ShowWatchProviderResult = try await apiClient.perform(request)

        return result.results
            .map { ShowWatchProvidersByCountry(countryCode: $0.key, watchProviders: $0.value) }
            .sorted { $0.countryCode < $1.countryCode }
    }

    func externalLinks(
        forMovie movieID: Movie.ID
    ) async throws(TMDbError) -> MovieExternalLinksCollection {
        let request = MovieExternalLinksRequest(id: movieID)

        return try await apiClient.perform(request)
    }

    func releaseDates(
        forMovie movieID: Movie.ID
    ) async throws(TMDbError) -> [MovieReleaseDatesByCountry] {
        let request = MovieReleaseDatesRequest(id: movieID)

        let result: MovieReleaseDatesResult = try await apiClient.perform(request)

        return result.results
    }

    func accountStates(
        forMovie movieID: Movie.ID,
        session: Session
    ) async throws(TMDbError) -> AccountStates {
        let request = MovieAccountStatesRequest(id: movieID, sessionID: session.sessionID)

        return try await apiClient.perform(request)
    }

    func addRating(
        _ rating: Double,
        toMovie movieID: Movie.ID,
        session: Session
    ) async throws(TMDbError) {
        try rating.validateAsRating()

        let request = AddMovieRatingRequest(rating: rating, movieID: movieID, sessionID: session.sessionID)

        _ = try await apiClient.perform(request)
    }

    func deleteRating(forMovie movieID: Movie.ID, session: Session) async throws(TMDbError) {
        let request = DeleteMovieRatingRequest(movieID: movieID, sessionID: session.sessionID)

        _ = try await apiClient.perform(request)
    }

    func alternativeTitles(
        forMovie movieID: Movie.ID,
        country: String? = nil,
        language: String? = nil
    ) async throws(TMDbError) -> AlternativeTitleCollection {
        let languageCode = language ?? configuration.defaultLanguage
        let request = MovieAlternativeTitlesRequest(id: movieID, country: country, language: languageCode)

        return try await apiClient.perform(request)
    }

    func translations(
        forMovie movieID: Movie.ID
    ) async throws(TMDbError) -> TranslationCollection<MovieTranslationData> {
        let request = MovieTranslationsRequest(id: movieID)

        return try await apiClient.perform(request)
    }

    func lists(
        forMovie movieID: Movie.ID,
        page: Int? = nil,
        language: String? = nil
    ) async throws(TMDbError) -> MediaListSummaryPageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = MovieListsRequest(id: movieID, page: page, language: languageCode)

        return try await apiClient.perform(request)
    }

    func changes(
        forMovie movieID: Movie.ID,
        startDate: Date? = nil,
        endDate: Date? = nil,
        page: Int? = nil
    ) async throws(TMDbError) -> ChangeCollection {
        let request = MovieChangesRequest(id: movieID, startDate: startDate, endDate: endDate, page: page)

        return try await apiClient.perform(request)
    }

    func latest() async throws(TMDbError) -> Movie {
        let request = LatestMovieRequest()

        return try await apiClient.perform(request)
    }

    func changes(
        startDate: Date? = nil,
        endDate: Date? = nil,
        page: Int? = nil
    ) async throws(TMDbError) -> ChangedIDCollection {
        let request = MovieChangesListRequest(startDate: startDate, endDate: endDate, page: page)

        return try await apiClient.perform(request)
    }

    func keywords(forMovie movieID: Movie.ID) async throws(TMDbError) -> KeywordCollection {
        let request = MovieKeywordsRequest(id: movieID)

        let response: MovieKeywordsResponse = try await apiClient.perform(request)

        return response.keywordCollection
    }

}
