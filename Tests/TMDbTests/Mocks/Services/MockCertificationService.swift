@testable import TMDb
import XCTest

#if canImport(Combine)
import Combine
#endif

final class MockCertificationService: CertificationService {

    var movieCertifications: [String: [Certification]] = [:]
    var tvShowCertifications: [String: [Certification]] = [:]

    func fetchMovieCertifications(completion: @escaping (Result<[String: [Certification]], TMDbError>) -> Void) {
        DispatchQueue.main.simulateWaitForNetwork { [weak self] in
            guard let self = self else {
                return
            }

            completion(.success(self.movieCertifications))
        }
    }

    func fetchTVShowCertifications(completion: @escaping (Result<[String: [Certification]], TMDbError>) -> Void) {
        DispatchQueue.main.simulateWaitForNetwork { [weak self] in
            guard let self = self else {
                return
            }

            completion(.success(self.tvShowCertifications))
        }
    }

}

#if canImport(Combine)
extension MockCertificationService {

    func movieCertificationsPublisher() -> AnyPublisher<[String: [Certification]], TMDbError> {
        Just(movieCertifications)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func tvShowCertificationsPublisher() -> AnyPublisher<[String: [Certification]], TMDbError> {
        Just(tvShowCertifications)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

}
#endif

#if swift(>=5.5)
@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension MockCertificationService {

    func movieCertifications() async throws -> [String: [Certification]] {
        try await withCheckedThrowingContinuation { continuation in
            continuation.resume(returning: movieCertifications)
        }
    }

    func tvShowCertifications() async throws -> [String: [Certification]] {
        try await withCheckedThrowingContinuation { continuation in
            continuation.resume(returning: tvShowCertifications)
        }
    }

}
#endif
