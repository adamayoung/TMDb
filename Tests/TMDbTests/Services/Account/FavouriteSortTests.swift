//
//  FavouriteSortTests.swift
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

final class FavouriteSortTests: XCTestCase {

    func testCreatedAtWhenDefaultReturnsDescription() {
        XCTAssertEqual(FavouriteSort.createdAt().description, "created_at.asc")
    }

    func testCreatedAtWhenAscendingReturnsDescription() {
        XCTAssertEqual(FavouriteSort.createdAt(descending: false).description, "created_at.asc")
    }

    func testCreatedAtWhenDescendingReturnsDescription() {
        XCTAssertEqual(FavouriteSort.createdAt(descending: true).description, "created_at.desc")
    }

    func testURLAppendingSortByWhenNilReturnsOriginalURL() throws {
        let sort: FavouriteSort? = nil
        let expectedURL = try XCTUnwrap(URL(string: "/some/path"))

        let url = URL(string: "/some/path")?.appendingSortBy(sort)

        XCTAssertEqual(url, expectedURL)
    }

    func testURLAppendingSortByReturnsURL() throws {
        let sort: FavouriteSort? = .createdAt()
        let expectedURL = try XCTUnwrap(URL(string: "/some/path?sort_by=created_at.asc"))

        let url = URL(string: "/some/path")?.appendingSortBy(sort)

        XCTAssertEqual(url, expectedURL)
    }

}
