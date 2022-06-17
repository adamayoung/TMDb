import Foundation

protocol APIClient {

    static func setAPIKey(_ apiKey: String)

    func get<Response: Decodable>(path: URL, httpHeaders: [String: String]?) async throws -> Response

}

extension APIClient {

    func get<Response: Decodable>(path: URL, httpHeaders: [String: String]? = nil) async throws -> Response {
        try await get(path: path, httpHeaders: httpHeaders)
    }

    func get<Response: Decodable>(endpoint: Endpoint, httpHeaders: [String: String]? = nil) async throws -> Response {
        try await get(path: endpoint.path, httpHeaders: httpHeaders)
    }

}
