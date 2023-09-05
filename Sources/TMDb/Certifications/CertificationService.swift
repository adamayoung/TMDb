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
    /// [TMDb API - Certifications: Movie Certifications](https://developer.themoviedb.org/reference/certification-movie-list)
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A dictionary of movie certifications.
    /// 
    public func movieCertifications() async throws -> [String: [Certification]] {
        let certifications: Certifications
        do {
            certifications = try await apiClient.get(endpoint: CertificationsEndpoint.movie)
        } catch let error {
            throw TMDbError(error: error)
        }

        return certifications.certifications
    }

    ///
    /// Returns an up to date list of the officially supported TV certifications on TMDB.
    ///
    /// [TMDb API - Certifications: TV Certifications](https://developer.themoviedb.org/reference/certifications-tv-list)
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A dictionary of TV show certifications.
    /// 
    public func tvShowCertifications() async throws -> [String: [Certification]] {
        let certifications: Certifications
        do {
            certifications = try await apiClient.get(endpoint: CertificationsEndpoint.tvShow)
        } catch let error {
            throw TMDbError(error: error)
        }

        return certifications.certifications
    }

}
