import Foundation

final class TMDbCertificationService: CertificationService {

    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func movieCertifications() async throws -> [String: [Certification]] {
        let certifications: Certifications = try await apiClient.get(endpoint: CertificationsEndpoint.movie)
        return certifications.certifications
    }

    func tvShowCertifications() async throws -> [String: [Certification]] {
        let certifications: Certifications = try await apiClient.get(endpoint: CertificationsEndpoint.tvShow)
        return certifications.certifications
    }

}
