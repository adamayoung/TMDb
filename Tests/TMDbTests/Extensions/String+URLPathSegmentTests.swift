//
//  String+URLPathSegmentTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

struct StringURLPathSegmentTests {

    @Test("empty string encodes to empty string")
    func emptyStringUnchanged() {
        #expect("".urlPathSegmentEncoded == "")
    }

    @Test("plain alphanumeric identifier is unchanged")
    func plainIdentifierUnchanged() {
        #expect("tt0111161".urlPathSegmentEncoded == "tt0111161")
    }

    @Test("unreserved characters are left unchanged")
    func unreservedCharactersUnchanged() {
        #expect("a-b_c.d~e".urlPathSegmentEncoded == "a-b_c.d~e")
    }

    @Test("question mark is percent-encoded")
    func questionMarkEncoded() {
        #expect("id?injected=x".urlPathSegmentEncoded == "id%3Finjected%3Dx")
    }

    @Test("forward slash is percent-encoded")
    func forwardSlashEncoded() {
        #expect("a/b".urlPathSegmentEncoded == "a%2Fb")
    }

    @Test("space, hash, and path-traversal characters are percent-encoded")
    func otherUnsafeCharactersEncoded() {
        #expect("a b#c".urlPathSegmentEncoded == "a%20b%23c")
        #expect("../x".urlPathSegmentEncoded == "..%2Fx")
    }

}
