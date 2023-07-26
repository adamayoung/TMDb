import Foundation

///
/// A model representing configuration settings for TMDb.
///
/// Create an API key at [https://www.themoviedb.org/documentation/api](https://www.themoviedb.org/documentation/api).
///
public struct TMDbConfiguration {

    let apiKey: String
    let httpClient: HTTPClient?

    ///
    /// Creates a TMDb conifguration object using the default URLSession.
    ///
    /// - Parameters:
    ///    - apiKey: The TMDb API key to use.
    ///
    public init(apiKey: String) {
        self.apiKey = apiKey
        self.httpClient = nil
    }

    ///
    /// Creates a TMDb conifguration object.
    ///
    /// - Parameters:
    ///    - apiKey: The TMDb API key to use.
    ///    - httpClient: A custom HTTP client adapter to make HTTP requests.
    ///
    public init(apiKey: String, httpClient: HTTPClient) {
        self.apiKey = apiKey
        self.httpClient = httpClient
    }

}
