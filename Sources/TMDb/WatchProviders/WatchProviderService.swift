import Foundation
import os

///
/// Provides an interface for obtaining watch providers from TMDb.
///
@available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
public final class WatchProviderService {

    private let apiClient: APIClient
    private let localeProvider: () -> Locale

    ///
    /// Creates a watch provider service object.
    ///
    public convenience init() {
        self.init(
            apiClient: TMDbFactory.apiClient,
            localeProvider: TMDbFactory.localeProvider
        )
    }

    init(apiClient: APIClient, localeProvider: @escaping () -> Locale) {
        self.apiClient = apiClient
        self.localeProvider = localeProvider
    }

    ///
    /// Returns a list of all of the countries TMDb have watch provider (OTT/streaming) data for.
    ///
    /// [TMDb API - Watch Providers: Regions](https://developers.themoviedb.org/3/watch-providers/get-available-regions)
    ///
    /// - Returns: Countries TMDb have watch provider data for.
    /// 
    public func countries() async throws -> [Country] {
        let regions: WatchProviderRegions
        do {
            regions = try await apiClient.get(endpoint: WatchProviderEndpoint.regions)
        } catch let error {
            throw error
        }

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
        let regionCode = localeProvider().regionCode
        let result: WatchProviderResult
        do {
            result = try await apiClient.get(
                endpoint: WatchProviderEndpoint.movie(regionCode: regionCode)
            )
        } catch let error {
            throw error
        }

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
        let regionCode = localeProvider().regionCode
        let result: WatchProviderResult
        do {
            result = try await apiClient.get(
                endpoint: WatchProviderEndpoint.tvShow(regionCode: regionCode)
            )
        } catch let error {
            throw error
        }

        return result.results
    }

}
