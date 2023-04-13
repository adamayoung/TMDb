import Foundation
@testable import TMDb

final class TMDbURLProtocol: URLProtocol {

    private static var responseBodyMap = [String: String]()
    private static var responseHTTPStatusMap = [String: Int]()

    static func add(_ mockName: String, for endpoint: Endpoint, httpStatus: Int = 200) {
        let path = "/3\(endpoint.path.path)"
        responseBodyMap[path] = mockName
        responseHTTPStatusMap[path] = httpStatus
    }

    static func reset() {
        responseBodyMap = [:]
        responseHTTPStatusMap = [:]
    }

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let url = request.url else {
            return
        }

        guard let mockName = Self.responseBodyMap[url.path] else {
            let response = HTTPURLResponse(url: url, statusCode: 404, httpVersion: "2.0", headerFields: nil)!
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            self.client?.urlProtocolDidFinishLoading(self)
            return
        }

        let data: Data?
        do {
            data = try Data(fromResource: mockName, withExtension: "json")
        } catch let error {
            self.client?.urlProtocol(self, didFailWithError: error)
            return
        }

        guard let data else {
            let response = HTTPURLResponse(url: url, statusCode: 404, httpVersion: "2.0", headerFields: nil)!
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            self.client?.urlProtocolDidFinishLoading(self)
            return
        }

        let statusCode = Self.responseHTTPStatusMap[url.path] ?? 200

        self.client?.urlProtocol(self, didLoad: data)
        let response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: "2.0", headerFields: nil)!
        self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() { }

}
