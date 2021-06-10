import Foundation

#if swift(>=5.5)
@available(macOS 12, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
public extension TrendingService {

    /// Returns a list of the daily or weekly trending movies.
    ///
    /// The daily trending list tracks movies over the period of a day while movies have a 24 hour half life. The
    /// weekly list tracks movies over a 7 day period, with a 7 day half life.
    ///
    /// - Note: [TMDb API - Trending](https://developers.themoviedb.org/3/trending/get-trending)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - timeWindow: Daily or weekly time window. Defaults to daily.
    ///     - page: The page of results to return.
    ///
    /// - Returns: Trending movies in a time window as a pageable list.
    func movies(inTimeWindow timeWindow: TrendingTimeWindowFilterType = .default,
                page: Int? = nil) async throws -> MoviePageableList {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchMovies(inTimeWindow: timeWindow, page: page, completion: continuation.resume(with:))
        }
    }

    /// Returns a list of the daily or weekly trending TV shows.
    ///
    /// The daily trending list tracks TV shows over the period of a day while TV shows have a 24 hour half life. The
    /// weekly list tracks TV shows over a 7 day period, with a 7 day half life.
    ///
    /// - Note: [TMDb API - Trending](https://developers.themoviedb.org/3/trending/get-trending)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - timeWindow: Daily or weekly time window. Defaults to daily.
    ///     - page: The page of results to return.
    ///
    /// - Returns: Trending TV shows in a time window as a pageable list.
    func tvShows(inTimeWindow timeWindow: TrendingTimeWindowFilterType = .default,
                 page: Int? = nil) async throws -> TVShowPageableList {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchTVShows(inTimeWindow: timeWindow, page: page, completion: continuation.resume(with:))
        }
    }

    /// Returns a list of the daily or weekly trending people.
    ///
    /// The daily trending list tracks people over the period of a day while people shows have a 24 hour half life. The
    /// weekly list tracks people over a 7 day period, with a 7 day half life.
    ///
    /// - Note: [TMDb API - Trending](https://developers.themoviedb.org/3/trending/get-trending)
    ///
    /// - Precondition: `page` can be between `1` and `1000`.
    ///
    /// - Parameters:
    ///     - timeWindow: Daily or weekly time window. Defaults to daily.
    ///     - page: The page of results to return.
    ///
    /// - Returns: Trending people in a time window as a pageable list.
    func people(inTimeWindow timeWindow: TrendingTimeWindowFilterType = .default,
                page: Int? = nil) async throws -> PersonPageableList {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchPeople(inTimeWindow: timeWindow, page: page, completion: continuation.resume(with:))
        }
    }

}
#endif
