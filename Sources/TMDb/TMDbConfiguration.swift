import Foundation

///
/// A model representing configuration settings for TMDb.
///
/// Create an API key at [https://www.themoviedb.org/documentation/api](https://www.themoviedb.org/documentation/api).
///
public struct TMDbConfiguration {

    ///
    /// The TMDb API key to use.
    ///
    public let apiKey: String

    ///
    /// Creates a TMDb conifguration object.
    ///
    /// - Parameters:
    ///    - apiKey: The TMDb API key to use.
    ///
    public init(apiKey: String) {
        self.apiKey = apiKey
    }

}
