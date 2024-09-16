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

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.account))
struct FavouriteSortTests {

    @Test("createdAt default description is created_at.asc")
    func createdAtWhenDefaultReturnsDescription() {
        #expect(FavouriteSort.createdAt().description == "created_at.asc")
    }

    @Test("createdAt ascending description is created_at.asc")
    func createdAtWhenAscendingReturnsDescription() {
        #expect(FavouriteSort.createdAt(descending: false).description == "created_at.asc")
    }

    @Test("createdAt descending description is created_at.desc")
    func createdAtWhenDescendingReturnsDescription() {
        #expect(FavouriteSort.createdAt(descending: true).description == "created_at.desc")
    }

}
