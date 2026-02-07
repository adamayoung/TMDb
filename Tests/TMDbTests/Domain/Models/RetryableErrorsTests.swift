//
//  RetryableErrorsTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite
struct RetryableErrorsTests {

    @Test("rateLimit has raw value 1")
    func rateLimitRawValue() {
        #expect(RetryableErrors.rateLimit.rawValue == 1)
    }

    @Test("serverErrors has raw value 2")
    func serverErrorsRawValue() {
        #expect(RetryableErrors.serverErrors.rawValue == 2)
    }

    @Test("contains rateLimit in combined set")
    func containsRateLimitInCombinedSet() {
        let errors: RetryableErrors = [.rateLimit, .serverErrors]

        #expect(errors.contains(.rateLimit))
    }

    @Test("contains serverErrors in combined set")
    func containsServerErrorsInCombinedSet() {
        let errors: RetryableErrors = [.rateLimit, .serverErrors]

        #expect(errors.contains(.serverErrors))
    }

    @Test("rateLimit only does not contain serverErrors")
    func rateLimitOnlyDoesNotContainServerErrors() {
        let errors: RetryableErrors = .rateLimit

        #expect(!errors.contains(.serverErrors))
    }

    @Test("serverErrors only does not contain rateLimit")
    func serverErrorsOnlyDoesNotContainRateLimit() {
        let errors: RetryableErrors = .serverErrors

        #expect(!errors.contains(.rateLimit))
    }

    @Test("empty set contains neither")
    func emptySetContainsNeither() {
        let errors: RetryableErrors = []

        #expect(!errors.contains(.rateLimit))
        #expect(!errors.contains(.serverErrors))
    }

}
