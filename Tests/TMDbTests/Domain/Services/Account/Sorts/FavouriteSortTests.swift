//
//  FavouriteSortTests.swift
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

@Suite(.tags(.account))
struct FavouriteSortTests {

    @Test("createdAt default description is created_at.asc")
    func createdAtWhenDefaultReturnsDescription() {
        let sort = FavouriteSort.createdAt()

        #expect(sort.description == "created_at.asc")
    }

    @Test("createdAt ascending description is created_at.asc")
    func createdAtWhenAscendingReturnsDescription() {
        let sort = FavouriteSort.createdAt(descending: false)

        #expect(sort.description == "created_at.asc")
    }

    @Test("createdAt descending description is created_at.desc")
    func createdAtWhenDescendingReturnsDescription() {
        let sort = FavouriteSort.createdAt(descending: true)

        #expect(sort.description == "created_at.desc")
    }

}
