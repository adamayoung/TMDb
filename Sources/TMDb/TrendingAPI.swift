import Combine
import Foundation

public protocol TrendingAPI {

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
    func trendingMoviesPublisher(inTimeWindow timeWindow: TrendingTimeWindowFilterType,
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
    func trendingTVShowsPublisher(inTimeWindow timeWindow: TrendingTimeWindowFilterType,
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
    func trendingPeoplePublisher(inTimeWindow timeWindow: TrendingTimeWindowFilterType,
                                 page: Int?) -> AnyPublisher<PersonPageableList, TMDbError>

}

public extension TrendingAPI {

    func trendingMoviesPublisher(inTimeWindow timeWindow: TrendingTimeWindowFilterType = .default,
                                 page: Int? = nil) -> AnyPublisher<MoviePageableList, TMDbError> {
        trendingMoviesPublisher(inTimeWindow: timeWindow, page: page)
    }

    func trendingTVShowsPublisher(inTimeWindow timeWindow: TrendingTimeWindowFilterType = .default,
                                  page: Int? = nil) -> AnyPublisher<TVShowPageableList, TMDbError> {
        trendingTVShowsPublisher(inTimeWindow: timeWindow, page: page)
    }

    func trendingPeoplePublisher(inTimeWindow timeWindow: TrendingTimeWindowFilterType = .default,
                                 page: Int? = nil) -> AnyPublisher<PersonPageableList, TMDbError> {
        trendingPeoplePublisher(inTimeWindow: timeWindow, page: page)
    }

}
