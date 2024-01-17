//
//  TMDbAPIErrorHTTPStatusCodeTests.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

@testable import TMDb
import XCTest

final class TMDbAPIErrorHTTPStatusCodeTests: XCTestCase {

    func testBadRequest() {
        let statusCode = 400
        let expectedMessage = "Some error message"

        let error = TMDbAPIError(statusCode: statusCode, message: expectedMessage)

        switch error {
        case let .badRequest(message):
            XCTAssertEqual(message, expectedMessage)

        default:
            XCTFail("Error does not match")
        }
    }

    func testUnauthorised() {
        let statusCode = 401
        let expectedMessage = "Some error message"

        let error = TMDbAPIError(statusCode: statusCode, message: expectedMessage)

        switch error {
        case let .unauthorised(message):
            XCTAssertEqual(message, expectedMessage)

        default:
            XCTFail("Error does not match")
        }
    }

    func testForbidden() {
        let statusCode = 403
        let expectedMessage = "Some error message"

        let error = TMDbAPIError(statusCode: statusCode, message: expectedMessage)

        switch error {
        case let .forbidden(message):
            XCTAssertEqual(message, expectedMessage)

        default:
            XCTFail("Error does not match")
        }
    }

    func testNotFound() {
        let statusCode = 404
        let expectedMessage = "Some error message"

        let error = TMDbAPIError(statusCode: statusCode, message: expectedMessage)

        switch error {
        case let .notFound(message):
            XCTAssertEqual(message, expectedMessage)

        default:
            XCTFail("Error does not match")
        }
    }

    func testMethodNotAllowed() {
        let statusCode = 405
        let expectedMessage = "Some error message"

        let error = TMDbAPIError(statusCode: statusCode, message: expectedMessage)

        switch error {
        case let .methodNotAllowed(message):
            XCTAssertEqual(message, expectedMessage)

        default:
            XCTFail("Error does not match")
        }
    }

    func testNotAcceptable() {
        let statusCode = 406
        let expectedMessage = "Some error message"

        let error = TMDbAPIError(statusCode: statusCode, message: expectedMessage)

        switch error {
        case let .notAcceptable(message):
            XCTAssertEqual(message, expectedMessage)

        default:
            XCTFail("Error does not match")
        }
    }

    func testUnprocessableContent() {
        let statusCode = 422
        let expectedMessage = "Some error message"

        let error = TMDbAPIError(statusCode: statusCode, message: expectedMessage)

        switch error {
        case let .unprocessableContent(message):
            XCTAssertEqual(message, expectedMessage)

        default:
            XCTFail("Error does not match")
        }
    }

    func testTooManyRequests() {
        let statusCode = 429
        let expectedMessage = "Some error message"

        let error = TMDbAPIError(statusCode: statusCode, message: expectedMessage)

        switch error {
        case let .tooManyRequests(message):
            XCTAssertEqual(message, expectedMessage)

        default:
            XCTFail("Error does not match")
        }
    }

    func testInternalServerError() {
        let statusCode = 500
        let expectedMessage = "Some error message"

        let error = TMDbAPIError(statusCode: statusCode, message: expectedMessage)

        switch error {
        case let .internalServerError(message):
            XCTAssertEqual(message, expectedMessage)

        default:
            XCTFail("Error does not match")
        }
    }

    func testNotImplemented() {
        let statusCode = 501
        let expectedMessage = "Some error message"

        let error = TMDbAPIError(statusCode: statusCode, message: expectedMessage)

        switch error {
        case let .notImplemented(message):
            XCTAssertEqual(message, expectedMessage)

        default:
            XCTFail("Error does not match")
        }
    }

    func testBadGateway() {
        let statusCode = 502
        let expectedMessage = "Some error message"

        let error = TMDbAPIError(statusCode: statusCode, message: expectedMessage)

        switch error {
        case let .badGateway(message):
            XCTAssertEqual(message, expectedMessage)

        default:
            XCTFail("Error does not match")
        }
    }

    func testServiceUnavailable() {
        let statusCode = 503
        let expectedMessage = "Some error message"

        let error = TMDbAPIError(statusCode: statusCode, message: expectedMessage)

        switch error {
        case let .serviceUnavailable(message):
            XCTAssertEqual(message, expectedMessage)

        default:
            XCTFail("Error does not match")
        }
    }

    func testGatewayTimeout() {
        let statusCode = 504
        let expectedMessage = "Some error message"

        let error = TMDbAPIError(statusCode: statusCode, message: expectedMessage)

        switch error {
        case let .gatewayTimeout(message):
            XCTAssertEqual(message, expectedMessage)

        default:
            XCTFail("Error does not match")
        }
    }

    func testUnknown() {
        let statusCode = 999

        let error = TMDbAPIError(statusCode: statusCode, message: nil)

        switch error {
        case .unknown:
            XCTAssertTrue(true)

        default:
            XCTFail("Error does not match")
        }
    }

}
