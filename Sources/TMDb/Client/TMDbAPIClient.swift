import Foundation

final actor TMDbAPIClient: APIClient {

    private let apiKey: String
    private let baseURL: URL
    private let urlSession: URLSession
    private let serialiser: Serialiser

    init(apiKey: String, baseURL: URL, urlSession: URLSession, serialiser: Serialiser) {
        self.apiKey = apiKey
        self.baseURL = baseURL
        self.urlSession = urlSession
        self.serialiser = serialiser
    }

    func get<Response: Decodable>(path: URL) async throws -> Response {
        let urlRequest = buildURLRequest(for: path)

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await urlSession.data(for: urlRequest)
        } catch {
            throw TMDbError.network(error)
        }

        try validate(response: response)
        return try await serialiser.decode(data)
    }

}

extension TMDbAPIClient {

    private func buildURLRequest(for path: URL) -> URLRequest {
        let url = urlFromPath(path)
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        return urlRequest
    }

    private func urlFromPath(_ path: URL) -> URL {
        guard var urlComponents = URLComponents(url: path, resolvingAgainstBaseURL: true) else {
            return path
        }

        urlComponents.scheme = baseURL.scheme
        urlComponents.host = baseURL.host
        urlComponents.path = baseURL.path + "\(urlComponents.path)"

        return urlComponents.url!
            .appendingAPIKey(apiKey)
            .appendingLanguage()
    }

    private func validate(response: URLResponse) throws {
        if let tmdbError = TMDbError(response: response) {
            throw tmdbError
        }
    }

}

private extension TMDbError {

    init?(response: URLResponse) {
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
        guard statusCode != 200 else {
            return nil
        }

        switch statusCode {
        case 401:
            self = .unauthorized

        case 404:
            self = .notFound

        default:
            self = .unknown
        }
    }

}
