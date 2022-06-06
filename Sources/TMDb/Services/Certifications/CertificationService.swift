import Foundation

/// Get an up to date list of the officially supported movie certifications on TMDb.
public protocol CertificationService {

    /// Returns the officially supported movie certifications on TMDb.
    ///
    /// [TMDb API - Movie Certifications](https://developers.themoviedb.org/3/certifications/get-movie-certifications)
    ///
    /// - Returns: A dictionary of movie certifications.
    func movieCertifications() async throws -> [String: [Certification]]

    /// Returns the officially supported TV show certifications on TMDb.
    ///
    /// [TMDb API - TV show Certifications](https://developers.themoviedb.org/3/certifications/get-tv-certifications)
    ///
    /// - Returns: A dictionary of TV show certifications.
    func tvShowCertifications() async throws -> [String: [Certification]]

}
