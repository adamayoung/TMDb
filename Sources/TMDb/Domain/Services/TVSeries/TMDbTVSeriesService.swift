//
//  TMDbTVSeriesService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
final class TMDbTVSeriesService: TVSeriesService {

    private let apiClient: any APIClient
    private let configuration: TMDbConfiguration

    init(apiClient: some APIClient, configuration: TMDbConfiguration = .default) {
        self.apiClient = apiClient
        self.configuration = configuration
    }

    func details(forTVSeries id: TVSeries.ID, language: String? = nil) async throws -> TVSeries {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TVSeriesRequest(id: id, language: languageCode)

        let tvSeries: TVSeries
        do {
            tvSeries = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return tvSeries
    }

    func credits(forTVSeries tvSeriesID: TVSeries.ID, language: String? = nil) async throws
    -> ShowCredits {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TVSeriesCreditsRequest(id: tvSeriesID, language: languageCode)

        let credits: ShowCredits
        do {
            credits = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return credits
    }

    func aggregateCredits(
        forTVSeries tvSeriesID: TVSeries.ID,
        language: String? = nil
    ) async throws -> TVSeriesAggregateCredits {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TVSeriesAggregateCreditsRequest(id: tvSeriesID, language: languageCode)

        let credits: TVSeriesAggregateCredits
        do {
            credits = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return credits
    }

    func reviews(
        forTVSeries tvSeriesID: TVSeries.ID,
        page: Int? = nil,
        language: String? = nil
    ) async throws -> ReviewPageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TVSeriesReviewsRequest(id: tvSeriesID, page: page, language: languageCode)

        let reviewList: ReviewPageableList
        do {
            reviewList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return reviewList
    }

    func images(
        forTVSeries tvSeriesID: TVSeries.ID,
        filter: TVSeriesImageFilter? = nil
    ) async throws -> ImageCollection {
        let request = TVSeriesImagesRequest(id: tvSeriesID, languages: filter?.languages)

        let imageCollection: ImageCollection
        do {
            imageCollection = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return imageCollection
    }

    func videos(
        forTVSeries tvSeriesID: TVSeries.ID,
        filter: TVSeriesVideoFilter? = nil
    ) async throws -> VideoCollection {
        let request = TVSeriesVideosRequest(id: tvSeriesID, languages: filter?.languages)

        let videoCollection: VideoCollection
        do {
            videoCollection = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return videoCollection
    }

    func recommendations(
        forTVSeries tvSeriesID: TVSeries.ID,
        page: Int? = nil,
        language: String? = nil
    ) async throws -> TVSeriesPageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TVSeriesRecommendationsRequest(
            id: tvSeriesID, page: page, language: languageCode
        )

        let tvSeriesList: TVSeriesPageableList
        do {
            tvSeriesList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return tvSeriesList
    }

    func similar(
        toTVSeries tvSeriesID: TVSeries.ID,
        page: Int? = nil,
        language: String? = nil
    ) async throws -> TVSeriesPageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = SimilarTVSeriesRequest(id: tvSeriesID, page: page, language: languageCode)

        let tvSeriesList: TVSeriesPageableList
        do {
            tvSeriesList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return tvSeriesList
    }

    func popular(page: Int? = nil, language: String? = nil) async throws -> TVSeriesPageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = PopularTVSeriesRequest(page: page, language: languageCode)

        let tvSeriesList: TVSeriesPageableList
        do {
            tvSeriesList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return tvSeriesList
    }

    func airingToday(
        page: Int? = nil,
        timezone: String? = nil,
        language: String? = nil
    ) async throws -> TVSeriesPageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TVSeriesAiringTodayRequest(
            page: page,
            timezone: timezone,
            language: languageCode
        )

        let tvSeriesList: TVSeriesPageableList
        do {
            tvSeriesList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return tvSeriesList
    }

    func onTheAir(
        page: Int? = nil,
        timezone: String? = nil,
        language: String? = nil
    ) async throws -> TVSeriesPageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TVSeriesOnTheAirRequest(
            page: page,
            timezone: timezone,
            language: languageCode
        )

        let tvSeriesList: TVSeriesPageableList
        do {
            tvSeriesList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return tvSeriesList
    }

    func topRated(page: Int? = nil, language: String? = nil) async throws -> TVSeriesPageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TopRatedTVSeriesRequest(page: page, language: languageCode)

        let tvSeriesList: TVSeriesPageableList
        do {
            tvSeriesList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return tvSeriesList
    }

    func watchProviders(
        forTVSeries tvSeriesID: TVSeries.ID
    ) async throws -> [ShowWatchProvidersByCountry] {
        let request = TVSeriesWatchProvidersRequest(id: tvSeriesID)

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

    func contentRatings(forTVSeries tvSeriesID: TVSeries.ID) async throws -> [ContentRating] {
        let request = ContentRatingRequest(id: tvSeriesID)

        let result: ContentRatingResult
        do {
            result = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return result.results
    }

    func externalLinks(forTVSeries tvSeriesID: TVSeries.ID) async throws
    -> TVSeriesExternalLinksCollection {
        let request = TVSeriesExternalLinksRequest(id: tvSeriesID)

        let linksCollection: TVSeriesExternalLinksCollection
        do {
            linksCollection = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return linksCollection
    }

    func accountStates(forTVSeries tvSeriesID: TVSeries.ID, session: Session) async throws
    -> AccountStates {
        let request = TVSeriesAccountStatesRequest(id: tvSeriesID, sessionID: session.sessionID)

        let accountStates: AccountStates
        do {
            accountStates = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return accountStates
    }

    func addRating(
        _ rating: Double,
        toTVSeries tvSeriesID: TVSeries.ID,
        session: Session
    ) async throws {
        guard (0.5...10.0).contains(rating), rating.truncatingRemainder(dividingBy: 0.5) == 0 else {
            throw TMDbError.invalidRating
        }

        let request = TVSeriesAddRatingRequest(
            rating: rating,
            tvSeriesID: tvSeriesID,
            sessionID: session.sessionID
        )

        do {
            _ = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }
    }

    func deleteRating(forTVSeries tvSeriesID: TVSeries.ID, session: Session) async throws {
        let request = TVSeriesDeleteRatingRequest(tvSeriesID: tvSeriesID, sessionID: session.sessionID)

        do {
            _ = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }
    }

    func keywords(forTVSeries tvSeriesID: TVSeries.ID) async throws -> KeywordCollection {
        let request = TVSeriesKeywordsRequest(id: tvSeriesID)

        let keywordCollection: KeywordCollection
        do {
            keywordCollection = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return keywordCollection
    }

    func alternativeTitles(forTVSeries tvSeriesID: TVSeries.ID) async throws
    -> AlternativeTitleCollection {
        let request = TVSeriesAlternativeTitlesRequest(id: tvSeriesID)

        let alternativeTitleCollection: AlternativeTitleCollection
        do {
            alternativeTitleCollection = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return alternativeTitleCollection
    }

    func translations(forTVSeries tvSeriesID: TVSeries.ID) async throws
    -> TranslationCollection<TVSeriesTranslationData> {
        let request = TVSeriesTranslationsRequest(id: tvSeriesID)

        let translationCollection: TranslationCollection<TVSeriesTranslationData>
        do {
            translationCollection = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return translationCollection
    }

    func lists(
        forTVSeries tvSeriesID: TVSeries.ID,
        page: Int? = nil,
        language: String? = nil
    ) async throws -> MediaPageableList {
        let languageCode = language ?? configuration.defaultLanguage
        let request = TVSeriesListsRequest(id: tvSeriesID, page: page, language: languageCode)

        let mediaList: MediaPageableList
        do {
            mediaList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return mediaList
    }

    func changes(
        forTVSeries tvSeriesID: TVSeries.ID,
        startDate: Date? = nil,
        endDate: Date? = nil,
        page: Int? = nil
    ) async throws -> ChangeCollection {
        let request = TVSeriesChangesRequest(
            id: tvSeriesID,
            startDate: startDate,
            endDate: endDate,
            page: page
        )

        let changeCollection: ChangeCollection
        do {
            changeCollection = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return changeCollection
    }

    func latest() async throws -> TVSeries {
        let request = LatestTVSeriesRequest()

        let tvSeries: TVSeries
        do {
            tvSeries = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return tvSeries
    }

    func changes(
        startDate: Date? = nil,
        endDate: Date? = nil,
        page: Int? = nil
    ) async throws -> ChangedIDCollection {
        let request = TVSeriesChangesListRequest(
            startDate: startDate,
            endDate: endDate,
            page: page
        )

        let changedIDCollection: ChangedIDCollection
        do {
            changedIDCollection = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return changedIDCollection
    }

}
