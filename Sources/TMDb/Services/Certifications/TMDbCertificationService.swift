import Foundation

final class TMDbCertificationService: CertificationService {

    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func movieCertifications() async throws -> [String: [Certification]] {
        try await apiClient.get(endpoint: CertificationsEndpoint.movie)
    }

    func tvShowCertifications() async throws -> [String: [Certification]] {
        try await apiClient.get(endpoint: CertificationsEndpoint.tvShow)
    }

}
