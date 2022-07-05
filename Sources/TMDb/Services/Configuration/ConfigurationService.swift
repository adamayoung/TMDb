import Foundation

/// A service to fetch the TMDb system wide configuration information.
public protocol ConfigurationService {

    /// Returns the TMDb API system wide configuration information. The result is cached, so there is no overhead in
    /// making multiple calls.
    ///
    /// [TMDb API - Configuration: API Configuration](https://developers.themoviedb.org/3/configuration/get-api-configuration)
    ///
    /// - Returns: The API configuration.
    func apiConfiguration() async throws -> APIConfiguration

    /// Returns the list of countries used throughout TMDb.
    ///
    /// [TMDb API - Configuration: Countries](https://developers.themoviedb.org/3/configuration/get-countries)
    ///
    /// - Returns: Countries used throughout TMDb,
    func countries() async throws -> [Country]

}
