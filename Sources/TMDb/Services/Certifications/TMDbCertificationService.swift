import Combine
import Foundation

public final class TMDbCertificationService: CertificationService {

    private let apiClient: APIClient

    public init(apiClient: APIClient = TMDbAPIClient.shared) {
        self.apiClient = apiClient
    }

    public func fetchMovieCertifications() -> AnyPublisher<[String: [Certification]], TMDbError> {
        apiClient.get(endpoint: CertificationsEndpoint.movie)
    }

    public func fetchTVShowCertifications() -> AnyPublisher<[String: [Certification]], TMDbError> {
        apiClient.get(endpoint: CertificationsEndpoint.tvShow)
    }

}
