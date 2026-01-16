//
//  TMDbConfigurationTests.swift
//  TMDb
//
//  Copyright © 2025 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
