@testable import TMDb
import XCTest

final class AccountServiceTests: XCTestCase {

    var service: AccountService!
    var apiClient: MockAPIClient!
    var session: Session!

    override func setUp() {
        super.setUp()
        session = Session(success: true, sessionID: "abc123")
        apiClient = MockAPIClient()
        service = AccountService(apiClient: apiClient)
    }

    override func tearDown() {
        service = nil
        apiClient = nil
        session = nil
        super.tearDown()
    }

    func testDetailsReturnsAccountDetails() async throws {
        let expectedResult = AccountDetails.mock()
        apiClient.addResponse(.success(expectedResult))

        let result = try await service.details(session: session)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastRequestURL, AccountEndpoint.details(session: session).path)
        XCTAssertEqual(apiClient.lastRequestMethod, .get)
    }

    func testDetailsWhenErrorThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        var error: Error?
        do {
            _ = try await service.details(session: session)
        } catch let err {
            error = err
        }

        let tmdbAPIError = try XCTUnwrap(error as? TMDbError)

        XCTAssertEqual(tmdbAPIError, .unknown)
    }

}
