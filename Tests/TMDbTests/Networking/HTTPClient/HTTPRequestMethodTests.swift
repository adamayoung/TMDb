//
//  HTTPRequestMethodTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.networking))
struct HTTPRequestMethodTests {

    @Test("get method should be equal to \"GET\"")
    func getMethod() {
        #expect(HTTPRequest.Method.get.rawValue == "GET")
    }

    @Test("post method should be equal to \"POST\"")
    func postMethod() {
        #expect(HTTPRequest.Method.post.rawValue == "POST")
    }

    @Test("delete method should be equal to \"DELETE\"")
    func deleteMethod() {
        #expect(HTTPRequest.Method.delete.rawValue == "DELETE")
    }

}
