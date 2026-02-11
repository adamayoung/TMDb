//
//  CacheConfigurationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite
struct CacheConfigurationTests {

    @Test("default values are correct")
    func defaultValues() {
        let config = CacheConfiguration()

        #expect(config.defaultTTL == .seconds(3600))
        #expect(config.maximumEntryCount == 100)
    }

    @Test("custom values are stored")
    func customValues() {
        let config = CacheConfiguration(
            defaultTTL: .seconds(600),
            maximumEntryCount: 50
        )

        #expect(config.defaultTTL == .seconds(600))
        #expect(config.maximumEntryCount == 50)
    }

    @Test("maximumEntryCount is clamped to at least 1")
    func maximumEntryCountClamped() {
        let config = CacheConfiguration(maximumEntryCount: 0)

        #expect(config.maximumEntryCount == 1)
    }

    @Test("negative maximumEntryCount is clamped to 1")
    func negativeMaximumEntryCountClamped() {
        let config = CacheConfiguration(maximumEntryCount: -10)

        #expect(config.maximumEntryCount == 1)
    }

    @Test("negative defaultTTL is clamped to zero")
    func negativeDefaultTTLClamped() {
        let config = CacheConfiguration(defaultTTL: .seconds(-10))

        #expect(config.defaultTTL == .zero)
    }

    @Test("maximumEntryCount of 1 is allowed")
    func maximumEntryCountOfOne() {
        let config = CacheConfiguration(maximumEntryCount: 1)

        #expect(config.maximumEntryCount == 1)
    }

    @Test("default static returns default configuration")
    func defaultStaticConfiguration() {
        let config = CacheConfiguration.default

        #expect(config.defaultTTL == .seconds(3600))
        #expect(config.maximumEntryCount == 100)
    }

    @Test("equatable returns true for equal configurations")
    func equatableEqual() {
        let config1 = CacheConfiguration(defaultTTL: .seconds(600), maximumEntryCount: 50)
        let config2 = CacheConfiguration(defaultTTL: .seconds(600), maximumEntryCount: 50)

        #expect(config1 == config2)
    }

    @Test("equatable returns false for different configurations")
    func equatableNotEqual() {
        let config1 = CacheConfiguration(defaultTTL: .seconds(600))
        let config2 = CacheConfiguration(defaultTTL: .seconds(1200))

        #expect(config1 != config2)
    }

    @Test("hashable produces same hash for equal configurations")
    func hashableEqual() {
        let config1 = CacheConfiguration()
        let config2 = CacheConfiguration()

        #expect(config1.hashValue == config2.hashValue)
    }

}
