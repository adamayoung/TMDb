import Foundation

/// A service to fetch an up to date list of the officially supported TV show certifications on TMDb.
public protocol TVShowCertificationService {

    /// Returns the officially supported TV show certifications on TMDb.
    ///
    /// [TMDb API - TV show Certifications](https://developers.themoviedb.org/3/certifications/get-tv-certifications)
    ///
    /// - Returns: A dictionary of TV show certifications.
    func tvShowCertifications() async throws -> [String: [Certification]]

}
