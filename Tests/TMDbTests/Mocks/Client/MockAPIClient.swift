@testable import TMDb
import XCTest

#if canImport(Combine)
import Combine
#endif

class MockAPIClient: APIClient {

    static var apiKey: String?

    var result: Result<Any, TMDbError>?
    private(set) var lastPath: URL?
    private(set) var lastHTTPHeaders: [String: String]?

    static func setAPIKey(_ apiKey: String) {
        Self.apiKey = apiKey
    }

    func get<Response>(path: URL, httpHeaders: [String: String]?,
                       completion: @escaping (Result<Response, TMDbError>) -> Void) where Response: Decodable {
        self.lastPath = path
        self.lastHTTPHeaders = httpHeaders

        guard let result = result else {
            XCTFail("No result set.")
            completion(.failure(.unknown))
            return
        }

        DispatchQueue.main.async {
            do {
                guard let value = try result.get() as? Response else {
                    XCTFail("Can't cast response to type \(String(describing: Response.self))")
                    completion(.failure(.unknown))
                    return
                }

                return completion(.success(value))
            } catch let error as TMDbError {
                return completion(.failure(error))
            } catch {
                return completion(.failure(.unknown))
            }
        }
    }

#if canImport(Combine)
    func get<Response: Decodable>(path: URL, httpHeaders: [String: String]?) -> AnyPublisher<Response, TMDbError> {
        self.lastPath = path
        self.lastHTTPHeaders = httpHeaders

        guard let result = result else {
            return Empty()
                .setFailureType(to: TMDbError.self)
                .eraseToAnyPublisher()
        }

        do {
            guard let value = try result.get() as? Response else {
                XCTFail("Can't cast response to type \(String(describing: Response.self))")
                return Fail(error: .unknown)
                    .eraseToAnyPublisher()
            }

            return Just(value)
                .setFailureType(to: TMDbError.self)
                .eraseToAnyPublisher()
        } catch let error as TMDbError {
            return Fail(error: error)
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: .unknown)
                .eraseToAnyPublisher()
        }
    }
#endif

#if swift(>=5.5)
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    func get<Response: Decodable>(path: URL, httpHeaders: [String: String]?) async throws -> Response {
        self.lastPath = path
        self.lastHTTPHeaders = httpHeaders

        guard let result = result else {
            throw TMDbError.unknown
        }

        do {
            guard let value = try result.get() as? Response else {
                XCTFail("Can't cast response to type \(String(describing: Response.self))")
                throw TMDbError.unknown
            }

            return value
        } catch let error as TMDbError {
            throw error
        } catch {
            throw TMDbError.unknown
        }
    }
#endif

    func reset() {
        result = nil
        lastPath = nil
        lastHTTPHeaders = nil
    }

}
