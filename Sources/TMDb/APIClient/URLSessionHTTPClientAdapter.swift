import Foundation

final class URLSessionHTTPClientAdapter: HTTPClient {

    private let urlSession: URLSession

    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    func get(url: URL, headers: [String: String]) async throws -> HTTPResponse {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        for header in headers {
            urlRequest.addValue(header.value, forHTTPHeaderField: header.key)
        }

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await urlSession.data(for: urlRequest)
        } catch let error {
            throw error
        }

        guard let httpURLResponse = response as? HTTPURLResponse else {
            return HTTPResponse(statusCode: -1, data: nil)
        }

        let statusCode = httpURLResponse.statusCode
        return HTTPResponse(statusCode: statusCode, data: data)
    }

}
