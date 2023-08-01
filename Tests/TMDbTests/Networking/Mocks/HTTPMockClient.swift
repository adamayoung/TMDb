@testable import TMDb
import XCTest

final class HTTPMockClient: HTTPClient {

    var result: Result<HTTPResponse, Error>?
    private(set) var lastURL: URL?
    private(set) var lastHeaders: [String: String]?
    private(set) var getCount = 0

    func get(url: URL, headers: [String: String]) async throws -> HTTPResponse {
        self.lastURL = url
        self.lastHeaders = headers
        self.getCount += 1

        guard let result else {
            preconditionFailure("Result not set.")
        }

        return try result.get()
    }

}
