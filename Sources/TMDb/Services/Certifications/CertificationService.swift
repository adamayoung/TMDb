import Foundation

#if canImport(Combine)
import Combine
#endif

/// Certifications interface.
public protocol CertificationService {

    /// Fetches the officially supported movie certifications on TMDb.
    ///
    /// - Note: [TMDb API - Movie Certifications](https://developers.themoviedb.org/3/certifications/get-movie-certifications)
    ///
    /// - Parameters:
    ///     - completion: Completion handler.
    ///     - result: A dictionary of movie certifications.
    func fetchMovieCertifications(
        completion: @escaping (_ result: Result<[String: [Certification]], TMDbError>) -> Void)

    /// Fetches the officially supported TV show certifications on TMDb.
    ///
    /// - Note: [TMDb API - TV show Certifications](https://developers.themoviedb.org/3/certifications/get-tv-certifications)
    ///
    /// - Parameters:
    ///     - completion: Completion handler.
    ///     - result: A dictionary of TV show certifications.
    func fetchTVShowCertifications(
        completion: @escaping (_ result: Result<[String: [Certification]], TMDbError>) -> Void)

    #if canImport(Combine)
    /// Publishes the officially supported movie certifications on TMDb.
    ///
    /// - Note: [TMDb API - Movie Certifications](https://developers.themoviedb.org/3/certifications/get-movie-certifications)
    ///
    /// - Returns: A publisher with a dictionary of movie certifications.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func movieCertificationsPublisher() -> AnyPublisher<[String: [Certification]], TMDbError>

    /// Publishes the officially supported TV show certifications on TMDb.
    ///
    /// - Note: [TMDb API - TV show Certifications](https://developers.themoviedb.org/3/certifications/get-tv-certifications)
    ///
    /// - Returns: A publisher with a dictionary of tv show certifications.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func tvShowCertificationsPublisher() -> AnyPublisher<[String: [Certification]], TMDbError>
    #endif

}
