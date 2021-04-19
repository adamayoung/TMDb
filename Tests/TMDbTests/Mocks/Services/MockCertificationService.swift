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
