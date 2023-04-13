@testable import TMDb
import XCTest

final class TMDbErrorHTTPStatusCodeTests: XCTestCase {

    func testBadRequest() {
        let statusCode = 400
        let expectedMessage = "Some error message"

        let error = TMDbError(statusCode: statusCode, message: expectedMessage)

        switch error {
        case .badRequest(let message):
            XCTAssertEqual(message, expectedMessage)

        default:
            XCTFail("Error does not match")
        }
    }

    func testUnauthorised() {
        let statusCode = 401
        let expectedMessage = "Some error message"

        let error = TMDbError(statusCode: statusCode, message: expectedMessage)

        switch error {
        case .unauthorised(let message):
            XCTAssertEqual(message, expectedMessage)

        default:
            XCTFail("Error does not match")
        }
    }

    func testForbidden() {
        let statusCode = 403
        let expectedMessage = "Some error message"

        let error = TMDbError(statusCode: statusCode, message: expectedMessage)

        switch error {
        case .forbidden(let message):
            XCTAssertEqual(message, expectedMessage)

        default:
            XCTFail("Error does not match")
        }
    }

    func testNotFound() {
        let statusCode = 404
        let expectedMessage = "Some error message"

        let error = TMDbError(statusCode: statusCode, message: expectedMessage)

        switch error {
        case .notFound(let message):
            XCTAssertEqual(message, expectedMessage)

        default:
            XCTFail("Error does not match")
        }
    }

    func testMethodNotAllowed() {
        let statusCode = 405
        let expectedMessage = "Some error message"

        let error = TMDbError(statusCode: statusCode, message: expectedMessage)

        switch error {
        case .methodNotAllowed(let message):
            XCTAssertEqual(message, expectedMessage)

        default:
            XCTFail("Error does not match")
        }
    }

    func testNotAcceptable() {
        let statusCode = 406
        let expectedMessage = "Some error message"

        let error = TMDbError(statusCode: statusCode, message: expectedMessage)

        switch error {
        case .notAcceptable(let message):
            XCTAssertEqual(message, expectedMessage)

        default:
            XCTFail("Error does not match")
        }
    }

    func testUnprocessableContent() {
        let statusCode = 422
        let expectedMessage = "Some error message"

        let error = TMDbError(statusCode: statusCode, message: expectedMessage)

        switch error {
        case .unprocessableContent(let message):
            XCTAssertEqual(message, expectedMessage)

        default:
            XCTFail("Error does not match")
        }
    }

    func testTooManyRequests() {
        let statusCode = 429
        let expectedMessage = "Some error message"

        let error = TMDbError(statusCode: statusCode, message: expectedMessage)

        switch error {
        case .tooManyRequests(let message):
            XCTAssertEqual(message, expectedMessage)

        default:
            XCTFail("Error does not match")
        }
    }

    func testInternalServerError() {
        let statusCode = 500
        let expectedMessage = "Some error message"

        let error = TMDbError(statusCode: statusCode, message: expectedMessage)

        switch error {
        case .internalServerError(let message):
            XCTAssertEqual(message, expectedMessage)

        default:
            XCTFail("Error does not match")
        }
    }

    func testNotImplemented() {
        let statusCode = 501
        let expectedMessage = "Some error message"

        let error = TMDbError(statusCode: statusCode, message: expectedMessage)

        switch error {
        case .notImplemented(let message):
            XCTAssertEqual(message, expectedMessage)

        default:
            XCTFail("Error does not match")
        }
    }

    func testBadGateway() {
        let statusCode = 502
        let expectedMessage = "Some error message"

        let error = TMDbError(statusCode: statusCode, message: expectedMessage)

        switch error {
        case .badGateway(let message):
            XCTAssertEqual(message, expectedMessage)

        default:
            XCTFail("Error does not match")
        }
    }

    func testServiceUnavailable() {
        let statusCode = 503
        let expectedMessage = "Some error message"

        let error = TMDbError(statusCode: statusCode, message: expectedMessage)

        switch error {
        case .serviceUnavailable(let message):
            XCTAssertEqual(message, expectedMessage)

        default:
            XCTFail("Error does not match")
        }
    }

    func testGatewayTimeout() {
        let statusCode = 504
        let expectedMessage = "Some error message"

        let error = TMDbError(statusCode: statusCode, message: expectedMessage)

        switch error {
        case .gatewayTimeout(let message):
            XCTAssertEqual(message, expectedMessage)

        default:
            XCTFail("Error does not match")
        }
    }

    func testUnknown() {
        let statusCode = 999

        let error = TMDbError(statusCode: statusCode, message: nil)

        switch error {
        case .unknown:
            XCTAssertTrue(true)

        default:
            XCTFail("Error does not match")
        }
    }

}
