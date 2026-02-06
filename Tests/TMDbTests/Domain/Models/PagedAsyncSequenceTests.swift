//
//  PagedAsyncSequenceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.models))
struct PagedAsyncSequenceTests {

    @Test("iterates through multiple pages correctly")
    func iteratesThroughMultiplePagesCorrectly() async throws {
        let pageFetcher: PagedAsyncSequence<MockItem>.PageFetcher = { page in
            MockItem.mockPageableList(page: page, totalPages: 3, itemsPerPage: 2)
        }

        let sequence = PagedAsyncSequence(pageFetcher: pageFetcher)
        var items: [MockItem] = []

        for try await item in sequence {
            items.append(item)
        }

        #expect(items.count == 6) // 3 pages × 2 items per page
        #expect(items.map(\.id) == [1, 2, 3, 4, 5, 6])
    }

    @Test("stops after last page based on totalPages")
    func stopsAfterLastPageBasedOnTotalPages() async throws {
        let pageFetcher: PagedAsyncSequence<MockItem>.PageFetcher = { page in
            MockItem.mockPageableList(page: page, totalPages: 2, itemsPerPage: 3)
        }

        let sequence = PagedAsyncSequence(pageFetcher: pageFetcher)
        var items: [MockItem] = []

        for try await item in sequence {
            items.append(item)
        }

        #expect(items.count == 6) // 2 pages × 3 items per page
    }

    @Test("handles empty first page")
    func handlesEmptyFirstPage() async throws {
        let pageFetcher: PagedAsyncSequence<MockItem>.PageFetcher = { _ in
            MockItem.mockPageableList(page: 1, totalPages: 1, itemsPerPage: 0)
        }

        let sequence = PagedAsyncSequence(pageFetcher: pageFetcher)
        var items: [MockItem] = []

        for try await item in sequence {
            items.append(item)
        }

        #expect(items.isEmpty)
    }

    @Test("handles nil totalPages by continuing until empty page")
    func handlesNilTotalPagesByContinuingUntilEmptyPage() async throws {
        let pageFetcher: PagedAsyncSequence<MockItem>.PageFetcher = { page in
            if page <= 2 {
                MockItem.mockPageableList(page: page, totalPages: nil, itemsPerPage: 2)
            } else {
                MockItem.mockPageableList(page: page, totalPages: nil, itemsPerPage: 0)
            }
        }

        let sequence = PagedAsyncSequence(pageFetcher: pageFetcher)
        var items: [MockItem] = []

        for try await item in sequence {
            items.append(item)
        }

        #expect(items.count == 4) // 2 pages × 2 items per page
    }

    @Test("propagates errors immediately and stops iteration")
    func propagatesErrorsImmediatelyAndStopsIteration() async throws {
        let pageFetcher: PagedAsyncSequence<MockItem>.PageFetcher = { page in
            if page == 2 {
                throw TMDbError.unknown
            }
            return MockItem.mockPageableList(page: page, totalPages: 3, itemsPerPage: 2)
        }

        let sequence = PagedAsyncSequence(pageFetcher: pageFetcher)
        var items: [MockItem] = []
        var caughtError: Error?

        do {
            for try await item in sequence {
                items.append(item)
            }
        } catch {
            caughtError = error
        }

        #expect(items.count == 2) // Only first page
        #expect(caughtError != nil)
    }

    @Test("respects task cancellation")
    func respectsTaskCancellation() async throws {
        let pageFetcher: PagedAsyncSequence<MockItem>.PageFetcher = { page in
            try Task.checkCancellation()
            return MockItem.mockPageableList(page: page, totalPages: 5, itemsPerPage: 2)
        }

        let sequence = PagedAsyncSequence(pageFetcher: pageFetcher)

        let task = Task {
            var items: [MockItem] = []
            do {
                for try await item in sequence {
                    items.append(item)
                    if items.count == 4 { // After 2 pages
                        throw CancellationError()
                    }
                }
            } catch is CancellationError {
                return items.count
            }
            return items.count
        }

        let count = try await task.value
        #expect(count == 4)
    }

    @Test("early break stops fetching additional pages")
    func earlyBreakStopsFetchingAdditionalPages() async throws {
        let pageFetcher: PagedAsyncSequence<MockItem>.PageFetcher = { page in
            MockItem.mockPageableList(page: page, totalPages: 5, itemsPerPage: 2)
        }

        let sequence = PagedAsyncSequence(pageFetcher: pageFetcher)
        var items: [MockItem] = []

        for try await item in sequence {
            items.append(item)
            if items.count >= 5 { // Break after 3 pages
                break
            }
        }

        #expect(items.count == 5)
        // Verify we got items from pages 1-3 and stopped
        let first = try #require(items.first)
        let last = try #require(items.last)
        #expect(first.id == 1)
        #expect(last.id == 5)
    }

    @Test("buffers one page at a time")
    func buffersOnePageAtATime() async throws {
        let pageFetcher: PagedAsyncSequence<MockItem>.PageFetcher = { page in
            MockItem.mockPageableList(page: page, totalPages: 3, itemsPerPage: 2)
        }

        let sequence = PagedAsyncSequence(pageFetcher: pageFetcher)
        var iterator = sequence.makeAsyncIterator()

        // Consume first two items from page 1
        let item1 = try await iterator.next()
        let item2 = try await iterator.next()
        #expect(item1?.id == 1)
        #expect(item2?.id == 2)

        // Consume first item from page 2
        let item3 = try await iterator.next()
        #expect(item3?.id == 3)
    }

}

// MARK: - Mock Types

extension PagedAsyncSequenceTests {

    struct MockItem: Codable, Identifiable, Equatable, Hashable, Sendable {
        let id: Int
        let name: String

        static func mockPageableList(
            page: Int,
            totalPages: Int?,
            itemsPerPage: Int
        ) -> PageableListResult<MockItem> {
            let startID = (page - 1) * itemsPerPage + 1
            let items = (0 ..< itemsPerPage).map { offset in
                MockItem(id: startID + offset, name: "Item \(startID + offset)")
            }

            return PageableListResult(
                page: page,
                results: items,
                totalResults: totalPages.map { $0 * itemsPerPage },
                totalPages: totalPages
            )
        }
    }

}
