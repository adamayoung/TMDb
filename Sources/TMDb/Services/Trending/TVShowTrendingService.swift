import Foundation

/// A service to fetch the daily or weekly trending TV shows.
public protocol TVShowTrendingService {

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
    func tvShows(inTimeWindow timeWindow: TrendingTimeWindowFilterType, page: Int?) async throws -> TVShowPageableList

}

public extension TVShowTrendingService {

    func tvShows(inTimeWindow timeWindow: TrendingTimeWindowFilterType = .default,
                 page: Int? = nil) async throws -> TVShowPageableList {
        try await tvShows(inTimeWindow: timeWindow, page: page)
    }

}
