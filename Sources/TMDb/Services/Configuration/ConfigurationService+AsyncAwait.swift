import Foundation

#if swift(>=5.5)
@available(macOS 12, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
public extension ConfigurationService {

    /// Fetches the TMDb API system wide configuration information.
    ///
    /// - Note: [TMDb API - Configuration](https://developers.themoviedb.org/3/configuration/get-api-configuration)
    ///
    /// - Parameters:
    ///     - completion: Completion handler.
    ///     - result: The API configuration.
    func fetchAPIConfiguration() async throws -> APIConfiguration {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchAPIConfiguration(completion: continuation.resume(with:))
        }
    }

}
#endif
