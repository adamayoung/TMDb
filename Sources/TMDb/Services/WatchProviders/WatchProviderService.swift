import Foundation

public protocol WatchProviderService {

    /// Returns a list of all of the countries TMDb have watch provider (OTT/streaming) data for.
    ///
    /// [TMDb API - Watch Providers: Regions](https://developers.themoviedb.org/3/watch-providers/get-available-regions)
    ///
    /// - Returns: Countries TMDb have watch provider data for.
    func countries() async throws -> [Country]

}
