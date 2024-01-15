//
//  WikiDataLinkTests.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
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

final class WikiDataLinkTests: XCTestCase {

    func testInitWithWikiDataIDWhenIDIsNilReturnsNil() {
        XCTAssertNil(WikiDataLink(wikiDataID: nil))
    }

    func testURL() throws {
        let wikiDataID = "Q55436290"
        let expectedURL = try XCTUnwrap(URL(string: "https://www.wikidata.org/wiki/\(wikiDataID)"))

        let wikiDataLink = WikiDataLink(wikiDataID: wikiDataID)

        XCTAssertEqual(wikiDataLink?.url, expectedURL)
    }

}
