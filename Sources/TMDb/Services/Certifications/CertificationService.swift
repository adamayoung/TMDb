import Combine
import Foundation

protocol CertificationService {

    func fetchMovieCertifications() -> AnyPublisher<[String: [Certification]], TMDbError>

    func fetchTVShowCertifications() -> AnyPublisher<[String: [Certification]], TMDbError>

}
