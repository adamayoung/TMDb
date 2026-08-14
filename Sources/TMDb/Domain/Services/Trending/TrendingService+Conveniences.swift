//
//  TrendingService+Conveniences.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

// swiftlint:disable file_length

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public extension TrendingService {

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
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Trending movies, TV series, and people in a time window as a pageable list.
    ///
    /// - Note: This convenience omits `language` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `language`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func allTrending(
        inTimeWindow timeWindow: TrendingTimeWindowFilterType,
        page: Int?
    ) async throws(TMDbError) -> TrendingPageableList {
        try await allTrending(inTimeWindow: timeWindow, page: page, language: nil)
    }

    ///
    /// Returns a list of the daily or weekly trending movies, TV series, and people.
    ///
    /// The daily trending list tracks items over the period of a day while items have a 24 hour
    /// half life. The weekly list tracks items over a 7 day period, with a 7 day half life.
    ///
    /// [TMDb API - Trending: All](https://developer.themoviedb.org/reference/trending-all)
    ///
    /// - Parameters:
    ///    - timeWindow: Daily or weekly time window. Defaults to daily.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's
    /// configured default language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Trending movies, TV series, and people in a time window as a pageable list.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func allTrending(
        inTimeWindow timeWindow: TrendingTimeWindowFilterType,
        language: String?
    ) async throws(TMDbError) -> TrendingPageableList {
        try await allTrending(inTimeWindow: timeWindow, page: nil, language: language)
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
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's
    /// configured default language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Trending movies, TV series, and people in a time window as a pageable list.
    ///
    /// - Note: This convenience omits `inTimeWindow` rather than defaulting it, so that its signature stays distinct
    /// from the requirement it forwards to; it calls the requirement with `.day` for `inTimeWindow`. A defaulted
    /// overload would instead become that requirement's default implementation.
    ///
    func allTrending(
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> TrendingPageableList {
        try await allTrending(inTimeWindow: .day, page: page, language: language)
    }

    ///
    /// Returns a list of the daily or weekly trending movies, TV series, and people.
    ///
    /// The daily trending list tracks items over the period of a day while items have a 24 hour
    /// half life. The weekly list tracks items over a 7 day period, with a 7 day half life.
    ///
    /// [TMDb API - Trending: All](https://developer.themoviedb.org/reference/trending-all)
    ///
    /// - Parameter timeWindow: Daily or weekly time window. Defaults to daily.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Trending movies, TV series, and people in a time window as a pageable list.
    ///
    /// - Note: This convenience omits `page` and `language` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `page` and `language`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func allTrending(
        inTimeWindow timeWindow: TrendingTimeWindowFilterType
    ) async throws(TMDbError) -> TrendingPageableList {
        try await allTrending(inTimeWindow: timeWindow, page: nil, language: nil)
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
    /// - Parameter page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Trending movies, TV series, and people in a time window as a pageable list.
    ///
    /// - Note: This convenience omits `inTimeWindow` and `language` rather than defaulting them, so that its signature
    /// stays distinct from the requirement it forwards to; it calls the requirement with `.day` for `inTimeWindow` and
    /// `nil` for `language`. A defaulted overload would instead become that requirement's default implementation.
    ///
    func allTrending(page: Int?) async throws(TMDbError) -> TrendingPageableList {
        try await allTrending(inTimeWindow: .day, page: page, language: nil)
    }

    ///
    /// Returns a list of the daily or weekly trending movies, TV series, and people.
    ///
    /// The daily trending list tracks items over the period of a day while items have a 24 hour
    /// half life. The weekly list tracks items over a 7 day period, with a 7 day half life.
    ///
    /// [TMDb API - Trending: All](https://developer.themoviedb.org/reference/trending-all)
    ///
    /// - Parameter language: ISO 639-1 language code to display results in. Defaults to the client's
    /// configured default language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Trending movies, TV series, and people in a time window as a pageable list.
    ///
    /// - Note: This convenience omits `inTimeWindow` and `page` rather than defaulting them, so that its signature
    /// stays distinct from the requirement it forwards to; it calls the requirement with `.day` for `inTimeWindow` and
    /// `nil` for `page`. A defaulted overload would instead become that requirement's default implementation.
    ///
    func allTrending(language: String?) async throws(TMDbError) -> TrendingPageableList {
        try await allTrending(inTimeWindow: .day, page: nil, language: language)
    }

    ///
    /// Returns a list of the daily or weekly trending movies, TV series, and people.
    ///
    /// The daily trending list tracks items over the period of a day while items have a 24 hour
    /// half life. The weekly list tracks items over a 7 day period, with a 7 day half life.
    ///
    /// [TMDb API - Trending: All](https://developer.themoviedb.org/reference/trending-all)
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Trending movies, TV series, and people in a time window as a pageable list.
    ///
    /// - Note: This convenience omits `inTimeWindow`, `page` and `language` rather than defaulting them, so that its
    /// signature stays distinct from the requirement it forwards to; it calls the requirement with `.day` for
    /// `inTimeWindow` and `nil` for `page` and `language`. A defaulted overload would instead become that requirement's
    /// default implementation.
    ///
    func allTrending() async throws(TMDbError) -> TrendingPageableList {
        try await allTrending(inTimeWindow: .day, page: nil, language: nil)
    }

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
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Trending movies in a time window as a pageable list.
    ///
    /// - Note: This convenience omits `language` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `language`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func movies(
        inTimeWindow timeWindow: TrendingTimeWindowFilterType,
        page: Int?
    ) async throws(TMDbError) -> MoviePageableList {
        try await movies(inTimeWindow: timeWindow, page: page, language: nil)
    }

    ///
    /// Returns a list of the daily or weekly trending movies.
    ///
    /// The daily trending list tracks movies over the period of a day while movies have a 24 hour half life. The
    /// weekly list tracks movies over a 7 day period, with a 7 day half life.
    ///
    /// [TMDb API - Trending: Movies](https://developer.themoviedb.org/reference/trending-all)
    ///
    /// - Parameters:
    ///    - timeWindow: Daily or weekly time window. Defaults to daily.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Trending movies in a time window as a pageable list.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func movies(
        inTimeWindow timeWindow: TrendingTimeWindowFilterType,
        language: String?
    ) async throws(TMDbError) -> MoviePageableList {
        try await movies(inTimeWindow: timeWindow, page: nil, language: language)
    }

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
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Trending movies in a time window as a pageable list.
    ///
    /// - Note: This convenience omits `inTimeWindow` rather than defaulting it, so that its signature stays distinct
    /// from the requirement it forwards to; it calls the requirement with `.day` for `inTimeWindow`. A defaulted
    /// overload would instead become that requirement's default implementation.
    ///
    func movies(
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> MoviePageableList {
        try await movies(inTimeWindow: .day, page: page, language: language)
    }

    ///
    /// Returns a list of the daily or weekly trending movies.
    ///
    /// The daily trending list tracks movies over the period of a day while movies have a 24 hour half life. The
    /// weekly list tracks movies over a 7 day period, with a 7 day half life.
    ///
    /// [TMDb API - Trending: Movies](https://developer.themoviedb.org/reference/trending-all)
    ///
    /// - Parameter timeWindow: Daily or weekly time window. Defaults to daily.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Trending movies in a time window as a pageable list.
    ///
    /// - Note: This convenience omits `page` and `language` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `page` and `language`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func movies(inTimeWindow timeWindow: TrendingTimeWindowFilterType) async throws(TMDbError) -> MoviePageableList {
        try await movies(inTimeWindow: timeWindow, page: nil, language: nil)
    }

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
    /// - Parameter page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Trending movies in a time window as a pageable list.
    ///
    /// - Note: This convenience omits `inTimeWindow` and `language` rather than defaulting them, so that its signature
    /// stays distinct from the requirement it forwards to; it calls the requirement with `.day` for `inTimeWindow` and
    /// `nil` for `language`. A defaulted overload would instead become that requirement's default implementation.
    ///
    func movies(page: Int?) async throws(TMDbError) -> MoviePageableList {
        try await movies(inTimeWindow: .day, page: page, language: nil)
    }

    ///
    /// Returns a list of the daily or weekly trending movies.
    ///
    /// The daily trending list tracks movies over the period of a day while movies have a 24 hour half life. The
    /// weekly list tracks movies over a 7 day period, with a 7 day half life.
    ///
    /// [TMDb API - Trending: Movies](https://developer.themoviedb.org/reference/trending-all)
    ///
    /// - Parameter language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Trending movies in a time window as a pageable list.
    ///
    /// - Note: This convenience omits `inTimeWindow` and `page` rather than defaulting them, so that its signature
    /// stays distinct from the requirement it forwards to; it calls the requirement with `.day` for `inTimeWindow` and
    /// `nil` for `page`. A defaulted overload would instead become that requirement's default implementation.
    ///
    func movies(language: String?) async throws(TMDbError) -> MoviePageableList {
        try await movies(inTimeWindow: .day, page: nil, language: language)
    }

    ///
    /// Returns a list of the daily or weekly trending movies.
    ///
    /// The daily trending list tracks movies over the period of a day while movies have a 24 hour half life. The
    /// weekly list tracks movies over a 7 day period, with a 7 day half life.
    ///
    /// [TMDb API - Trending: Movies](https://developer.themoviedb.org/reference/trending-all)
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Trending movies in a time window as a pageable list.
    ///
    /// - Note: This convenience omits `inTimeWindow`, `page` and `language` rather than defaulting them, so that its
    /// signature stays distinct from the requirement it forwards to; it calls the requirement with `.day` for
    /// `inTimeWindow` and `nil` for `page` and `language`. A defaulted overload would instead become that requirement's
    /// default implementation.
    ///
    func movies() async throws(TMDbError) -> MoviePageableList {
        try await movies(inTimeWindow: .day, page: nil, language: nil)
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
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Trending people in a time window as a pageable list.
    ///
    /// - Note: This convenience omits `language` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `language`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func people(
        inTimeWindow timeWindow: TrendingTimeWindowFilterType,
        page: Int?
    ) async throws(TMDbError) -> PersonPageableList {
        try await people(inTimeWindow: timeWindow, page: page, language: nil)
    }

    ///
    /// Returns a list of the daily or weekly trending people.
    ///
    /// The daily trending list tracks people over the period of a day while people shows have a 24 hour half life. The
    /// weekly list tracks people over a 7 day period, with a 7 day half life.
    ///
    /// [TMDb API - Trending: People](https://developer.themoviedb.org/reference/trending-people)
    ///
    /// - Parameters:
    ///    - timeWindow: Daily or weekly time window. Defaults to daily.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Trending people in a time window as a pageable list.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func people(
        inTimeWindow timeWindow: TrendingTimeWindowFilterType,
        language: String?
    ) async throws(TMDbError) -> PersonPageableList {
        try await people(inTimeWindow: timeWindow, page: nil, language: language)
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
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Trending people in a time window as a pageable list.
    ///
    /// - Note: This convenience omits `inTimeWindow` rather than defaulting it, so that its signature stays distinct
    /// from the requirement it forwards to; it calls the requirement with `.day` for `inTimeWindow`. A defaulted
    /// overload would instead become that requirement's default implementation.
    ///
    func people(
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> PersonPageableList {
        try await people(inTimeWindow: .day, page: page, language: language)
    }

    ///
    /// Returns a list of the daily or weekly trending people.
    ///
    /// The daily trending list tracks people over the period of a day while people shows have a 24 hour half life. The
    /// weekly list tracks people over a 7 day period, with a 7 day half life.
    ///
    /// [TMDb API - Trending: People](https://developer.themoviedb.org/reference/trending-people)
    ///
    /// - Parameter timeWindow: Daily or weekly time window. Defaults to daily.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Trending people in a time window as a pageable list.
    ///
    /// - Note: This convenience omits `page` and `language` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `page` and `language`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func people(inTimeWindow timeWindow: TrendingTimeWindowFilterType) async throws(TMDbError) -> PersonPageableList {
        try await people(inTimeWindow: timeWindow, page: nil, language: nil)
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
    /// - Parameter page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Trending people in a time window as a pageable list.
    ///
    /// - Note: This convenience omits `inTimeWindow` and `language` rather than defaulting them, so that its signature
    /// stays distinct from the requirement it forwards to; it calls the requirement with `.day` for `inTimeWindow` and
    /// `nil` for `language`. A defaulted overload would instead become that requirement's default implementation.
    ///
    func people(page: Int?) async throws(TMDbError) -> PersonPageableList {
        try await people(inTimeWindow: .day, page: page, language: nil)
    }

    ///
    /// Returns a list of the daily or weekly trending people.
    ///
    /// The daily trending list tracks people over the period of a day while people shows have a 24 hour half life. The
    /// weekly list tracks people over a 7 day period, with a 7 day half life.
    ///
    /// [TMDb API - Trending: People](https://developer.themoviedb.org/reference/trending-people)
    ///
    /// - Parameter language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Trending people in a time window as a pageable list.
    ///
    /// - Note: This convenience omits `inTimeWindow` and `page` rather than defaulting them, so that its signature
    /// stays distinct from the requirement it forwards to; it calls the requirement with `.day` for `inTimeWindow` and
    /// `nil` for `page`. A defaulted overload would instead become that requirement's default implementation.
    ///
    func people(language: String?) async throws(TMDbError) -> PersonPageableList {
        try await people(inTimeWindow: .day, page: nil, language: language)
    }

    ///
    /// Returns a list of the daily or weekly trending people.
    ///
    /// The daily trending list tracks people over the period of a day while people shows have a 24 hour half life. The
    /// weekly list tracks people over a 7 day period, with a 7 day half life.
    ///
    /// [TMDb API - Trending: People](https://developer.themoviedb.org/reference/trending-people)
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Trending people in a time window as a pageable list.
    ///
    /// - Note: This convenience omits `inTimeWindow`, `page` and `language` rather than defaulting them, so that its
    /// signature stays distinct from the requirement it forwards to; it calls the requirement with `.day` for
    /// `inTimeWindow` and `nil` for `page` and `language`. A defaulted overload would instead become that requirement's
    /// default implementation.
    ///
    func people() async throws(TMDbError) -> PersonPageableList {
        try await people(inTimeWindow: .day, page: nil, language: nil)
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
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Trending TV series in a time window as a pageable list.
    ///
    /// - Note: This convenience omits `language` rather than defaulting it, so that its signature stays distinct from
    /// the requirement it forwards to; it calls the requirement with `nil` for `language`. A defaulted overload would
    /// instead become that requirement's default implementation.
    ///
    func tvSeries(
        inTimeWindow timeWindow: TrendingTimeWindowFilterType,
        page: Int?
    ) async throws(TMDbError) -> TVSeriesPageableList {
        try await tvSeries(inTimeWindow: timeWindow, page: page, language: nil)
    }

    ///
    /// Returns a list of the daily or weekly trending TV series.
    ///
    /// The daily trending list tracks TV series over the period of a day while TV series have a 24 hour half life. The
    /// weekly list tracks TV series over a 7 day period, with a 7 day half life.
    ///
    /// [TMDb API - Trending: TV](https://developer.themoviedb.org/reference/trending-tv)
    ///
    /// - Parameters:
    ///    - timeWindow: Daily or weekly time window. Defaults to daily.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Trending TV series in a time window as a pageable list.
    ///
    /// - Note: This convenience omits `page` rather than defaulting it, so that its signature stays distinct from the
    /// requirement it forwards to; it calls the requirement with `nil` for `page`. A defaulted overload would instead
    /// become that requirement's default implementation.
    ///
    func tvSeries(
        inTimeWindow timeWindow: TrendingTimeWindowFilterType,
        language: String?
    ) async throws(TMDbError) -> TVSeriesPageableList {
        try await tvSeries(inTimeWindow: timeWindow, page: nil, language: language)
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
    ///    - page: The page of results to return.
    ///    - language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Trending TV series in a time window as a pageable list.
    ///
    /// - Note: This convenience omits `inTimeWindow` rather than defaulting it, so that its signature stays distinct
    /// from the requirement it forwards to; it calls the requirement with `.day` for `inTimeWindow`. A defaulted
    /// overload would instead become that requirement's default implementation.
    ///
    func tvSeries(
        page: Int?,
        language: String?
    ) async throws(TMDbError) -> TVSeriesPageableList {
        try await tvSeries(inTimeWindow: .day, page: page, language: language)
    }

    ///
    /// Returns a list of the daily or weekly trending TV series.
    ///
    /// The daily trending list tracks TV series over the period of a day while TV series have a 24 hour half life. The
    /// weekly list tracks TV series over a 7 day period, with a 7 day half life.
    ///
    /// [TMDb API - Trending: TV](https://developer.themoviedb.org/reference/trending-tv)
    ///
    /// - Parameter timeWindow: Daily or weekly time window. Defaults to daily.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Trending TV series in a time window as a pageable list.
    ///
    /// - Note: This convenience omits `page` and `language` rather than defaulting them, so that its signature stays
    /// distinct from the requirement it forwards to; it calls the requirement with `nil` for `page` and `language`. A
    /// defaulted overload would instead become that requirement's default implementation.
    ///
    func tvSeries(
        inTimeWindow timeWindow: TrendingTimeWindowFilterType
    ) async throws(TMDbError) -> TVSeriesPageableList {
        try await tvSeries(inTimeWindow: timeWindow, page: nil, language: nil)
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
    /// - Parameter page: The page of results to return.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Trending TV series in a time window as a pageable list.
    ///
    /// - Note: This convenience omits `inTimeWindow` and `language` rather than defaulting them, so that its signature
    /// stays distinct from the requirement it forwards to; it calls the requirement with `.day` for `inTimeWindow` and
    /// `nil` for `language`. A defaulted overload would instead become that requirement's default implementation.
    ///
    func tvSeries(page: Int?) async throws(TMDbError) -> TVSeriesPageableList {
        try await tvSeries(inTimeWindow: .day, page: page, language: nil)
    }

    ///
    /// Returns a list of the daily or weekly trending TV series.
    ///
    /// The daily trending list tracks TV series over the period of a day while TV series have a 24 hour half life. The
    /// weekly list tracks TV series over a 7 day period, with a 7 day half life.
    ///
    /// [TMDb API - Trending: TV](https://developer.themoviedb.org/reference/trending-tv)
    ///
    /// - Parameter language: ISO 639-1 language code to display results in. Defaults to the client's configured default
    /// language.
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Trending TV series in a time window as a pageable list.
    ///
    /// - Note: This convenience omits `inTimeWindow` and `page` rather than defaulting them, so that its signature
    /// stays distinct from the requirement it forwards to; it calls the requirement with `.day` for `inTimeWindow` and
    /// `nil` for `page`. A defaulted overload would instead become that requirement's default implementation.
    ///
    func tvSeries(language: String?) async throws(TMDbError) -> TVSeriesPageableList {
        try await tvSeries(inTimeWindow: .day, page: nil, language: language)
    }

    ///
    /// Returns a list of the daily or weekly trending TV series.
    ///
    /// The daily trending list tracks TV series over the period of a day while TV series have a 24 hour half life. The
    /// weekly list tracks TV series over a 7 day period, with a 7 day half life.
    ///
    /// [TMDb API - Trending: TV](https://developer.themoviedb.org/reference/trending-tv)
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: Trending TV series in a time window as a pageable list.
    ///
    /// - Note: This convenience omits `inTimeWindow`, `page` and `language` rather than defaulting them, so that its
    /// signature stays distinct from the requirement it forwards to; it calls the requirement with `.day` for
    /// `inTimeWindow` and `nil` for `page` and `language`. A defaulted overload would instead become that requirement's
    /// default implementation.
    ///
    func tvSeries() async throws(TMDbError) -> TVSeriesPageableList {
        try await tvSeries(inTimeWindow: .day, page: nil, language: nil)
    }

}
