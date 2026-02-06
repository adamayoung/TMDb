//
//  TMDbMovieService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

// swiftlint:disable file_length type_body_length

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
final class TMDbMovieService: MovieService {

    private let apiClient: any APIClient
    private let configuration: TMDbConfiguration

    init(apiClient: some APIClient, configuration: TMDbConfiguration = .default) {
        self.apiClient = apiClient
        self.configuration = configuration
    }

    func details(forMovie id: Movie.ID, language: String? = nil) async throws -> Movie {
        let languageCode = language ?? configuration.defaultLanguage
        let request = MovieRequest(id: id, language: languageCode)

        let movie: Movie
        do {
            movie = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return movie
    }

    func credits(forMovie movieID: Movie.ID, language: String? = nil) async throws -> ShowCredits {
        let languageCode = language ?? configuration.defaultLanguage
        let request = MovieCreditsRequest(id: movieID, language: languageCode)

        let credits: ShowCredits
        do {
            credits = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return credits
    }

    func reviews(
        forMovie movieID: Movie.ID,
        page: Int? = nil,
        language: String? = nil
    ) async throws -> ReviewPageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = MovieReviewsRequest(id: movieID, page: page, language: languageCode)

        let reviewList: ReviewPageableList
        do {
            reviewList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return reviewList
    }

    func images(forMovie movieID: Movie.ID, filter: MovieImageFilter? = nil) async throws
    -> ImageCollection {
        let request = MovieImagesRequest(id: movieID, languages: filter?.languages)

        let imageCollection: ImageCollection
        do {
            imageCollection = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return imageCollection
    }

    func videos(forMovie movieID: Movie.ID, filter: MovieVideoFilter? = nil) async throws
    -> VideoCollection {
        let request = MovieVideosRequest(id: movieID, languages: filter?.languages)

        let videoCollection: VideoCollection
        do {
            videoCollection = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return videoCollection
    }

    func recommendations(
        forMovie movieID: Movie.ID,
        page: Int? = nil,
        language: String? = nil
    ) async throws -> MoviePageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = MovieRecommendationsRequest(id: movieID, page: page, language: languageCode)

        let movieList: MoviePageableList
        do {
            movieList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return movieList
    }

    func similar(
        toMovie movieID: Movie.ID,
        page: Int? = nil,
        language: String? = nil
    ) async throws -> MoviePageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = SimilarMoviesRequest(id: movieID, page: page, language: languageCode)

        let movieList: MoviePageableList
        do {
            movieList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return movieList
    }

    func nowPlaying(
        page: Int? = nil,
        country: String? = nil,
        language: String? = nil
    ) async throws -> MoviePageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let countryCode = country ?? configuration.defaultCountry
        let request = MoviesNowPlayingRequest(
            page: page, country: countryCode, language: languageCode
        )

        let movieList: MoviePageableList
        do {
            movieList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return movieList
    }

    func popular(
        page: Int? = nil,
        country: String? = nil,
        language: String? = nil
    ) async throws -> MoviePageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let countryCode = country ?? configuration.defaultCountry
        let request = PopularMoviesRequest(page: page, country: countryCode, language: languageCode)

        let movieList: MoviePageableList
        do {
            movieList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return movieList
    }

    func topRated(
        page: Int? = nil,
        country: String? = nil,
        language: String? = nil
    ) async throws -> MoviePageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let countryCode = country ?? configuration.defaultCountry
        let request = TopRatedMoviesRequest(
            page: page, country: countryCode, language: languageCode
        )

        let movieList: MoviePageableList
        do {
            movieList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return movieList
    }

    func upcoming(
        page: Int? = nil,
        country: String? = nil,
        language: String? = nil
    ) async throws -> MoviePageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let countryCode = country ?? configuration.defaultCountry
        let request = UpcomingMoviesRequest(
            page: page, country: countryCode, language: languageCode
        )

        let movieList: MoviePageableList
        do {
            movieList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return movieList
    }

    func watchProviders(forMovie movieID: Movie.ID) async throws -> [ShowWatchProvidersByCountry] {
        let request = MovieWatchProvidersRequest(id: movieID)

        let result: ShowWatchProviderResult
        do {
            result = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return result.results
            .map { ShowWatchProvidersByCountry(countryCode: $0.key, watchProviders: $0.value) }
            .sorted { $0.countryCode < $1.countryCode }
    }

    func externalLinks(forMovie movieID: Movie.ID) async throws -> MovieExternalLinksCollection {
        let request = MovieExternalLinksRequest(id: movieID)

        let linksCollection: MovieExternalLinksCollection
        do {
            linksCollection = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return linksCollection
    }

    func releaseDates(forMovie movieID: Movie.ID) async throws -> [MovieReleaseDatesByCountry] {
        let request = MovieReleaseDatesRequest(id: movieID)

        let result: MovieReleaseDatesResult
        do {
            result = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return result.results
    }

    func accountStates(forMovie movieID: Movie.ID, session: Session) async throws -> AccountStates {
        let request = MovieAccountStatesRequest(id: movieID, sessionID: session.sessionID)

        let accountStates: AccountStates
        do {
            accountStates = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return accountStates
    }

    func addRating(_ rating: Double, toMovie movieID: Movie.ID, session: Session) async throws {
        let request = AddMovieRatingRequest(rating: rating, movieID: movieID, sessionID: session.sessionID)

        do {
            _ = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }
    }

    func deleteRating(forMovie movieID: Movie.ID, session: Session) async throws {
        let request = DeleteMovieRatingRequest(movieID: movieID, sessionID: session.sessionID)

        do {
            _ = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }
    }

    func alternativeTitles(
        forMovie movieID: Movie.ID,
        country: String? = nil,
        language: String? = nil
    ) async throws -> AlternativeTitleCollection {
        let languageCode = language ?? configuration.defaultLanguage
        let request = MovieAlternativeTitlesRequest(id: movieID, country: country, language: languageCode)

        let alternativeTitleCollection: AlternativeTitleCollection
        do {
            alternativeTitleCollection = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return alternativeTitleCollection
    }

    func translations(forMovie movieID: Movie.ID) async throws -> TranslationCollection<MovieTranslationData> {
        let request = MovieTranslationsRequest(id: movieID)

        let translationCollection: TranslationCollection<MovieTranslationData>
        do {
            translationCollection = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return translationCollection
    }

    func lists(
        forMovie movieID: Movie.ID,
        page: Int? = nil,
        language: String? = nil
    ) async throws -> MediaListSummaryPageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = MovieListsRequest(id: movieID, page: page, language: languageCode)

        let mediaList: MediaListSummaryPageableList
        do {
            mediaList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return mediaList
    }

    func changes(
        forMovie movieID: Movie.ID,
        startDate: Date? = nil,
        endDate: Date? = nil,
        page: Int? = nil
    ) async throws -> ChangeCollection {
        let request = MovieChangesRequest(id: movieID, startDate: startDate, endDate: endDate, page: page)

        let changeCollection: ChangeCollection
        do {
            changeCollection = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return changeCollection
    }

    func latest() async throws -> Movie {
        let request = LatestMovieRequest()

        let movie: Movie
        do {
            movie = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return movie
    }

    func changes(
        startDate: Date? = nil,
        endDate: Date? = nil,
        page: Int? = nil
    ) async throws -> ChangedIDCollection {
        let request = MovieChangesListRequest(startDate: startDate, endDate: endDate, page: page)

        let changedIDCollection: ChangedIDCollection
        do {
            changedIDCollection = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return changedIDCollection
    }

    func keywords(forMovie movieID: Movie.ID) async throws -> KeywordCollection {
        let request = MovieKeywordsRequest(id: movieID)

        let response: MovieKeywordsResponse
        do {
            response = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return response.keywordCollection
    }

}

// swiftlint:enable file_length type_body_length
