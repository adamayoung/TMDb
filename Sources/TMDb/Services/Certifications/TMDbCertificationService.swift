import Combine
import Foundation

final class TMDbCertificationService: CertificationService {

    private let apiClient: APIClient

    init(apiClient: APIClient = TMDbAPIClient.shared) {
        self.apiClient = apiClient
    }

    func fetchMovieCertifications() -> AnyPublisher<[String: [CertificationDTO]], TMDbError> {
        apiClient.get(endpoint: CertificationsEndpoint.movie)
    }

    func fetchTVShowCertifications() -> AnyPublisher<[String: [CertificationDTO]], TMDbError> {
        apiClient.get(endpoint: CertificationsEndpoint.tvShow)
    }

}
