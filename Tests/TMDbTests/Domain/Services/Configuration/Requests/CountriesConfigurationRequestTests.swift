//
//  CountriesConfigurationRequestTests.swift
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

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.requests, .configuration))
struct CountriesConfigurationRequestTests {

    @Test("path is correct")
    func path() {
        let request = CountriesConfigurationRequest()

        #expect(request.path == "/configuration/countries")
    }

    @Test("queryItems is empty")
    func queryItemsIsEmpty() {
        let request = CountriesConfigurationRequest()

        #expect(request.queryItems.isEmpty)
    }

    @Test("queryItems with language")
    func queryItemsWithLanguage() {
        let request = CountriesConfigurationRequest(language: "en")

        #expect(request.queryItems == ["language": "en"])
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = CountriesConfigurationRequest()

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = CountriesConfigurationRequest()

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = CountriesConfigurationRequest()

        #expect(request.body == nil)
    }

}
