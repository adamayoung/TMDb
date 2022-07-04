import Foundation

/// A service to fetch the daily or weekly trending people.
public protocol PersonTrendingService {

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
    func people(inTimeWindow timeWindow: TrendingTimeWindowFilterType, page: Int?) async throws -> PersonPageableList

}

public extension PersonTrendingService {

    func people(inTimeWindow timeWindow: TrendingTimeWindowFilterType = .default,
                page: Int? = nil) async throws -> PersonPageableList {
        try await people(inTimeWindow: timeWindow, page: page)
    }

}
