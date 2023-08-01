@testable import TMDb
import XCTest

final class MockAPIClient: APIClient {

    static var apiKey: String?

    var result: Result<Any, TMDbAPIError>?
    var requestTime: UInt64 = 0
    private(set) var lastPath: URL?
    private(set) var getCount = 0

    static func setAPIKey(_ apiKey: String) {
        Self.apiKey = apiKey
    }

    func get<Response: Decodable>(path: URL) async throws -> Response {
        self.lastPath = path
        self.getCount += 1

        if requestTime > 0 {
            try await Task.sleep(nanoseconds: requestTime * 1_000_000_000)
        }

        guard let result else {
            throw TMDbAPIError.unknown
        }

        do {
            guard let value = try result.get() as? Response else {
                preconditionFailure("Can't cast response to type \(String(describing: Response.self))")
//                throw TMDbAPIError.unknown
            }

            return value
        } catch let error as TMDbAPIError {
            throw error
        } catch {
            throw TMDbAPIError.unknown
        }
    }

    func reset() {
        result = nil
        lastPath = nil
        getCount = 0
    }

}
