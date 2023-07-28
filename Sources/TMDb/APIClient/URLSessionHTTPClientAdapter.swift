import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

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
            (data, response) = try await perform(urlRequest)
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

extension URLSessionHTTPClientAdapter {

    #if canImport(FoundationNetworking)
    private func perform(_ urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        return try await withCheckedThrowingContinuation { continuation in
            urlSession.dataTask(with: urlRequest) { data, response, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                guard let data, let response else {
                    continuation.resume(throwing: NSError(domain: "uk.co.adam-young.TMDb", code: -1))
                    return
                }

                continuation.resume(returning: (data, response))
            }
            .resume()
        }
    }
    #else
    private func perform(_ urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        try await urlSession.data(for: urlRequest)
    }
    #endif

}
