//
//  ShowWatchProvidersByCountryTests.swift
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

@Suite(.tags(.models))
struct ShowWatchProvidersByCountryTests {

    @Test("init creates object with correct values")
    func initCreatesObjectWithCorrectValues() {
        let countryCode = "US"
        let watchProviders = ShowWatchProvider.mock()

        let result = ShowWatchProvidersByCountry(
            countryCode: countryCode,
            watchProviders: watchProviders
        )

        #expect(result.countryCode == countryCode)
        #expect(result.watchProviders == watchProviders)
    }

    @Test("equatable returns true for equal objects")
    func equatableEqual() {
        let object1 = ShowWatchProvidersByCountry(
            countryCode: "US",
            watchProviders: .mock()
        )
        let object2 = ShowWatchProvidersByCountry(
            countryCode: "US",
            watchProviders: .mock()
        )

        #expect(object1 == object2)
    }

    @Test("equatable returns false for different country codes")
    func equatableNotEqualCountryCode() {
        let object1 = ShowWatchProvidersByCountry(
            countryCode: "US",
            watchProviders: .mock()
        )
        let object2 = ShowWatchProvidersByCountry(
            countryCode: "GB",
            watchProviders: .mock()
        )

        #expect(object1 != object2)
    }

    @Test("hashable produces consistent hash values")
    func hashableConsistent() {
        let object = ShowWatchProvidersByCountry(
            countryCode: "US",
            watchProviders: .mock()
        )

        var hasher1 = Hasher()
        object.hash(into: &hasher1)
        let hash1 = hasher1.finalize()

        var hasher2 = Hasher()
        object.hash(into: &hasher2)
        let hash2 = hasher2.finalize()

        #expect(hash1 == hash2)
    }

}
