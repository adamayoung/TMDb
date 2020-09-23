import Combine
import Foundation

protocol CertificationService {

    func fetchMovieCertifications() -> AnyPublisher<[String: [CertificationDTO]], TMDbError>

    func fetchTVShowCertifications() -> AnyPublisher<[String: [CertificationDTO]], TMDbError>

}
