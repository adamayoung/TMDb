//
//  RetryConfigurationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite
struct RetryConfigurationTests {

    @Test("default values are correct")
    func defaultValues() {
        let config = RetryConfiguration()

        #expect(config.maxRetries == 3)
        #expect(config.initialDelay == .seconds(1))
        #expect(config.maxDelay == .seconds(30))
        #expect(config.retryableErrors == [.rateLimit, .serverErrors])
    }

    @Test("custom values are stored")
    func customValues() {
        let config = RetryConfiguration(
            maxRetries: 5,
            initialDelay: .seconds(2),
            maxDelay: .seconds(60),
            retryableErrors: .rateLimit
        )

        #expect(config.maxRetries == 5)
        #expect(config.initialDelay == .seconds(2))
        #expect(config.maxDelay == .seconds(60))
        #expect(config.retryableErrors == .rateLimit)
    }

    @Test("negative maxRetries is clamped to zero")
    func negativeMaxRetriesClamped() {
        let config = RetryConfiguration(maxRetries: -5)

        #expect(config.maxRetries == 0)
    }

    @Test("zero maxRetries is allowed")
    func zeroMaxRetries() {
        let config = RetryConfiguration(maxRetries: 0)

        #expect(config.maxRetries == 0)
    }

    @Test("default static returns default configuration")
    func defaultStaticConfiguration() {
        let config = RetryConfiguration.default

        #expect(config.maxRetries == 3)
        #expect(config.initialDelay == .seconds(1))
        #expect(config.maxDelay == .seconds(30))
        #expect(config.retryableErrors == [.rateLimit, .serverErrors])
    }

    @Test("equatable returns true for equal configurations")
    func equatableEqual() {
        let config1 = RetryConfiguration(maxRetries: 2, initialDelay: .seconds(1))
        let config2 = RetryConfiguration(maxRetries: 2, initialDelay: .seconds(1))

        #expect(config1 == config2)
    }

    @Test("equatable returns false for different configurations")
    func equatableNotEqual() {
        let config1 = RetryConfiguration(maxRetries: 2)
        let config2 = RetryConfiguration(maxRetries: 5)

        #expect(config1 != config2)
    }

    @Test("hashable produces same hash for equal configurations")
    func hashableEqual() {
        let config1 = RetryConfiguration()
        let config2 = RetryConfiguration()

        #expect(config1.hashValue == config2.hashValue)
    }

}
