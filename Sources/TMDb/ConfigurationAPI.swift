import Combine
import Foundation

/// Configuration API interface.
public protocol ConfigurationAPI {

    /// Publishes the TMDb API system wide configuration information.
    ///
    /// - Note: [TMDb API - Configuration](https://developers.themoviedb.org/3/configuration/get-api-configuration)
    ///
    /// - Returns: A publisher with the API configuration.
    func apiConfigurationPublisher() -> AnyPublisher<APIConfigurationDTO, TMDbError>

}
