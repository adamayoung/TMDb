//
//  FavouriteSortTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
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
