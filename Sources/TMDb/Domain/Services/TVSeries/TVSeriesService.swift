//
//  TVSeriesService.swift
//  TMDb
//
//  Copyright © 2025 Adam Young.
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
public protocol TVSeriesService: Sendable {

    ///
    /// Returns the primary information about a TV series.
    ///
    /// [TMDb API - TV Series: Details](https://developer.themoviedb.org/reference/tv-series-details)
    ///
    /// - Parameters:
    ///    - id: The identifier of the TV series.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching TV series.
    ///
    func details(forTVSeries id: TVSeries.ID, language: String?) async throws -> TVSeries

    ///
    /// Returns the cast and crew of a TV series.
    ///
    /// [TMDb API - TV Series: Credits](https://developer.themoviedb.org/reference/tv-series-credits)
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Show credits for the matching TV series.
    ///
    func credits(forTVSeries tvSeriesID: TVSeries.ID, language: String?) async throws -> ShowCredits

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
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Show credits for the matching TV series.
    ///
    func aggregateCredits(
        forTVSeries tvSeriesID: TVSeries.ID,
        language: String?
    ) async throws -> TVSeriesAggregateCredits

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
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Reviews for the matching TV series as a pageable list.
    ///
    func reviews(
        forTVSeries tvSeriesID: TVSeries.ID,
        page: Int?,
        language: String?
    ) async throws -> ReviewPageableList

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
    func images(
        forTVSeries tvSeriesID: TVSeries.ID,
        filter: TVSeriesImageFilter?
    ) async throws -> ImageCollection

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
    func videos(
        forTVSeries tvSeriesID: TVSeries.ID,
        filter: TVSeriesVideoFilter?
    ) async throws -> VideoCollection

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
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Recommended TV series for the matching TV series as a pageable list.
    ///
    func recommendations(
        forTVSeries tvSeriesID: TVSeries.ID,
        page: Int?,
        language: String?
    ) async throws -> TVSeriesPageableList

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
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Similar TV series for the matching TV series as a pageable list.
    ///
    func similar(
        toTVSeries tvSeriesID: TVSeries.ID,
        page: Int?,
        language: String?
    ) async throws -> TVSeriesPageableList

    ///
    /// Returns a list current popular TV series.
    ///
    /// [TMDb API - TV Series Lists: Popular](https://developer.themoviedb.org/reference/tv-series-popular-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Current popular TV series as a pageable list.
    ///
    func popular(page: Int?, language: String?) async throws -> TVSeriesPageableList

    ///
    /// Returns a list of TV series that are airing today.
    ///
    /// [TMDb API - TV Series Lists: Airing Today](https://developer.themoviedb.org/reference/tv-series-airing-today-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - page: The page of results to return.
    ///    - timezone: A valid timezone to filter the day by. Defaults to "America/New_York".
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: TV series airing today as a pageable list.
    ///
    func airingToday(page: Int?, timezone: String?, language: String?) async throws
        -> TVSeriesPageableList

    ///
    /// Returns a list of TV series that are currently on the air.
    ///
    /// This returns TV series that have episodes airing within the next 7 days.
    ///
    /// [TMDb API - TV Series Lists: On The Air](https://developer.themoviedb.org/reference/tv-series-on-the-air-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - page: The page of results to return.
    ///    - timezone: A valid timezone to filter the day by. Defaults to "America/New_York".
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: TV series on the air as a pageable list.
    ///
    func onTheAir(page: Int?, timezone: String?, language: String?) async throws
        -> TVSeriesPageableList

    ///
    /// Returns a list of top rated TV series.
    ///
    /// [TMDb API - TV Series Lists: Top Rated](https://developer.themoviedb.org/reference/tv-series-top-rated-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Top rated TV series as a pageable list.
    ///
    func topRated(page: Int?, language: String?) async throws -> TVSeriesPageableList

    ///
    /// Returns watch providers for a TV series in all available countries.
    ///
    /// [TMDb API - TVSeries: Watch providers](https://developer.themoviedb.org/reference/tv-series-watch-providers)
    ///
    /// Data provided by [JustWatch](https://www.justwatch.com).
    ///
    /// - Parameter tvSeriesID: The identifier of the TV series.
    ///
    /// - Throws: TMDb data error ``TMDbError``.
    ///
    /// - Returns: Watch providers for the TV series grouped by country.
    ///
    func watchProviders(
        forTVSeries tvSeriesID: TVSeries.ID
    ) async throws -> [ShowWatchProvidersByCountry]

    ///
    /// Returns a collection of media databases and social links for a TV series.
    ///
    /// [TMDb API - TVSeries: External IDs](https://developer.themoviedb.org/reference/tv-series-external-ids)
    ///
    /// - Parameters tvSeriesID: The identifier of the TV series.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A collection of external links for the specificed TV series.
    ///
    func externalLinks(
        forTVSeries tvSeriesID: TVSeries.ID
    ) async throws -> TVSeriesExternalLinksCollection

    ///
    /// Returns the content ratings of a TV series for all available countries.
    ///
    /// [TMDb API - TVSeries: Content ratings](https://developer.themoviedb.org/reference/tv-series-content-ratings)
    ///
    /// - Parameter tvSeriesID: The identifier of the TV series.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Content ratings for the TV series grouped by country.
    ///
    func contentRatings(forTVSeries tvSeriesID: TVSeries.ID) async throws -> [ContentRating]
}

extension TVSeriesService {

    ///
    /// Returns the primary information about a TV series.
    ///
    /// [TMDb API - TV Series: Details](https://developer.themoviedb.org/reference/tv-series-details)
    ///
    /// - Parameters:
    ///    - id: The identifier of the TV series.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: The matching TV series.
    ///
    public func details(
        forTVSeries id: TVSeries.ID,
        language: String? = nil
    ) async throws -> TVSeries {
        try await details(forTVSeries: id, language: language)
    }

    ///
    /// Returns the cast and crew of a TV series.
    ///
    /// [TMDb API - TV Series: Credits](https://developer.themoviedb.org/reference/tv-series-credits)
    ///
    /// - Parameters:
    ///    - tvSeriesID: The identifier of the TV series.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Show credits for the matching TV series.
    ///
    public func credits(
        forTVSeries tvSeriesID: TVSeries.ID,
        language: String? = nil
    ) async throws -> ShowCredits {
        try await credits(forTVSeries: tvSeriesID, language: language)
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
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Show credits for the matching TV series.
    ///
    public func aggregateCredits(
        forTVSeries tvSeriesID: TVSeries.ID,
        language: String? = nil
    ) async throws -> TVSeriesAggregateCredits {
        try await aggregateCredits(forTVSeries: tvSeriesID, language: language)
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
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default language.
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
        try await reviews(forTVSeries: tvSeriesID, page: page, language: language)
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
        try await images(forTVSeries: tvSeriesID, filter: filter)
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
        try await videos(forTVSeries: tvSeriesID, filter: filter)
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
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default language.
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
        try await recommendations(forTVSeries: tvSeriesID, page: page, language: language)
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
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default language.
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
        try await similar(toTVSeries: tvSeriesID, page: page, language: language)
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
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Current popular TV series as a pageable list.
    ///
    public func popular(
        page: Int? = nil,
        language: String? = nil
    ) async throws -> TVSeriesPageableList {
        try await popular(page: page, language: language)
    }

    ///
    /// Returns a list of TV series that are airing today.
    ///
    /// [TMDb API - TV Series Lists: Airing Today](https://developer.themoviedb.org/reference/tv-series-airing-today-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - page: The page of results to return.
    ///    - timezone: A valid timezone to filter the day by. Defaults to "America/New_York".
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: TV series airing today as a pageable list.
    ///
    public func airingToday(
        page: Int? = nil,
        timezone: String? = nil,
        language: String? = nil
    ) async throws -> TVSeriesPageableList {
        try await airingToday(page: page, timezone: timezone, language: language)
    }

    ///
    /// Returns a list of TV series that are currently on the air.
    ///
    /// This returns TV series that have episodes airing within the next 7 days.
    ///
    /// [TMDb API - TV Series Lists: On The Air](https://developer.themoviedb.org/reference/tv-series-on-the-air-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - page: The page of results to return.
    ///    - timezone: A valid timezone to filter the day by. Defaults to "America/New_York".
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: TV series on the air as a pageable list.
    ///
    public func onTheAir(
        page: Int? = nil,
        timezone: String? = nil,
        language: String? = nil
    ) async throws -> TVSeriesPageableList {
        try await onTheAir(page: page, timezone: timezone, language: language)
    }

    ///
    /// Returns a list of top rated TV series.
    ///
    /// [TMDb API - TV Series Lists: Top Rated](https://developer.themoviedb.org/reference/tv-series-top-rated-list)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Top rated TV series as a pageable list.
    ///
    public func topRated(
        page: Int? = nil,
        language: String? = nil
    ) async throws -> TVSeriesPageableList {
        try await topRated(page: page, language: language)
    }

}
