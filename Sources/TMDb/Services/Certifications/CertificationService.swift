import Foundation

#if canImport(Combine)
import Combine
#endif

/// Get an up to date list of the officially supported movie certifications on TMDb.
public protocol CertificationService {

    /// Fetches the officially supported movie certifications on TMDb.
    ///
    /// [TMDb API - Movie Certifications](https://developers.themoviedb.org/3/certifications/get-movie-certifications)
    ///
    /// - Parameters:
    ///     - completion: Completion handler.
    ///     - result: A dictionary of movie certifications.
    func fetchMovieCertifications(
        completion: @escaping (_ result: Result<[String: [Certification]], TMDbError>) -> Void)

    /// Fetches the officially supported TV show certifications on TMDb.
    ///
    /// [TMDb API - TV show Certifications](https://developers.themoviedb.org/3/certifications/get-tv-certifications)
    ///
    /// - Parameters:
    ///     - completion: Completion handler.
    ///     - result: A dictionary of TV show certifications.
    func fetchTVShowCertifications(
        completion: @escaping (_ result: Result<[String: [Certification]], TMDbError>) -> Void)

#if canImport(Combine)
    /// Publishes the officially supported movie certifications on TMDb.
    ///
    /// [TMDb API - Movie Certifications](https://developers.themoviedb.org/3/certifications/get-movie-certifications)
    ///
    /// - Returns: A publisher with a dictionary of movie certifications.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func movieCertificationsPublisher() -> AnyPublisher<[String: [Certification]], TMDbError>

    /// Publishes the officially supported TV show certifications on TMDb.
    ///
    /// [TMDb API - TV show Certifications](https://developers.themoviedb.org/3/certifications/get-tv-certifications)
    ///
    /// - Returns: A publisher with a dictionary of tv show certifications.
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func tvShowCertificationsPublisher() -> AnyPublisher<[String: [Certification]], TMDbError>
#endif

    /// Returns the officially supported movie certifications on TMDb.
    ///
    /// [TMDb API - Movie Certifications](https://developers.themoviedb.org/3/certifications/get-movie-certifications)
    ///
    /// - Returns: A dictionary of movie certifications.
    @available(macOS 12, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func movieCertifications() async throws -> [String: [Certification]]

    /// Returns the officially supported TV show certifications on TMDb.
    ///
    /// [TMDb API - TV show Certifications](https://developers.themoviedb.org/3/certifications/get-tv-certifications)
    ///
    /// - Returns: A dictionary of TV show certifications.
    @available(macOS 12, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func tvShowCertifications() async throws -> [String: [Certification]]

}
