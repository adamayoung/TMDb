import Combine
@testable import TMDb
import XCTest

final class MockCertificationService: CertificationService {

    var movieCertifications: [String: [CertificationDTO]] = [:]
    var tvShowCertifications: [String: [CertificationDTO]] = [:]

    func fetchMovieCertifications() -> AnyPublisher<[String: [CertificationDTO]], TMDbError> {
        Just(movieCertifications)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func fetchTVShowCertifications() -> AnyPublisher<[String: [CertificationDTO]], TMDbError> {
        Just(tvShowCertifications)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

}
