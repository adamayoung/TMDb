import Foundation

#if canImport(Combine)
import Combine
#endif

/// Fetch the daily or weekly trending movies, TV shows or people. The daily trending list tracks items over the period of a day while items have a 24 hour half life.
/// The weekly list tracks items over a 7 day period, with a 7 day half life.
public protocol TrendingService {

    /// Fetches a list of the daily or weekly trending movies.
    ///
    /// The daily trending list tracks movies over the period of a day while movies have a 24 hour half life. The
    /// weekly list tracks movies over a 7 day period, with a 7 day half life.
    ///
    /// [TMDb API - Trending](https://developers.themoviedb.org/3/trending/get-trending)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - timeWindow: Daily or weekly time window. Defaults to daily.
    ///     - page: The page of results to return.
    ///     - completion: Completion handler.
    ///     - result: Trending movies in a time window as a pageable list.
    func fetchMovies(inTimeWindow timeWindow: TrendingTimeWindowFilterType, page: Int?,
                     completion: @escaping (_ result: Result<MoviePageableList, TMDbError>) -> Void)

    /// Fetches a list of the daily or weekly trending TV shows.
    ///
    /// The daily trending list tracks TV shows over the period of a day while TV shows have a 24 hour half life. The
    /// weekly list tracks TV shows over a 7 day period, with a 7 day half life.
    ///
    /// [TMDb API - Trending](https://developers.themoviedb.org/3/trending/get-trending)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - timeWindow: Daily or weekly time window. Defaults to daily.
    ///     - page: The page of results to return.
    ///     - completion: Completion handler.
    ///     - result: Trending TV shows in a time window as a pageable list.
    func fetchTVShows(inTimeWindow timeWindow: TrendingTimeWindowFilterType, page: Int?,
                      completion: @escaping (_ result: Result<TVShowPageableList, TMDbError>) -> Void)

    /// Fetches a list of the daily or weekly trending people.
    ///
    /// The daily trending list tracks people over the period of a day while people shows have a 24 hour half life. The
    /// weekly list tracks people over a 7 day period, with a 7 day half life.
    ///
    /// [TMDb API - Trending](https://developers.themoviedb.org/3/trending/get-trending)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - timeWindow: Daily or weekly time window. Defaults to daily.
    ///     - page: The page of results to return.
    ///     - completion: Completion handler.
    ///     - result: Trending people in a time window as a pageable list.
    func fetchPeople(inTimeWindow timeWindow: TrendingTimeWindowFilterType, page: Int?,
                     completion: @escaping (_ result: Result<PersonPageableList, TMDbError>) -> Void)

    #if canImport(Combine)
    /// Publishes a list of the daily or weekly trending movies.
    ///
    /// The daily trending list tracks movies over the period of a day while movies have a 24 hour half life. The
    /// weekly list tracks movies over a 7 day period, with a 7 day half life.
    ///
    /// [TMDb API - Trending](https://developers.themoviedb.org/3/trending/get-trending)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - timeWindow: Daily or weekly time window. Defaults to daily.
    ///     - page: The page of results to return.
    ///
    /// - Returns: A publisher with trending movies in a time window as a pageable list.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func moviesPublisher(inTimeWindow timeWindow: TrendingTimeWindowFilterType,
                         page: Int?) -> AnyPublisher<MoviePageableList, TMDbError>

    /// Publishes a list of the daily or weekly trending TV shows.
    ///
    /// The daily trending list tracks TV shows over the period of a day while TV shows have a 24 hour half life. The
    /// weekly list tracks TV shows over a 7 day period, with a 7 day half life.
    ///
    /// [TMDb API - Trending](https://developers.themoviedb.org/3/trending/get-trending)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - timeWindow: Daily or weekly time window. Defaults to daily.
    ///     - page: The page of results to return.
    ///
    /// - Returns: A publisher with trending TV shows in a time window as a pageable list.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func tvShowsPublisher(inTimeWindow timeWindow: TrendingTimeWindowFilterType,
                          page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError>

    /// Publishes a list of the daily or weekly trending people.
    ///
    /// The daily trending list tracks people over the period of a day while people shows have a 24 hour half life. The
    /// weekly list tracks people over a 7 day period, with a 7 day half life.
    ///
    /// [TMDb API - Trending](https://developers.themoviedb.org/3/trending/get-trending)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - timeWindow: Daily or weekly time window. Defaults to daily.
    ///     - page: The page of results to return.
    ///
    /// - Returns: A publisher with trending people in a time window as a pageable list.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func peoplePublisher(inTimeWindow timeWindow: TrendingTimeWindowFilterType,
                         page: Int?) -> AnyPublisher<PersonPageableList, TMDbError>
    #endif

#if swift(>=5.5) && !os(Linux)
    /// Returns a list of the daily or weekly trending movies.
    ///
    /// The daily trending list tracks movies over the period of a day while movies have a 24 hour half life. The
    /// weekly list tracks movies over a 7 day period, with a 7 day half life.
    ///
    /// [TMDb API - Trending](https://developers.themoviedb.org/3/trending/get-trending)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - timeWindow: Daily or weekly time window. Defaults to daily.
    ///     - page: The page of results to return.
    ///
    /// - Returns: Trending movies in a time window as a pageable list.
    @available(macOS 12, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func movies(inTimeWindow timeWindow: TrendingTimeWindowFilterType, page: Int?) async throws -> MoviePageableList

    /// Returns a list of the daily or weekly trending TV shows.
    ///
    /// The daily trending list tracks TV shows over the period of a day while TV shows have a 24 hour half life. The
    /// weekly list tracks TV shows over a 7 day period, with a 7 day half life.
    ///
    /// [TMDb API - Trending](https://developers.themoviedb.org/3/trending/get-trending)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - timeWindow: Daily or weekly time window. Defaults to daily.
    ///     - page: The page of results to return.
    ///
    /// - Returns: Trending TV shows in a time window as a pageable list.
    @available(macOS 12, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func tvShows(inTimeWindow timeWindow: TrendingTimeWindowFilterType, page: Int?) async throws -> TVShowPageableList

    /// Returns a list of the daily or weekly trending people.
    ///
    /// The daily trending list tracks people over the period of a day while people shows have a 24 hour half life. The
    /// weekly list tracks people over a 7 day period, with a 7 day half life.
    ///
    /// [TMDb API - Trending](https://developers.themoviedb.org/3/trending/get-trending)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - timeWindow: Daily or weekly time window. Defaults to daily.
    ///     - page: The page of results to return.
    ///
    /// - Returns: Trending people in a time window as a pageable list.
    @available(macOS 12, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func people(inTimeWindow timeWindow: TrendingTimeWindowFilterType, page: Int?) async throws -> PersonPageableList
#endif

}

public extension TrendingService {

    func fetchMovies(inTimeWindow timeWindow: TrendingTimeWindowFilterType = .default, page: Int? = nil,
                     completion: @escaping (_ result: Result<MoviePageableList, TMDbError>) -> Void) {
        fetchMovies(inTimeWindow: timeWindow, page: page, completion: completion)
    }

    func fetchTVShows(inTimeWindow timeWindow: TrendingTimeWindowFilterType = .default, page: Int? = nil,
                      completion: @escaping (_ result: Result<TVShowPageableList, TMDbError>) -> Void) {
        fetchTVShows(inTimeWindow: timeWindow, page: page, completion: completion)
    }

    func fetchPeople(inTimeWindow timeWindow: TrendingTimeWindowFilterType = .default, page: Int? = nil,
                     completion: @escaping (_ result: Result<PersonPageableList, TMDbError>) -> Void) {
        fetchPeople(inTimeWindow: timeWindow, page: page, completion: completion)
    }

}

#if canImport(Combine)
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
public extension TrendingService {

    func moviesPublisher(inTimeWindow timeWindow: TrendingTimeWindowFilterType = .default,
                         page: Int? = nil) -> AnyPublisher<MoviePageableList, TMDbError> {
        moviesPublisher(inTimeWindow: timeWindow, page: page)
    }

    func tvShowsPublisher(inTimeWindow timeWindow: TrendingTimeWindowFilterType = .default,
                          page: Int? = nil) -> AnyPublisher<TVShowPageableList, TMDbError> {
        tvShowsPublisher(inTimeWindow: timeWindow, page: page)
    }

    func peoplePublisher(inTimeWindow timeWindow: TrendingTimeWindowFilterType = .default,
                         page: Int? = nil) -> AnyPublisher<PersonPageableList, TMDbError> {
        peoplePublisher(inTimeWindow: timeWindow, page: page)
    }

}
#endif

#if swift(>=5.5) && !os(Linux)
@available(macOS 12, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
public extension TrendingService {

    func movies(inTimeWindow timeWindow: TrendingTimeWindowFilterType = .default,
                page: Int? = nil) async throws -> MoviePageableList {
        try await movies(inTimeWindow: timeWindow, page: page)
    }

    func tvShows(inTimeWindow timeWindow: TrendingTimeWindowFilterType = .default,
                 page: Int? = nil) async throws -> TVShowPageableList {
        try await tvShows(inTimeWindow: timeWindow, page: page)
    }

    func people(inTimeWindow timeWindow: TrendingTimeWindowFilterType = .default,
                page: Int? = nil) async throws -> PersonPageableList {
        try await people(inTimeWindow: timeWindow, page: page)
    }

}
#endif
