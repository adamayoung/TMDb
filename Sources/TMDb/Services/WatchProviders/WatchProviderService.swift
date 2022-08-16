import Foundation

public protocol WatchProviderService {

    /// Returns a list of all of the countries TMDb have watch provider (OTT/streaming) data for.
    ///
    /// [TMDb API - Watch Providers: Regions](https://developers.themoviedb.org/3/watch-providers/get-available-regions)
    ///
    /// - Returns: Countries TMDb have watch provider data for.
    func countries() async throws -> [Country]

    /// Returns a list of the watch provider (OTT/streaming) data TMDb have available for movies.
    ///
    /// [TMDb API - Watch Providers: Movie](https://developers.themoviedb.org/3/watch-providers/get-movie-providers)
    ///
    /// - Returns: Watch providers for movies.
    func movieWatchProviders() async throws -> [WatchProvider]

}
