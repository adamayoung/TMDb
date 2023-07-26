import Foundation

final class TMDbAPIClient: APIClient {

    private let apiKey: String
    private let baseURL: URL
    private let httpClient: HTTPClient
    private let serialiser: Serialiser

    init(apiKey: String, baseURL: URL, httpClient: HTTPClient, serialiser: Serialiser) {
        self.apiKey = apiKey
        self.baseURL = baseURL
        self.httpClient = httpClient
        self.serialiser = serialiser
    }

    func get<Response: Decodable>(path: URL) async throws -> Response {
        let url = urlFromPath(path)
        let headers = [
            "Accept": "application/json"
        ]

        let response: HTTPResponse

        do {
            response = try await httpClient.get(url: url, headers: headers)
        } catch {
            throw TMDbError.network(error)
        }

        try await validate(response: response)

        guard let data = response.data else {
            throw TMDbError.unknown
        }

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

    private func validate(response: HTTPResponse) async throws {
        let statusCode = response.statusCode
        if (200...299).contains(statusCode) {
            return
        }

        guard let data = response.data else {
            throw TMDbError(statusCode: statusCode, message: nil)
        }

        let statusResponse = try? await serialiser.decode(TMDbStatusResponse.self, from: data)
        let message = statusResponse?.statusMessage

        throw TMDbError(statusCode: statusCode, message: message)
    }

}
