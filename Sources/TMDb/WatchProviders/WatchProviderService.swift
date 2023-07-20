import Foundation

///
/// Provides an interface for obtaining watch providers from TMDb.
///
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
public final class WatchProviderService {

    private let apiClient: APIClient

    ///
    /// Creates a watch provider service object.
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
    /// Returns a list of all of the countries TMDb have watch provider (OTT/streaming) data for.
    ///
    /// [TMDb API - Watch Providers: Regions](https://developers.themoviedb.org/3/watch-providers/get-available-regions)
    ///
    /// - Returns: Countries TMDb have watch provider data for.
    /// 
    public func countries() async throws -> [Country] {
        let regions: WatchProviderRegions = try await apiClient.get(endpoint: WatchProviderEndpoint.regions)
        return regions.results
    }

    ///
    /// Returns a list of the watch provider (OTT/streaming) data TMDb have available for movies.
    ///
    /// [TMDb API - Watch Providers: Movie](https://developers.themoviedb.org/3/watch-providers/get-movie-providers)
    ///
    /// - Returns: Watch providers for movies.
    /// 
    public func movieWatchProviders() async throws -> [WatchProvider] {
        let result: WatchProviderResult = try await apiClient.get(endpoint: WatchProviderEndpoint.movie)
        return result.results
    }

    ///
    /// Returns a list of the watch provider (OTT/streaming) data TMDb have available for TV shows.
    ///
    /// [TMDb API - Watch Providers: TV](https://developers.themoviedb.org/3/watch-providers/get-tv-providers)
    ///
    /// - Returns: Watch providers for TV shows.
    /// 
    public func tvShowWatchProviders() async throws -> [WatchProvider] {
        let result: WatchProviderResult = try await apiClient.get(endpoint: WatchProviderEndpoint.tvShow)
        return result.results
    }

}
