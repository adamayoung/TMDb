//
//  TMDbConfigurationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite
struct TMDbConfigurationTests {

    @Test("init with default values creates configuration with nil values")
    func initWithDefaultValues() {
        let configuration = TMDbConfiguration()

        #expect(configuration.defaultLanguage == nil)
        #expect(configuration.defaultCountry == nil)
    }

    @Test("init with language creates configuration with language")
    func initWithLanguage() {
        let configuration = TMDbConfiguration(defaultLanguage: "en-US")

        #expect(configuration.defaultLanguage == "en-US")
        #expect(configuration.defaultCountry == nil)
    }

    @Test("init with country creates configuration with country")
    func initWithCountry() {
        let configuration = TMDbConfiguration(defaultCountry: "US")

        #expect(configuration.defaultLanguage == nil)
        #expect(configuration.defaultCountry == "US")
    }

    @Test("init with language and country creates configuration with both")
    func initWithLanguageAndCountry() {
        let configuration = TMDbConfiguration(defaultLanguage: "es-ES", defaultCountry: "ES")

        #expect(configuration.defaultLanguage == "es-ES")
        #expect(configuration.defaultCountry == "ES")
    }

    @Test("default returns configuration with nil values")
    func defaultConfiguration() {
        let configuration = TMDbConfiguration.default

        #expect(configuration.defaultLanguage == nil)
        #expect(configuration.defaultCountry == nil)
    }

    @Test("system returns configuration with current locale language")
    func systemLanguage() {
        let configuration = TMDbConfiguration.system

        #expect(configuration.defaultLanguage == Locale.current.language.minimalIdentifier)
    }

    @Test("system returns configuration with current locale country")
    func systemCountry() {
        let configuration = TMDbConfiguration.system

        #expect(configuration.defaultCountry == Locale.current.region?.identifier)
    }

    @Test("system returns nil country when locale has no region")
    func systemCountryNilWhenNoRegion() {
        let localeWithoutRegion = Locale(identifier: "en")

        #expect(localeWithoutRegion.region == nil)
        #expect(localeWithoutRegion.region?.identifier == nil)
    }

    @Test("equatable returns true for equal configurations")
    func equatableEqual() {
        let configuration1 = TMDbConfiguration(defaultLanguage: "en", defaultCountry: "US")
        let configuration2 = TMDbConfiguration(defaultLanguage: "en", defaultCountry: "US")

        #expect(configuration1 == configuration2)
    }

    @Test("equatable returns false for different configurations")
    func equatableNotEqual() {
        let configuration1 = TMDbConfiguration(defaultLanguage: "en", defaultCountry: "US")
        let configuration2 = TMDbConfiguration(defaultLanguage: "es", defaultCountry: "ES")

        #expect(configuration1 != configuration2)
    }

}
