import Foundation
import os

///
/// Provides an interface for obtaining configuration data from TMDb.
///
@available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
public final class ConfigurationService {

    private static let logger = Logger(subsystem: Logger.tmdb, category: "ConfigurationService")

    private let apiClient: APIClient

    ///
    /// Creates a configuration service object.
    ///
    public convenience init() {
        self.init(
            apiClient: TMDbFactory.apiClient
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
        Self.logger.trace("fetching api configuration")

        let apiConfiguration: APIConfiguration
        do {
            apiConfiguration = try await apiClient.get(endpoint: ConfigurationEndpoint.api)
        } catch let error {
            Self.logger.error("failed fetching api configuration: \(error.localizedDescription, privacy: .public)")
            throw error
        }

        return apiConfiguration
    }

    ///
    /// Returns the list of countries used throughout TMDb.
    ///
    /// [TMDb API - Configuration: Countries](https://developers.themoviedb.org/3/configuration/get-countries)
    ///
    /// - Returns: Countries used throughout TMDb,
    /// 
    public func countries() async throws -> [Country] {
        Self.logger.trace("fetching countries")

        let countries: [Country]
        do {
            countries = try await apiClient.get(endpoint: ConfigurationEndpoint.countries)
        } catch let error {
            Self.logger.error("failed fetching countries: \(error.localizedDescription, privacy: .public)")
            throw error
        }

        return countries
    }

    ///
    /// Returns a list of the jobs and departments used on TMDb.
    ///
    /// [TMDb API - Configuration: Jobs](https://developers.themoviedb.org/3/configuration/get-jobs)
    ///
    /// - Returns: Jobs and departments used on TMDb.
    /// 
    public func jobsByDepartment() async throws -> [Department] {
        Self.logger.trace("fetching jobs by department")

        let departments: [Department]
        do {
            departments = try await apiClient.get(endpoint: ConfigurationEndpoint.jobs)
        } catch let error {
            Self.logger.error("failed fetching jobs by department: \(error.localizedDescription, privacy: .public)")
            throw error
        }

        return departments
    }

    ///
    /// Returns the list of languages (ISO 639-1 tags) used throughout TMDb.
    ///
    /// [TMDb API - Configuration: Languages](https://developers.themoviedb.org/3/configuration/get-languages)
    ///
    ///  - Returns: Languages used throughout TMDb.
    ///
    public func languages() async throws -> [Language] {
        Self.logger.trace("fetching languages")

        let languages: [Language]
        do {
            languages = try await apiClient.get(endpoint: ConfigurationEndpoint.languages)
        } catch let error {
            Self.logger.error("failed fetching languages: \(error.localizedDescription, privacy: .public)")
            throw error
        }

        return languages
    }

}
