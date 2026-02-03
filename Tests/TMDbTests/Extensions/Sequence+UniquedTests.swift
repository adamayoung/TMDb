//
//  Sequence+UniquedTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite
struct SequenceUniquedTests {

    @Test("uniqued with all distinct IDs returns original")
    func uniquedWithAllDistinctIDsReturnsOriginal() {
        let items: [Item] = [
            .init(), .init(), .init(), .init(), .init(), .init()
        ]

        let result = items.uniqued()

        #expect(result == items)
    }

    @Test("uniqued with all duplicate IDs returns unique list")
    func uniquedWithAllDuplicateIDsReturnsUniqueList() {
        let duplicateID = UUID()
        let item1 = Item()
        let item2 = Item(id: duplicateID)
        let item3 = Item()
        let item4 = Item(id: duplicateID)
        let item5 = Item()
        let items = [item1, item2, item3, item4, item5]
        let expectedResult = [item1, item2, item3, item5]

        let result = items.uniqued()

        #expect(result == expectedResult)
    }

}

extension SequenceUniquedTests {

    struct Item: Hashable, Identifiable {

        let id: UUID

        init(id: UUID = .init()) {
            self.id = id
        }

    }

}
