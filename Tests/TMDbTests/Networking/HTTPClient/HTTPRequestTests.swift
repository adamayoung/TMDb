//
//  File.swift
//  
//
//  Created by Adam Young on 17/05/2024.
//

@testable import TMDb
import XCTest

final class HTTPRequestTests: XCTestCase {

    func testIgnoresCacheDefaultValue() throws {
        let url = try XCTUnwrap(URL(string: "https://some.domain/endpoint"))

        let request = HTTPRequest(url: url)

        XCTAssertFalse(request.ignoresCache)
    }

}
