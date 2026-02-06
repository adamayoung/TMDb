//
//  TrendingService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Provides an interface for finding trending movies, TV series and people from TMDb.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public protocol TrendingService: Sendable {

    ///
    /// Returns a list of the daily or weekly trending movies.
    ///
    /// The daily trending list tracks movies over the period of a day while movies have a 24 hour half life. The
    /// weekly list tracks movies over a 7 day period, with a 7 day half life.
    ///
    /// [TMDb API - Trending: Movies](https://developer.themoviedb.org/reference/trending-all)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - timeWindow: Daily or weekly time window. Defaults to daily.
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Trending movies in a time window as a pageable list.
    ///
    func movies(
        inTimeWindow timeWindow: TrendingTimeWindowFilterType,
        page: Int?,
        language: String?
    ) async throws -> MoviePageableList

    ///
    /// Returns a list of the daily or weekly trending TV series.
    ///
    /// The daily trending list tracks TV series over the period of a day while TV series have a 24 hour half life. The
    /// weekly list tracks TV series over a 7 day period, with a 7 day half life.
    ///
    /// [TMDb API - Trending: TV](https://developer.themoviedb.org/reference/trending-tv)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - timeWindow: Daily or weekly time window. Defaults to daily.
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Trending TV series in a time window as a pageable list.
    ///
    func tvSeries(
        inTimeWindow timeWindow: TrendingTimeWindowFilterType,
        page: Int?,
        language: String?
    ) async throws -> TVSeriesPageableList

    ///
    /// Returns a list of the daily or weekly trending people.
    ///
    /// The daily trending list tracks people over the period of a day while people shows have a 24 hour half life. The
    /// weekly list tracks people over a 7 day period, with a 7 day half life.
    ///
    /// [TMDb API - Trending: People](https://developer.themoviedb.org/reference/trending-people)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - timeWindow: Daily or weekly time window. Defaults to daily.
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Trending people in a time window as a pageable list.
    ///
    func people(
        inTimeWindow timeWindow: TrendingTimeWindowFilterType,
        page: Int?,
        language: String?
    ) async throws -> PersonPageableList

    ///
    /// Returns a list of the daily or weekly trending movies, TV series, and people.
    ///
    /// The daily trending list tracks items over the period of a day while items have a 24 hour
    /// half life. The weekly list tracks items over a 7 day period, with a 7 day half life.
    ///
    /// [TMDb API - Trending: All](https://developer.themoviedb.org/reference/trending-all)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - timeWindow: Daily or weekly time window. Defaults to daily.
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's
    /// configured default language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Trending movies, TV series, and people in a time window as a pageable list.
    ///
    func allTrending(
        inTimeWindow timeWindow: TrendingTimeWindowFilterType,
        page: Int?,
        language: String?
    ) async throws -> TrendingPageableList

}

public extension TrendingService {

    ///
    /// Returns a list of the daily or weekly trending movies.
    ///
    /// The daily trending list tracks movies over the period of a day while movies have a 24 hour half life. The
    /// weekly list tracks movies over a 7 day period, with a 7 day half life.
    ///
    /// [TMDb API - Trending: Movies](https://developer.themoviedb.org/reference/trending-all)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - timeWindow: Daily or weekly time window. Defaults to daily.
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Trending movies in a time window as a pageable list.
    ///
    func movies(
        inTimeWindow timeWindow: TrendingTimeWindowFilterType = .day,
        page: Int? = nil,
        language: String? = nil
    ) async throws -> MoviePageableList {
        try await movies(inTimeWindow: timeWindow, page: page, language: language)
    }

    ///
    /// Returns a list of the daily or weekly trending TV series.
    ///
    /// The daily trending list tracks TV series over the period of a day while TV series have a 24 hour half life. The
    /// weekly list tracks TV series over a 7 day period, with a 7 day half life.
    ///
    /// [TMDb API - Trending: TV](https://developer.themoviedb.org/reference/trending-tv)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - timeWindow: Daily or weekly time window. Defaults to daily.
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Trending TV series in a time window as a pageable list.
    ///
    func tvSeries(
        inTimeWindow timeWindow: TrendingTimeWindowFilterType = .day,
        page: Int? = nil,
        language: String? = nil
    ) async throws -> TVSeriesPageableList {
        try await tvSeries(inTimeWindow: timeWindow, page: page, language: language)
    }

    ///
    /// Returns a list of the daily or weekly trending people.
    ///
    /// The daily trending list tracks people over the period of a day while people shows have a 24 hour half life. The
    /// weekly list tracks people over a 7 day period, with a 7 day half life.
    ///
    /// [TMDb API - Trending: People](https://developer.themoviedb.org/reference/trending-people)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - timeWindow: Daily or weekly time window. Defaults to daily.
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Trending people in a time window as a pageable list.
    ///
    func people(
        inTimeWindow timeWindow: TrendingTimeWindowFilterType = .day,
        page: Int? = nil,
        language: String? = nil
    ) async throws -> PersonPageableList {
        try await people(inTimeWindow: timeWindow, page: page, language: language)
    }

    ///
    /// Returns a list of the daily or weekly trending movies, TV series, and people.
    ///
    /// The daily trending list tracks items over the period of a day while items have a 24 hour
    /// half life. The weekly list tracks items over a 7 day period, with a 7 day half life.
    ///
    /// [TMDb API - Trending: All](https://developer.themoviedb.org/reference/trending-all)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///    - timeWindow: Daily or weekly time window. Defaults to daily.
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's
    /// configured default language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Trending movies, TV series, and people in a time window as a pageable list.
    ///
    func allTrending(
        inTimeWindow timeWindow: TrendingTimeWindowFilterType = .day,
        page: Int? = nil,
        language: String? = nil
    ) async throws -> TrendingPageableList {
        try await allTrending(inTimeWindow: timeWindow, page: page, language: language)
    }

}
