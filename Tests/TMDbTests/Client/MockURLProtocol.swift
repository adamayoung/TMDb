import Foundation

final class MockURLProtocol: URLProtocol {

    static var data: Data?
    static var failError: Error?
    static var responseStatusCode: Int = 200
    static private(set) var lastRequest: URLRequest?

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        lastRequest = request
        return request
    }

    override func startLoading() {
        if let failError = Self.failError {
            self.client?.urlProtocol(self, didFailWithError: failError)
            return
        }

        guard let url = request.url else {
            return
        }

        if let data = Self.data {
            self.client?.urlProtocol(self, didLoad: data)
        }

        let response = HTTPURLResponse(url: url, statusCode: Self.responseStatusCode, httpVersion: "2.0",
                                       headerFields: nil)!
        self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() { }

    static func reset() {
        data = nil
        failError = nil
        responseStatusCode = 200
        lastRequest = nil
    }

}
