//
//  LocaleProviderTests.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
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

@testable import TMDb
import XCTest

final class LocaleProviderTests: XCTestCase {

    var provider: LocaleProvider!
    var locale: Locale!

    override func setUp() {
        super.setUp()
        locale = Locale(identifier: "en_GB")
        provider = LocaleProvider(locale: locale)
    }

    override func tearDown() {
        provider = nil
        locale = nil
        super.tearDown()
    }

    func testLanguageCode() {
        let expectedLanguageCode: String? = {
            #if os(Linux)
                return locale.languageCode
            #else
                if #available(macOS 13.0, *) {
                    return locale.language.languageCode?.identifier
                } else {
                    return locale.languageCode
                }
            #endif
        }()

        XCTAssertEqual(provider.languageCode, expectedLanguageCode)
    }

    func testRegion() {
        let expectedRegionCode: String? = {
            #if os(Linux)
                return locale.regionCode
            #else
                if #available(macOS 13.0, *) {
                    return locale.region?.identifier
                } else {
                    return locale.regionCode
                }
            #endif
        }()

        XCTAssertEqual(provider.regionCode, expectedRegionCode)
    }

}
