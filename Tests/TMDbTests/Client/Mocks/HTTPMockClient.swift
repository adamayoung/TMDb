@testable import TMDb
import XCTest

final class HTTPMockClient: HTTPClient {

    var result: Result<HTTPResponse, Error>?
    var requestTime: UInt64 = 0
    private(set) var lastURL: URL?
    private(set) var lastHeaders: [String: String]?
    private(set) var getCount = 0

    func get(url: URL, headers: [String: String]) async throws -> HTTPResponse {
        self.lastURL = url
        self.lastHeaders = headers
        self.getCount += 1

        if requestTime > 0 {
            try await Task.sleep(nanoseconds: requestTime * 1_000_000_000)
        }

        guard let result else {
            throw NSError(domain: "HTTPMockClient", code: -1)
        }

        return try result.get()
    }

    func reset() {
        result = nil
        lastURL = nil
        lastHeaders = nil
        getCount = 0
    }

}
