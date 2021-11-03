import Foundation

#if canImport(Combine)
import Combine
#endif

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

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

    func get<Response: Decodable>(path: URL, httpHeaders: [String: String]?,
                                  completion: @escaping (Result<Response, TMDbError>) -> Void) {
        let urlRequest = buildURLRequest(for: path, httpHeaders: httpHeaders)

        urlSession.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let self = self else {
                return
            }

            if let error = error {
                completion(.failure(.network(error)))
                return
            }

            guard let response = response, let data = data else {
                completion(.failure(.unknown))
                return
            }

            if let tmdbError = TMDbError(response: response) {
                completion(.failure(tmdbError))
                return
            }

            let decodedResponse: Response
            do {
                decodedResponse = try self.jsonDecoder.decode(Response.self, from: data)
            } catch let error {
                completion(.failure(.decode(error)))
                return
            }

            completion(.success(decodedResponse))
        }
        .resume()
    }

}

#if canImport(Combine)
extension TMDbAPIClient {

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func get<Response: Decodable>(path: URL,
                                  httpHeaders: [String: String]? = nil) -> AnyPublisher<Response, TMDbError> {
        let urlRequest = buildURLRequest(for: path, httpHeaders: httpHeaders)

        return urlSession.dataTaskPublisher(for: urlRequest)
            .mapTMDbError()
            .mapResponse(to: Response.self, decoder: jsonDecoder)
            .eraseToAnyPublisher()
    }

}
#endif

#if swift(>=5.5) && !os(Linux)
extension TMDbAPIClient {

    @available(macOS 12, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
    func get<Response: Decodable>(path: URL, httpHeaders: [String: String]?) async throws -> Response {
        let urlRequest = buildURLRequest(for: path, httpHeaders: httpHeaders)

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await withCheckedThrowingContinuation { continuation in
                urlSession.dataTask(with: urlRequest) { data, response, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }

                    guard let data = data, let response = response else {
                        continuation.resume(throwing: TMDbError.unknown)
                        return
                    }

                    continuation.resume(returning: (data, response))
                }
                .resume()
            }
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
#endif

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
