//
//  URLSessionHTTPClientAdapter.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

final class URLSessionHTTPClientAdapter: HTTPClient {

    private let urlSession: URLSession

    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    func perform(request: HTTPRequest) async throws -> HTTPResponse {
        let urlRequest = Self.urlRequest(from: request)

        let (data, response) = try await perform(urlRequest)

        return Self.httpResponse(from: data, response: response)
    }

}

extension URLSessionHTTPClientAdapter {

    private static func urlRequest(from httpRequest: HTTPRequest) -> URLRequest {
        var urlRequest = URLRequest(url: httpRequest.url)
        urlRequest.httpMethod = httpRequest.method.rawValue
        urlRequest.httpBody = httpRequest.body
        for header in httpRequest.headers {
            urlRequest.addValue(header.value, forHTTPHeaderField: header.key)
        }

        return urlRequest
    }

    private static func httpResponse(from data: Data, response: URLResponse) -> HTTPResponse {
        guard let httpURLResponse = response as? HTTPURLResponse else {
            return HTTPResponse(statusCode: -1, data: nil)
        }

        let statusCode = httpURLResponse.statusCode
        var headers = [String: String]()
        for (key, value) in httpURLResponse.allHeaderFields {
            if let key = key as? String, let value = value as? String {
                headers[key] = value
            }
        }

        return HTTPResponse(statusCode: statusCode, data: data, headers: headers)
    }

}

extension URLSessionHTTPClientAdapter {

    #if canImport(FoundationNetworking)
        // Thread-safe: all access to `task` is guarded by `lock`.
        private final class DataTaskBox: @unchecked Sendable {
            private let lock = NSLock()
            private var task: URLSessionDataTask?

            func store(_ task: URLSessionDataTask) {
                lock.withLock { self.task = task }
            }

            func cancel() {
                lock.withLock { task?.cancel() }
            }
        }

        private func perform(_ urlRequest: URLRequest) async throws -> (Data, URLResponse) {
            let box = DataTaskBox()

            return try await withTaskCancellationHandler {
                try await withCheckedThrowingContinuation { continuation in
                    let dataTask = urlSession.dataTask(with: urlRequest) { data, response, error in
                        if let error {
                            continuation.resume(throwing: error)
                            return
                        }

                        guard let response else {
                            continuation.resume(
                                throwing: NSError(domain: "uk.co.adam-young.TMDb", code: -1)
                            )
                            return
                        }

                        continuation.resume(returning: (data ?? Data(), response))
                    }

                    box.store(dataTask)
                    dataTask.resume()

                    // Handle case where task was already cancelled before
                    // the cancellation handler was registered.
                    if Task.isCancelled {
                        dataTask.cancel()
                    }
                }
            } onCancel: {
                box.cancel()
            }
        }
    #else
        private func perform(_ urlRequest: URLRequest) async throws -> (Data, URLResponse) {
            try await urlSession.data(for: urlRequest)
        }
    #endif

}
