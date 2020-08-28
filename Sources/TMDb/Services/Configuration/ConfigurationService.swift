import Combine
import Foundation

public protocol ConfigurationService {

    func fetchAPIConfiguration() -> AnyPublisher<APIConfiguration, TMDbError>

}
