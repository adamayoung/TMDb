import Combine
@testable import TMDb
import XCTest

final class MockCertificationService: CertificationService {

    var movieCertifications: [String: [Certification]] = [:]
    var tvShowCertifications: [String: [Certification]] = [:]

    func fetchMovieCertifications() -> AnyPublisher<[String: [Certification]], TMDbError> {
        Just(movieCertifications)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

    func fetchTVShowCertifications() -> AnyPublisher<[String: [Certification]], TMDbError> {
        Just(tvShowCertifications)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }

}
