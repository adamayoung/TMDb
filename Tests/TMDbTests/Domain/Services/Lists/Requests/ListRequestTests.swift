//
//  ListRequestTests.swift
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

@Suite(.tags(.requests, .list))
struct ListRequestTests {

    @Test("path is correct")
    func path() {
        let request = ListRequest(id: 123, page: nil)

        #expect(request.path == "/list/123")
    }

    @Test("queryItems with no page")
    func queryItemsWithNoPage() {
        let request = ListRequest(id: 123, page: nil)

        #expect(request.queryItems.isEmpty)
    }

    @Test("queryItems with page parameter")
    func queryItemsWithPageParameter() {
        let request = ListRequest(id: 123, page: 2)

        #expect(request.queryItems == ["page": "2"])
    }

    @Test("method is GET")
    func methodIsGet() {
        let request = ListRequest(id: 123, page: nil)

        #expect(request.method == .get)
    }

    @Test("headers is empty")
    func headersIsEmpty() {
        let request = ListRequest(id: 123, page: nil)

        #expect(request.headers.isEmpty)
    }

    @Test("body is nil")
    func bodyIsNil() {
        let request = ListRequest(id: 123, page: nil)

        #expect(request.body == nil)
    }

}
