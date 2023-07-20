import Foundation

///
/// Provides an interface for finding trending movies, TV shows and people from TMDb.
///
public final class TrendingService {

    private let apiClient: APIClient

    ///
    /// Creates a trending service object.
    ///
    /// - Parameters:
    ///    - config: TMDb configuration setting.
    ///
    public convenience init(config: TMDbConfiguration) {
        self.init(
            apiClient: TMDbFactory.apiClient(apiKey: config.apiKey)
        )
    }

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    ///
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
    ///    - timeWindow: Daily or weekly time window. Defaults to daily.
    ///    - page: The page of results to return.
    ///
    /// - Returns: Trending movies in a time window as a pageable list.
    ///
    public func movies(inTimeWindow timeWindow: TrendingTimeWindowFilterType = .default,
                       page: Int? = nil) async throws -> MoviePageableList {
        try await apiClient.get(endpoint: TrendingEndpoint.movies(timeWindow: timeWindow, page: page))
    }

    ///
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
    ///    - timeWindow: Daily or weekly time window. Defaults to daily.
    ///    - page: The page of results to return.
    ///
    /// - Returns: Trending TV shows in a time window as a pageable list.
    ///
    public func tvShows(inTimeWindow timeWindow: TrendingTimeWindowFilterType = .default,
                        page: Int? = nil) async throws -> TVShowPageableList {
        try await apiClient.get(endpoint: TrendingEndpoint.tvShows(timeWindow: timeWindow, page: page))
    }

    ///
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
    ///    - timeWindow: Daily or weekly time window. Defaults to daily.
    ///    - page: The page of results to return.
    ///
    /// - Returns: Trending people in a time window as a pageable list.
    ///
    public func people(inTimeWindow timeWindow: TrendingTimeWindowFilterType = .default,
                       page: Int? = nil) async throws -> PersonPageableList {
        try await apiClient.get(endpoint: TrendingEndpoint.people(timeWindow: timeWindow, page: page))
    }

}
