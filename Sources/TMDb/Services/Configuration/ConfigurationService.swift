import Foundation

#if canImport(Combine)
import Combine
#endif

/// Get the system wide configuration information.
public protocol ConfigurationService {

    /// Fetches the TMDb API system wide configuration information.
    ///
    /// - Note: [TMDb API - Configuration](https://developers.themoviedb.org/3/configuration/get-api-configuration)
    ///
    /// - Parameters:
    ///     - completion: Completion handler.
    ///     - result: The API configuration.
    func fetchAPIConfiguration(completion: @escaping (_ result: Result<APIConfiguration, TMDbError>) -> Void)

    #if canImport(Combine)
    /// Publishes the TMDb API system wide configuration information.
    ///
    /// - Note: [TMDb API - Configuration](https://developers.themoviedb.org/3/configuration/get-api-configuration)
    ///
    /// - Returns: A publisher with the API configuration.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func apiConfigurationPublisher() -> AnyPublisher<APIConfiguration, TMDbError>
    #endif

}
