import Combine
import Foundation

/// Certifications API interface.
public protocol CertificationAPI {

    /// Publishes the officially supported movie certifications on TMDb.
    ///
    /// - Note: [TMDb API - Movie Certifications](https://developers.themoviedb.org/3/certifications/get-movie-certifications)
    ///
    /// - Returns: A publisher with a dictionary of movie certifications.
    func movieCertificationsPublisher() -> AnyPublisher<[String: [CertificationDTO]], TMDbError>

    /// Publishes the officially supported TV show certifications on TMDb.
    ///
    /// - Note: [TMDb API - TV show Certifications](https://developers.themoviedb.org/3/certifications/get-tv-certifications)
    ///
    /// - Returns: A publisher with a dictionary of tv show certifications.
    func tvShowCertificationsPublisher() -> AnyPublisher<[String: [CertificationDTO]], TMDbError>

}
