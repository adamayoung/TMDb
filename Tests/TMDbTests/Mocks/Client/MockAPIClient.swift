@testable import TMDb
import XCTest

#if canImport(Combine)
import Combine
#endif

class MockAPIClient: APIClient {

    static var apiKey: String?

    var response: Any?
    private(set) var lastPath: URL?
    private(set) var lastHTTPHeaders: [String: String]?

    static func setAPIKey(_ apiKey: String) {
        Self.apiKey = apiKey
    }

    func get<Response>(path: URL, httpHeaders: [String: String]?,
                       completion: @escaping (Result<Response, TMDbError>) -> Void) where Response: Decodable {
        self.lastPath = path
        self.lastHTTPHeaders = httpHeaders

        guard let decodedResponse = response as? Response else {
            XCTFail("Can't cast response to type \(String(describing: Response.self))")
            return
        }

        DispatchQueue.main.simulateWaitForNetwork {
            completion(.success(decodedResponse))
        }
    }

    #if canImport(Combine)
    func get<Response: Decodable>(path: URL, httpHeaders: [String: String]?) -> AnyPublisher<Response, TMDbError> {
        self.lastPath = path
        self.lastHTTPHeaders = httpHeaders

        guard let result = response as? Response else {
            XCTFail("Can't cast response to type \(String(describing: Response.self))")
            return Empty()
                .setFailureType(to: TMDbError.self)
                .eraseToAnyPublisher()
        }

        return Just(result)
            .setFailureType(to: TMDbError.self)
            .eraseToAnyPublisher()
    }
    #endif

    func reset() {
        response = nil
        lastPath = nil
        lastHTTPHeaders = nil
    }

}
