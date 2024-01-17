//
//  Sequence+UniquedTests.swift
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

final class SequenceUniquedTests: XCTestCase {

    func testUniquedWithAllDistinctIDsReturnsOriginal() {
        let items: [Item] = [
            .init(), .init(), .init(), .init(), .init(), .init()
        ]

        let result = items.uniqued()

        XCTAssertEqual(result, items)
    }

    func testUniquedWithAllDuplicateIDsReturnsUniqueList() {
        let duplicateID = UUID()
        let item1 = Item()
        let item2 = Item(id: duplicateID)
        let item3 = Item()
        let item4 = Item(id: duplicateID)
        let item5 = Item()
        let items = [item1, item2, item3, item4, item5]
        let expectedResult = [item1, item2, item3, item5]

        let result = items.uniqued()

        XCTAssertEqual(result, expectedResult)
    }

}

private extension SequenceUniquedTests {

    struct Item: Hashable, Identifiable {

        let id: UUID

        init(id: UUID = .init()) {
            self.id = id
        }

    }

}
