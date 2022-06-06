import Foundation

final class TMDbAPIClient: APIClient {

    private let urlSession: URLSession
    private let jsonDecoder: JSONDecoder

    private(set) var apiKey: String = ""

    static let shared = TMDbAPIClient()

    public static func setAPIKey(_ apiKey: String) {
        shared.setAPIKey(apiKey)
    }

    init(urlSession: URLSession = URLSession(configuration: .default), jsonDecoder: JSONDecoder = .theMovieDatabase) {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
    }

    func setAPIKey(_ apiKey: String) {
        self.apiKey = apiKey
    }

    func get<Response: Decodable>(path: URL, httpHeaders: [String: String]?) async throws -> Response {
        let urlRequest = buildURLRequest(for: path, httpHeaders: httpHeaders)

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await urlSession.data(for: urlRequest)
        } catch {
            throw TMDbError.network(error)
        }

        if let tmdbError = TMDbError(response: response) {
            throw tmdbError
        }

        let decodedResponse: Response
        do {
            decodedResponse = try jsonDecoder.decode(Response.self, from: data)
        } catch let error {
            throw TMDbError.decode(error)
        }

        return decodedResponse
    }

}

extension TMDbAPIClient {

    private func buildURLRequest(for path: URL, httpHeaders: [String: String]?) -> URLRequest {
        let url = urlFromPath(path)
        var urlRequest = URLRequest(url: url)

        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        httpHeaders?.forEach { (key: String, value: String) in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }

        return urlRequest
    }

    private func urlFromPath(_ path: URL) -> URL {
        guard var urlComponents = URLComponents(url: path, resolvingAgainstBaseURL: true) else {
            return path
        }

        urlComponents.scheme = URL.tmdbAPIBaseURL.scheme
        urlComponents.host = URL.tmdbAPIBaseURL.host
        urlComponents.path = URL.tmdbAPIBaseURL.path + "\(urlComponents.path)"

        return urlComponents.url!
            .appendingAPIKey(apiKey)
            .appendingLanguage()
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
