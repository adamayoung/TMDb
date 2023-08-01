import Foundation

///
/// A model representing configuration settings for TMDb.
///
/// Create an API key at [https://www.themoviedb.org/documentation/api](https://www.themoviedb.org/documentation/api).
///
public struct TMDbConfiguration {

    let apiKey: @Sendable () -> String
    let httpClient: @Sendable () -> any HTTPClient

    ///
    /// Creates a TMDb configuration object using URLSession as the HTTP client.
    ///
    /// - Parameters:
    ///    - apiKey: The TMDb API key to use.
    ///
    public init(apiKey: String) {
        self.init(
            apiKey: { apiKey },
            httpClient: { TMDbFactory.defaultHTTPClientAdapter }
        )
    }

    ///
    /// Creates a TMDb configuration object.
    ///
    /// - Parameters:
    ///    - apiKey: The TMDb API key to use.
    ///    - httpClient: A custom HTTP client adapter for making HTTP requests.
    ///
    public init(apiKey: String, httpClient: some HTTPClient) {
        self.init(
            apiKey: { apiKey },
            httpClient: { httpClient }
        )
    }

    init(apiKey: @escaping @Sendable () -> String, httpClient: @escaping @Sendable () -> any HTTPClient) {
        self.apiKey = apiKey
        self.httpClient = httpClient
    }

}
