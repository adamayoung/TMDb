//
//  HTTPResponseTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite
struct HTTPResponseTests {

    @Test("default init has empty headers")
    func defaultInitHasEmptyHeaders() {
        let response = HTTPResponse()

        #expect(response.headers.isEmpty)
    }

    @Test("retryAfterDuration returns correct Duration for valid integer string")
    func retryAfterDurationReturnsCorrectDuration() {
        let response = HTTPResponse(headers: ["Retry-After": "5"])

        #expect(response.retryAfterDuration == .seconds(5))
    }

    @Test("retryAfterDuration returns nil when header absent")
    func retryAfterDurationReturnsNilWhenAbsent() {
        let response = HTTPResponse()

        #expect(response.retryAfterDuration == nil)
    }

    @Test("retryAfterDuration returns nil for non-numeric value")
    func retryAfterDurationReturnsNilForNonNumeric() {
        let response = HTTPResponse(headers: ["Retry-After": "abc"])

        #expect(response.retryAfterDuration == nil)
    }

    @Test("retryAfterDuration performs case-insensitive header key lookup")
    func retryAfterDurationCaseInsensitiveLookup() {
        let response = HTTPResponse(headers: ["retry-after": "10"])

        #expect(response.retryAfterDuration == .seconds(10))
    }

    @Test("retryAfterDuration performs case-insensitive header key lookup with mixed case")
    func retryAfterDurationCaseInsensitiveLookupMixedCase() {
        let response = HTTPResponse(headers: ["RETRY-AFTER": "3"])

        #expect(response.retryAfterDuration == .seconds(3))
    }

}
