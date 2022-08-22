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
