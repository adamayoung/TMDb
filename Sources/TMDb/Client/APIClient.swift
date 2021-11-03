import Foundation

#if canImport(Combine)
import Combine
#endif

protocol APIClient {

    static func setAPIKey(_ apiKey: String)

    func get<Response: Decodable>(path: URL, httpHeaders: [String: String]?,
                                  completion: @escaping (Result<Response, TMDbError>) -> Void)

#if canImport(Combine)
    func get<Response: Decodable>(path: URL, httpHeaders: [String: String]?) -> AnyPublisher<Response, TMDbError>
#endif

#if swift(>=5.5)
    func get<Response: Decodable>(path: URL, httpHeaders: [String: String]?) async throws -> Response
#endif

}

extension APIClient {

    func get<Response: Decodable>(path: URL, httpHeaders: [String: String]? = nil,
                                  completion: @escaping (Result<Response, TMDbError>) -> Void) {
        get(path: path, httpHeaders: httpHeaders, completion: completion)
    }

    func get<Response: Decodable>(endpoint: Endpoint, httpHeaders: [String: String]? = nil,
                                  completion: @escaping (Result<Response, TMDbError>) -> Void) {
        get(path: endpoint.url, httpHeaders: httpHeaders, completion: completion)
    }

}

#if canImport(Combine)
extension APIClient {

    func get<Response: Decodable>(path: URL,
                                  httpHeaders: [String: String]? = nil) -> AnyPublisher<Response, TMDbError> {
        get(path: path, httpHeaders: httpHeaders)
    }

    func get<Response: Decodable>(endpoint: Endpoint,
                                  httpHeaders: [String: String]? = nil) -> AnyPublisher<Response, TMDbError> {
        get(path: endpoint.url, httpHeaders: httpHeaders)
    }

}
#endif

#if swift(>=5.5)
extension APIClient {

    func get<Response: Decodable>(path: URL, httpHeaders: [String: String]? = nil) async throws -> Response {
        try await get(path: path, httpHeaders: httpHeaders)
    }

    func get<Response: Decodable>(endpoint: Endpoint, httpHeaders: [String: String]? = nil) async throws -> Response {
        try await get(path: endpoint.url, httpHeaders: httpHeaders)
    }

}
#endif
