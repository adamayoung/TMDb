import Foundation
@testable import TMDb

final class TMDbURLProtocol: URLProtocol {

    private static var testURLs = [String: String]()

    static func add(_ mockName: String, for endpoint: Endpoint) {
        testURLs["/3\(endpoint.path.path)"] = mockName
    }

    static func reset() {
        testURLs = [:]
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

        guard let mockName = Self.testURLs[url.path] else {
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

        guard let data = data else {
            let response = HTTPURLResponse(url: url, statusCode: 404, httpVersion: "2.0", headerFields: nil)!
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            self.client?.urlProtocolDidFinishLoading(self)
            return
        }

        self.client?.urlProtocol(self, didLoad: data)
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "2.0", headerFields: nil)!
        self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() { }

}
