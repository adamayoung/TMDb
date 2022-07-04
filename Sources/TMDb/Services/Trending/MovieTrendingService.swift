import Foundation

/// A service to fetch the daily or weekly trending movies.
public protocol MovieTrendingService {

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
    func movies(inTimeWindow timeWindow: TrendingTimeWindowFilterType, page: Int?) async throws -> MoviePageableList

}

public extension MovieTrendingService {

    func movies(inTimeWindow timeWindow: TrendingTimeWindowFilterType = .default,
                page: Int? = nil) async throws -> MoviePageableList {
        try await movies(inTimeWindow: timeWindow, page: page)
    }

}
