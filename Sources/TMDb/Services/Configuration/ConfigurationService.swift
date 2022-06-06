import Foundation

/// Get the system wide configuration information.
public protocol ConfigurationService {

    /// Returns the TMDb API system wide configuration information.
    ///
    /// [TMDb API - Configuration](https://developers.themoviedb.org/3/configuration/get-api-configuration)
    ///
    /// - Returns: The API configuration.
    func apiConfiguration() async throws -> APIConfiguration

}
