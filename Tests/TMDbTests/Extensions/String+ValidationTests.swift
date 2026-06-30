//
//  String+ValidationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

struct StringValidationTests {

    @Test("non-empty string passes validation")
    func nonEmptyStringPasses() throws {
        try "hello".validateNotEmpty(message: "must not be empty")
    }

    @Test("string with surrounding whitespace but real content passes")
    func paddedContentPasses() throws {
        try "  hello  ".validateNotEmpty(message: "must not be empty")
    }

    @Test("empty string throws badRequest with the message")
    func emptyStringThrowsBadRequest() {
        #expect(throws: TMDbError.badRequest("must not be empty")) {
            try "".validateNotEmpty(message: "must not be empty")
        }
    }

    @Test("whitespace-only string throws badRequest with the message")
    func whitespaceStringThrowsBadRequest() {
        #expect(throws: TMDbError.badRequest("must not be empty")) {
            try "  \t\n ".validateNotEmpty(message: "must not be empty")
        }
    }

}
