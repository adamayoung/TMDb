import Foundation

///
/// Provides an interface for obtaining certification data from TMDb.
///
public final class CertificationService {

    private let apiClient: APIClient

    public convenience init(config: TMDbConfiguration) {
        self.init(
            apiClient: TMDbFactory.apiClient(apiKey: config.apiKey)
        )
    }

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    ///
    /// Returns the officially supported movie certifications on TMDb.
    ///
    /// [TMDb API - Movie Certifications](https://developers.themoviedb.org/3/certifications/get-movie-certifications)
    ///
    /// - Returns: A dictionary of movie certifications.
    /// 
    public func movieCertifications() async throws -> [String: [Certification]] {
        let certifications: Certifications = try await apiClient.get(endpoint: CertificationsEndpoint.movie)
        return certifications.certifications
    }

    ///
    /// Returns the officially supported TV show certifications on TMDb.
    ///
    /// [TMDb API - TV show Certifications](https://developers.themoviedb.org/3/certifications/get-tv-certifications)
    ///
    /// - Returns: A dictionary of TV show certifications.
    /// 
    public func tvShowCertifications() async throws -> [String: [Certification]] {
        let certifications: Certifications = try await apiClient.get(endpoint: CertificationsEndpoint.tvShow)
        return certifications.certifications
    }

}
