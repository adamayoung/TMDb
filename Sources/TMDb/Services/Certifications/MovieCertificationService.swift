import Foundation

/// A service to fetch an up to date list of the officially supported movie certifications on TMDb.
public protocol MovieCertificationService {

    /// Returns the officially supported movie certifications on TMDb.
    ///
    /// [TMDb API - Movie Certifications](https://developers.themoviedb.org/3/certifications/get-movie-certifications)
    ///
    /// - Returns: A dictionary of movie certifications.
    func movieCertifications() async throws -> [String: [Certification]]

}
