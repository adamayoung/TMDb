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

        try await validate(data: data, response: response)

        let decodedResponse: Response
        do {
            decodedResponse = try await serialiser.decode(Response.self, from: data)
        } catch let error {
            throw TMDbError.decode(error)
        }

        return decodedResponse
    }

}

extension TMDbAPIClient {

    private func buildURLRequest(for path: URL) -> URLRequest {
        let url = urlFromPath(path)
        var urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        return urlRequest
    }

    private func urlFromPath(_ path: URL) -> URL {
        guard var urlComponents = URLComponents(url: path, resolvingAgainstBaseURL: true) else {
            return path
        }

        urlComponents.scheme = baseURL.scheme
        urlComponents.host = baseURL.host
        urlComponents.path = "\(baseURL.path)\(urlComponents.path)"

        return urlComponents.url!
            .appendingAPIKey(apiKey)
            .appendingLanguage()
    }

    private func validate(data: Data, response: URLResponse) async throws {
        guard let httpURLResponse = response as? HTTPURLResponse else {
            return
        }

        let statusCode = httpURLResponse.statusCode
        if (200...299).contains(statusCode) {
            return
        }

        let statusResponse = try? await serialiser.decode(TMDbStatusResponse.self, from: data)
        let message = statusResponse?.statusMessage

        throw TMDbError(statusCode: statusCode, message: message)
    }

}
