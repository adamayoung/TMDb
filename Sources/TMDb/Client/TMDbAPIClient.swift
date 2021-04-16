import Foundation

#if canImport(Combine)
import Combine
#endif

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

final class TMDbAPIClient: APIClient {

    private static let baseURL = URL(string: "https://api.themoviedb.org/3")!

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

}

extension TMDbAPIClient {

    #if canImport(Combine)
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func get<Response: Decodable>(path: URL,
                                  httpHeaders: [String: String]? = nil) -> AnyPublisher<Response, TMDbError> {
        let urlRequest = buildURLRequest(for: path, httpHeaders: httpHeaders)

        return urlSession.dataTaskPublisher(for: urlRequest)
            .mapTMDbError()
            .mapResponse(to: Response.self, decoder: jsonDecoder)
            .eraseToAnyPublisher()
    }
    #endif

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

        urlComponents.scheme = Self.baseURL.scheme
        urlComponents.host = Self.baseURL.host
        urlComponents.path = Self.baseURL.path + "\(urlComponents.path)"

        return urlComponents.url!
            .appendingAPIKey(apiKey)
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
