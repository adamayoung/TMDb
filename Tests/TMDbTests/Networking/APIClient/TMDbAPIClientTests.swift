@testable import TMDb
import XCTest
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

final class TMDbAPIClientTests: XCTestCase {

    var apiClient: TMDbAPIClient!
    var apiKey: String!
    var baseURL: URL!
    var httpClient: HTTPMockClient!
    var serialiser: Serialiser!
    var locale: Locale!

    override func setUpWithError() throws {
        try super.setUpWithError()
        apiKey = "abc123"
        baseURL = try XCTUnwrap(URL(string: "https://some.domain.com/path"))

        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        httpClient = HTTPMockClient()
        serialiser = Serialiser(decoder: .theMovieDatabase)
        locale = Locale(identifier: "en_GB")
        apiClient = TMDbAPIClient(apiKey: apiKey, baseURL: baseURL, httpClient: httpClient, serialiser: serialiser,
                                  localeProvider: { [unowned self] in self.locale })
    }

    override func tearDown() {
        apiClient = nil
        locale = nil
        serialiser = nil
        httpClient = nil
        baseURL = nil
        apiKey = nil
        super.tearDown()
    }

    func testGetWhenResponseStatusCodeIs401ReturnsUnauthorisedError() async throws {
        httpClient.result = .success(HTTPResponse(statusCode: 401))

        do {
           _ = try await apiClient.get(path: URL(string: "/error")!) as String
        } catch let error as TMDbError {
            switch error {
            case .unauthorised:
                XCTAssertTrue(true)
                return
            default:
                break
            }
        }

        XCTFail("Expected unauthorised error to be thrown")
    }

    func testGetWhenResponseStatusCodeIs404ReturnsNotFoundError() async throws {
        httpClient.result = .success(HTTPResponse(statusCode: 404))

        do {
           _ = try await apiClient.get(path: URL(string: "/error")!) as String
        } catch let error as TMDbError {
            switch error {
            case .notFound:
                XCTAssertTrue(true)
                return
            default:
                break
            }
        }

        XCTFail("Expected not found error to be thrown")
    }

    func testGetWhenResponseStatusCodeIs404AndHasStatusMessageErrorThrowsNotFoundErrorWithMessage() async throws {
        let expectedStatusMessage = "The resource you requested could not be found."
        let statusResponse = try Data(fromResource: "error-status-response", withExtension: "json")
        httpClient.result = .success(HTTPResponse(statusCode: 404, data: statusResponse))

        do {
           _ = try await apiClient.get(path: URL(string: "/error")!) as String
        } catch let error as TMDbError {
            switch error {
            case .notFound(let message):
                XCTAssertEqual(message, expectedStatusMessage)
                return

            default:
                break
            }
        }

        XCTFail("Expected unknown error to be thrown")
    }

    func testGetWhenResponseHasValidDataReturnsDecodedObject() async throws {
        let expectedResult = MockObject()
        httpClient.result = .success(HTTPResponse(data: expectedResult.data))

        let result: MockObject = try await apiClient.get(path: URL(string: "/object")!)

        XCTAssertEqual(result, expectedResult)
    }

    func testGetURLRequestAcceptHeaderSetToApplicationJSON() async throws {
        let expectedResult = "application/json"

        _ = try? await apiClient.get(path: URL(string: "/object")!) as String

        let result = httpClient.lastHeaders?["Accept"]

        XCTAssertEqual(result, expectedResult)
    }

    func testGetURLRequestHasCorrectURL() async throws {
        let path = "/object"
        let language = "en"
        let urlString = "\(baseURL.absoluteURL)\(path)?api_key=\(apiKey!)&language=\(language)"
        let expectedResult = try XCTUnwrap(URL(string: urlString))

        _ = try? await apiClient.get(path: URL(string: path)!) as String

        let result = httpClient.lastURL

        XCTAssertEqual(result, expectedResult)
    }

}

extension TMDbAPIClientTests {

    private struct MockObject: Codable, Equatable {

        let id: UUID

        var data: Data {
            // swiftlint:disable force_try
            try! JSONEncoder().encode(self)
            // swiftlint:enable force_try
        }

        init(id: UUID = .init()) {
            self.id = id
        }
    }

}
