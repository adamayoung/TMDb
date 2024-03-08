//
//  File.swift
//  
//
//  Created by Adam Young on 08/03/2024.
//

@testable import TMDb
import XCTest

final class HTTPRequestMethodTests: XCTestCase {

    func testGetMethod() {
        XCTAssertEqual(HTTPRequest.Method.get.rawValue, "GET")
    }

    func testPostMethod() {
        XCTAssertEqual(HTTPRequest.Method.post.rawValue, "POST")
    }

    func testDeleteMethod() {
        XCTAssertEqual(HTTPRequest.Method.delete.rawValue, "DELETE")
    }

}
