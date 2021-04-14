import Combine
import Foundation

public protocol MovieTVShowAPI: CertificationAPI, ConfigurationAPI, DiscoveryAPI, MovieAPI, PersonAPI, SearchAPI,
                                TrendingAPI, TVShowAPI {

    /// Sets the TMDb API Key to be used with requests to the TMDb API.
    ///
    /// - Note: [TMDb API - Getting Started: Authentication](https://developers.themoviedb.org/3/getting-started/authentication#api-key)
    ///
    /// - Parameter apiKey: The TMDb API Key.
    static func setAPIKey(_ apiKey: String)

}
