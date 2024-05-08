//
//  TVSeriesService.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

///
/// Provides an interface for obtaining TV series from TMDb.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public final class TVSeriesService {

    private let apiClient: any APIClient
    private let localeProvider: any LocaleProviding

    ///
    /// Creates a TV series service object.
    ///
    /// - Parameter configuration: A TMDb configuration object.
    ///
    public convenience init(configuration: TMDbConfiguration) {
        self.init(
            apiClient: TMDbFactory.apiClient(configuration: configuration),
            localeProvider: TMDbFactory.localeProvider()
        )
    }

    init(apiClient: some APIClient, localeProvider: some LocaleProviding) {
        self.apiClient = apiClient
        self.localeProvider = localeProvider
    }

    ///
    /// Returns the primary information about a TV series.
    ///
    /// [TMDb API - TV Series: Details](https://developer.themoviedb.org/reference/tv-series-details)
    ///
    /// - Parameters:
    ///    - id: The identifier of the TV series.
    ///    - language: ISO 639-1 language code to display results in. Defaults to `en`.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching TV series.
    ///
    public func details(forTVSeries id: TVSeries.ID, language: String? = nil) async throws -> TVSeries {
        let request = TVSeriesRequest(id: id, language: language)

        let tvSeries: TVSeries
        do {
            tvSeries = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return tvSeries
    }

    ///
    /// Returns the cast and crew of a TV series.
    ///
    /// [TMDb API - TV Series: Credits](https://developer.themoviedb.org/reference/tv-series-credits)
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - language: ISO 639-1 language code to display results in. Defaults to `en`.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Show credits for the matching TV series.
    ///
    public func credits(forTVSeries tvSeriesID: TVSeries.ID, language: String? = nil) async throws -> ShowCredits {
        let request = TVSeriesCreditsRequest(id: tvSeriesID, language: language)

        let credits: ShowCredits
        do {
            credits = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return credits
    }

    ///
    /// Returns the aggregate cast and crew of a TV series.
    ///
    /// This call differs from the main credits call in that it does not return
    /// the newest season. Instead, it is a view of all the entire cast & crew
    /// for all episodes belonging to a TV series.
    ///
    /// [TMDb API - TV Series: Aggregate Credits](https://developer.themoviedb.org/reference/tv-series-aggregate-credits)
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - language: ISO 639-1 language code to display results in. Defaults to `en`.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Show credits for the matching TV series.
    ///
    public func aggregateCredits(
        forTVSeries tvSeriesID: TVSeries.ID,
        language: String? = nil
    ) async throws -> TVSeriesAggregateCredits {
        let request = TVSeriesAggregateCreditsRequest(id: tvSeriesID, language: language)

        let credits: TVSeriesAggregateCredits
        do {
            credits = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return credits
    }

    ///
    /// Returns the user reviews for a TV series.
    ///
    /// [TMDb API - TV Series: Reviews](https://developer.themoviedb.org/reference/tv-series-reviews)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to `en`.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Reviews for the matching TV series as a pageable list.
    ///
    public func reviews(
        forTVSeries tvSeriesID: TVSeries.ID,
        page: Int? = nil,
        language: String? = nil
    ) async throws -> ReviewPageableList {
        let request = TVSeriesReviewsRequest(id: tvSeriesID, page: page, language: language)

        let reviewList: ReviewPageableList
        do {
            reviewList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return reviewList
    }

    ///
    /// Returns the images that belong to a TV series.
    ///
    /// [TMDb API - TV Series: Images](https://developer.themoviedb.org/reference/tv-series-images)
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - filter: Image filter.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of images for the matching TV series.
    ///
    public func images(
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

    ///
    /// Returns the videos that belong to a TV series.
    ///
    /// [TMDb API - TV Series: Videos](https://developer.themoviedb.org/reference/tv-series-videos)
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - filter: Video filter.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of videos for the matching TV series.
    ///
    public func videos(
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

    ///
    /// Returns a list of recommended TV series for a TV series.
    ///
    /// [TMDb API - TV Series: Recommendations](https://developer.themoviedb.org/reference/tv-series-recommendations)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to `en`.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Recommended TV series for the matching TV series as a pageable list.
    ///
    public func recommendations(
        forTVSeries tvSeriesID: TVSeries.ID,
        page: Int? = nil,
        language: String? = nil
    ) async throws -> TVSeriesPageableList {
        let request = TVSeriesRecommendationsRequest(id: tvSeriesID, page: page, language: language)

        let tvSeriesList: TVSeriesPageableList
        do {
            tvSeriesList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return tvSeriesList
    }

    ///
    /// Returns a list of similar TV series for a TV series.
    ///
    /// This is not the same as the *Recommendations*.
    ///
    /// [TMDb API - TV Series: Similar](https://developer.themoviedb.org/reference/tv-series-similar)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series for get similar TV series for.
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to `en`.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Similar TV series for the matching TV series as a pageable list.
    ///
    public func similar(
        toTVSeries tvSeriesID: TVSeries.ID,
        page: Int? = nil,
        language: String? = nil
    ) async throws -> TVSeriesPageableList {
        let request = SimilarTVSeriesRequest(id: tvSeriesID, page: page, language: language)

        let tvSeriesList: TVSeriesPageableList
        do {
            tvSeriesList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return tvSeriesList
    }

    ///
    /// Returns a list current popular TV series.
    ///
    /// [TMDb API - TV Series Lists: Popular](https://developer.themoviedb.org/reference/tv-series-popular-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to `en`.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Current popular TV series as a pageable list.
    ///
    public func popular(page: Int? = nil, language: String? = nil) async throws -> TVSeriesPageableList {
        let request = PopularTVSeriesRequest(page: page, language: language)

        let tvSeriesList: TVSeriesPageableList
        do {
            tvSeriesList = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return tvSeriesList
    }

    ///
    /// Returns watch providers for a TV series
    ///
    /// [TMDb API - TVSeries: Watch providers](https://developer.themoviedb.org/reference/tv-series-watch-providers)
    ///
    /// Data provided by [JustWatch](https://www.justwatch.com).
    ///
    /// - Parameters:
    ///    - id: The identifier of the TV series.
    ///    - country: ISO-3166-1 country code to fetch results for. Defaults to `US`.
    ///
    /// - Throws: TMDb data error ``TMDbError``.
    ///
    /// - Returns: Watch providers for TV series in current region.
    ///
    public func watchProviders(
        forTVSeries tvSeriesID: TVSeries.ID,
        country: String = "US"
    ) async throws -> ShowWatchProvider? {
        let request = TVSeriesWatchProvidersRequest(id: tvSeriesID)

        let result: ShowWatchProviderResult
        do {
            result = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return result.results[country]
    }

    ///
    /// Returns a collection of media databases and social links for a TV series.
    ///
    /// [TMDb API - TVSeries: External IDs](https://developer.themoviedb.org/reference/tv-series-external-ids)
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series.
    ///
    /// - Returns: A collection of external links for the specificed TV series.
    ///
    public func externalLinks(forTVSeries tvSeriesID: TVSeries.ID) async throws -> TVSeriesExternalLinksCollection {
        let request = TVSeriesExternalLinksRequest(id: tvSeriesID)

        let linksCollection: TVSeriesExternalLinksCollection
        do {
            linksCollection = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return linksCollection
    }

}
