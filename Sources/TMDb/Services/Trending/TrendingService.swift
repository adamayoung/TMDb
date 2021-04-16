import Foundation

#if canImport(Combine)
import Combine
#endif

public protocol TrendingService {

    /// Fetches a list of the daily or weekly trending movies.
    ///
    /// The daily trending list tracks movies over the period of a day while movies have a 24 hour half life. The
    /// weekly list tracks movies over a 7 day period, with a 7 day half life.
    ///
    /// - Note: [TMDb API - Trending](https://developers.themoviedb.org/3/trending/get-trending)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - timeWindow: Daily or weekly time window.
    ///     - page: The page of results to return.
    ///     - completion: Completion handler.
    ///     - result: Trending movies in a time window as a pageable list.
    func fetchMovies(timeWindow: TrendingTimeWindowFilterType?, page: Int?,
                     completion: @escaping (_ result: Result<MoviePageableList, TMDbError>) -> Void)

    /// Fetches a list of the daily or weekly trending TV shows.
    ///
    /// The daily trending list tracks TV shows over the period of a day while TV shows have a 24 hour half life. The
    /// weekly list tracks TV shows over a 7 day period, with a 7 day half life.
    ///
    /// - Note: [TMDb API - Trending](https://developers.themoviedb.org/3/trending/get-trending)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - timeWindow: Daily or weekly time window.
    ///     - page: The page of results to return.
    ///     - completion: Completion handler.
    ///     - result: Trending TV shows in a time window as a pageable list.
    func fetchTVShows(timeWindow: TrendingTimeWindowFilterType?, page: Int?,
                      completion: @escaping (_ result: Result<TVShowPageableList, TMDbError>) -> Void)

    /// Fetches a list of the daily or weekly trending people.
    ///
    /// The daily trending list tracks people over the period of a day while people shows have a 24 hour half life. The
    /// weekly list tracks people over a 7 day period, with a 7 day half life.
    ///
    /// - Note: [TMDb API - Trending](https://developers.themoviedb.org/3/trending/get-trending)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - timeWindow: Daily or weekly time window.
    ///     - page: The page of results to return.
    ///     - completion: Completion handler.
    ///     - result: Trending people in a time window as a pageable list.
    func fetchPeople(timeWindow: TrendingTimeWindowFilterType?, page: Int?,
                     completion: @escaping (_ result: Result<PersonPageableList, TMDbError>) -> Void)

    #if canImport(Combine)
    /// Publishes a list of the daily or weekly trending movies.
    ///
    /// The daily trending list tracks movies over the period of a day while movies have a 24 hour half life. The
    /// weekly list tracks movies over a 7 day period, with a 7 day half life.
    ///
    /// - Note: [TMDb API - Trending](https://developers.themoviedb.org/3/trending/get-trending)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - timeWindow: Daily or weekly time window.
    ///     - page: The page of results to return.
    ///
    /// - Returns: A publisher with trending movies in a time window as a pageable list.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func moviesPublisher(timeWindow: TrendingTimeWindowFilterType?,
                         page: Int?) -> AnyPublisher<MoviePageableList, TMDbError>

    /// Publishes a list of the daily or weekly trending TV shows.
    ///
    /// The daily trending list tracks TV shows over the period of a day while TV shows have a 24 hour half life. The
    /// weekly list tracks TV shows over a 7 day period, with a 7 day half life.
    ///
    /// - Note: [TMDb API - Trending](https://developers.themoviedb.org/3/trending/get-trending)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - timeWindow: Daily or weekly time window.
    ///     - page: The page of results to return.
    ///
    /// - Returns: A publisher with trending TV shows in a time window as a pageable list.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func tvShowsPublisher(timeWindow: TrendingTimeWindowFilterType?,
                          page: Int?) -> AnyPublisher<TVShowPageableList, TMDbError>

    /// Publishes a list of the daily or weekly trending people.
    ///
    /// The daily trending list tracks people over the period of a day while people shows have a 24 hour half life. The
    /// weekly list tracks people over a 7 day period, with a 7 day half life.
    ///
    /// - Note: [TMDb API - Trending](https://developers.themoviedb.org/3/trending/get-trending)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - timeWindow: Daily or weekly time window.
    ///     - page: The page of results to return.
    ///
    /// - Returns: A publisher with trending people in a time window as a pageable list.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func peoplePublisher(timeWindow: TrendingTimeWindowFilterType?,
                         page: Int?) -> AnyPublisher<PersonPageableList, TMDbError>
    #endif

}

public extension TrendingService {

    func fetchMovies(timeWindow: TrendingTimeWindowFilterType? = .default, page: Int? = nil,
                     completion: @escaping (_ result: Result<MoviePageableList, TMDbError>) -> Void) {
        fetchMovies(timeWindow: timeWindow, page: page, completion: completion)
    }

    func fetchTVShows(timeWindow: TrendingTimeWindowFilterType? = .default, page: Int? = nil,
                      completion: @escaping (_ result: Result<TVShowPageableList, TMDbError>) -> Void) {
        fetchTVShows(timeWindow: timeWindow, page: page, completion: completion)
    }

    func fetchPeople(timeWindow: TrendingTimeWindowFilterType? = .default, page: Int? = nil,
                     completion: @escaping (_ result: Result<PersonPageableList, TMDbError>) -> Void) {
        fetchPeople(timeWindow: timeWindow, page: page, completion: completion)
    }

}

#if canImport(Combine)
public extension TrendingService {

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func moviesPublisher(timeWindow: TrendingTimeWindowFilterType? = .default,
                         page: Int? = nil) -> AnyPublisher<MoviePageableList, TMDbError> {
        moviesPublisher(timeWindow: timeWindow, page: page)
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func tvShowsPublisher(timeWindow: TrendingTimeWindowFilterType? = .default,
                          page: Int? = nil) -> AnyPublisher<TVShowPageableList, TMDbError> {
        tvShowsPublisher(timeWindow: timeWindow, page: page)
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func peoplePublisher(timeWindow: TrendingTimeWindowFilterType? = .default,
                         page: Int? = nil) -> AnyPublisher<PersonPageableList, TMDbError> {
        peoplePublisher(timeWindow: timeWindow, page: page)
    }

}
#endif
