import Combine
import Foundation

protocol ConfigurationService {

    func fetchAPIConfiguration() -> AnyPublisher<APIConfiguration, TMDbError>

}
