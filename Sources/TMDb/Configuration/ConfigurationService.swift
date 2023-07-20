import Foundation

///
/// Provides an interface for obtaining configuration data from TMDb.
///
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
public final class ConfigurationService {

    private let apiClient: APIClient

    ///
    /// Creates a configuration service object.
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
    /// Returns the TMDb API system wide configuration information. The result is cached, so there is no overhead in
    /// making multiple calls.
    ///
    /// [TMDb API - Configuration: API Configuration](https://developers.themoviedb.org/3/configuration/get-api-configuration)
    ///
    /// - Returns: The API configuration.
    /// 
    public func apiConfiguration() async throws -> APIConfiguration {
        try await apiClient.get(endpoint: ConfigurationEndpoint.api)
    }

    ///
    /// Returns the list of countries used throughout TMDb.
    ///
    /// [TMDb API - Configuration: Countries](https://developers.themoviedb.org/3/configuration/get-countries)
    ///
    /// - Returns: Countries used throughout TMDb,
    /// 
    public func countries() async throws -> [Country] {
        try await apiClient.get(endpoint: ConfigurationEndpoint.countries)
    }

    ///
    /// Returns a list of the jobs and departments used on TMDb.
    ///
    /// [TMDb API - Configuration: Jobs](https://developers.themoviedb.org/3/configuration/get-jobs)
    ///
    /// - Returns: Jobs and departments used on TMDb.
    /// 
    public func jobsByDepartment() async throws -> [Department] {
        try await apiClient.get(endpoint: ConfigurationEndpoint.jobs)
    }

    ///
    /// Returns the list of languages (ISO 639-1 tags) used throughout TMDb.
    ///
    /// [TMDb API - Configuration: Languages](https://developers.themoviedb.org/3/configuration/get-languages)
    ///
    ///  - Returns: Languages used throughout TMDb.
    ///
    public func languages() async throws -> [Language] {
        try await apiClient.get(endpoint: ConfigurationEndpoint.languages)
    }

}
