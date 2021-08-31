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

    func movieCertificationsPublisher() -> AnyPublisher<[String: [Certification]], TMDbError> {
        apiClient.get(endpoint: CertificationsEndpoint.movie)
    }

    func tvShowCertificationsPublisher() -> AnyPublisher<[String: [Certification]], TMDbError> {
        apiClient.get(endpoint: CertificationsEndpoint.tvShow)
    }

}
#endif

#if swift(>=5.5)
@available(macOS 12, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
extension TMDbCertificationService {

    func movieCertifications() async throws -> [String: [Certification]] {
        try await apiClient.get(endpoint: CertificationsEndpoint.movie)
    }

    func tvShowCertifications() async throws -> [String: [Certification]] {
        try await apiClient.get(endpoint: CertificationsEndpoint.tvShow)
    }

}
#endif
