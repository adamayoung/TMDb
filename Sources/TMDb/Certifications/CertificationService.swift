import Foundation

///
/// Provides an interface for obtaining certification data from TMDb.
///
@available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
public final class CertificationService {

    private let apiClient: APIClient

    ///
    /// Creates a certificate service object.
    ///
    public convenience init() {
        self.init(
            apiClient: TMDbFactory.apiClient
        )
    }

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    ///
    /// Returns an up to date list of the officially supported movie certifications on TMDB.
    ///
    /// [TMDb API - Movie Certifications](https://developer.themoviedb.org/reference/certification-movie-list)
    ///
    /// - Returns: A dictionary of movie certifications.
    /// 
    public func movieCertifications() async throws -> [String: [Certification]] {
        let certifications: Certifications
        do {
            certifications = try await apiClient.get(endpoint: CertificationsEndpoint.movie)
        } catch let error {
            throw error
        }

        return certifications.certifications
    }

    ///
    /// Returns an up to date list of the officially supported TV certifications on TMDB.
    ///
    /// [TMDb API - TV show Certifications](https://developer.themoviedb.org/reference/certifications-tv-list)
    ///
    /// - Returns: A dictionary of TV show certifications.
    /// 
    public func tvShowCertifications() async throws -> [String: [Certification]] {
        let certifications: Certifications
        do {
            certifications = try await apiClient.get(endpoint: CertificationsEndpoint.tvShow)
        } catch let error {
            throw error
        }

        return certifications.certifications
    }

}
