import Foundation

#if canImport(Combine)
import Combine
#endif

final class TMDbCertificationService: CertificationService {

    private let apiClient: APIClient

    init(apiClient: APIClient = TMDbAPIClient.shared) {
        self.apiClient = apiClient
    }

    func fetchMovieCertifications(completion: @escaping (Result<[String: [Certification]], TMDbError>) -> Void) {
        apiClient.get(endpoint: CertificationsEndpoint.movie, completion: completion)
    }

    func fetchTVShowCertifications(completion: @escaping (Result<[String: [Certification]], TMDbError>) -> Void) {
        apiClient.get(endpoint: CertificationsEndpoint.tvShow, completion: completion)
    }

}

#if canImport(Combine)
extension TMDbCertificationService {

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func movieCertificationsPublisher() -> AnyPublisher<[String: [Certification]], TMDbError> {
        apiClient.get(endpoint: CertificationsEndpoint.movie)
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func tvShowCertificationsPublisher() -> AnyPublisher<[String: [Certification]], TMDbError> {
        apiClient.get(endpoint: CertificationsEndpoint.tvShow)
    }

}
#endif
