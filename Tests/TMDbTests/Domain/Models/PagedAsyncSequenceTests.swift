//
//  PagedAsyncSequenceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

// swiftlint:disable type_body_length

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

    @Test("handles unknown totalPages by continuing until empty page")
    func handlesUnknownTotalPagesByContinuingUntilEmptyPage() async throws {
        let pageFetcher: PagedAsyncSequence<MockItem>.PageFetcher = { page in
            if page <= 2 {
                MockItem.mockPageableList(page: page, totalPages: 0, itemsPerPage: 2)
            } else {
                MockItem.mockPageableList(page: page, totalPages: 0, itemsPerPage: 0)
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

    // MARK: - Prefetch

    @Test("prefetchingNextPage yields the same items as the serial sequence")
    func prefetchYieldsSameItemsAsSerial() async throws {
        let pageFetcher: PagedAsyncSequence<MockItem>.PageFetcher = { page in
            MockItem.mockPageableList(page: page, totalPages: 3, itemsPerPage: 2)
        }

        let sequence = PagedAsyncSequence(pageFetcher: pageFetcher).prefetchingNextPage()
        var items: [MockItem] = []

        for try await item in sequence {
            items.append(item)
        }

        #expect(items.map(\.id) == [1, 2, 3, 4, 5, 6])
    }

    @Test("prefetchingNextPage fetches the next page before its items are requested")
    func prefetchFetchesNextPageEarly() async throws {
        let (stream, continuation) = AsyncStream<Int>.makeStream()
        let pageFetcher: PagedAsyncSequence<MockItem>.PageFetcher = { page in
            continuation.yield(page)
            return MockItem.mockPageableList(page: page, totalPages: 3, itemsPerPage: 2)
        }

        let sequence = PagedAsyncSequence(pageFetcher: pageFetcher).prefetchingNextPage()
        var iterator = sequence.makeAsyncIterator()

        _ = try await iterator.next() // item 1 — page 1 fetched on demand
        _ = try await iterator.next() // item 2 (last of page 1) — triggers prefetch of page 2

        // Page 2 must have started fetching even though page 2's items were never requested.
        var fetched: [Int] = []
        var streamIterator = stream.makeAsyncIterator()
        try fetched.append(#require(await streamIterator.next()))
        try fetched.append(#require(await streamIterator.next()))

        #expect(fetched == [1, 2])
    }

    @Test("prefetchingNextPage does not fetch past the terminating empty page (unknown total)")
    func prefetchStopsAtEmptyPageWithUnknownTotal() async throws {
        let recorder = PageFetchRecorder()
        let pageFetcher: PagedAsyncSequence<MockItem>.PageFetcher = { page in
            await recorder.recordStart(page)
            if page <= 2 {
                return MockItem.mockPageableList(page: page, totalPages: 0, itemsPerPage: 2)
            }
            return MockItem.mockPageableList(page: page, totalPages: 0, itemsPerPage: 0)
        }

        let sequence = PagedAsyncSequence(pageFetcher: pageFetcher).prefetchingNextPage()
        var items: [MockItem] = []

        for try await item in sequence {
            items.append(item)
        }

        #expect(items.count == 4) // pages 1-2, 2 items each
        #expect(await recorder.count == 3) // pages 1, 2, 3 (empty terminator) — never page 4
        #expect(await recorder.startedPages.sorted() == [1, 2, 3])
    }

    @Test("prefetchingNextPage overshoots an early break by at most one page")
    func prefetchEarlyBreakOvershootsByAtMostOnePage() async throws {
        let recorder = PageFetchRecorder()
        let pageFetcher: PagedAsyncSequence<MockItem>.PageFetcher = { page in
            await recorder.recordStart(page)
            return MockItem.mockPageableList(page: page, totalPages: 5, itemsPerPage: 2)
        }

        let sequence = PagedAsyncSequence(pageFetcher: pageFetcher).prefetchingNextPage()
        var items: [MockItem] = []

        for try await item in sequence {
            items.append(item)
            if items.count == 2 { // consumed all of page 1
                break
            }
        }

        // A serial scan fetches 1 page here; prefetch overshoots by at most one.
        await Task.yield()
        let fetchCount = await recorder.count
        #expect(fetchCount >= 1)
        #expect(fetchCount <= 2)
    }

    @Test("prefetchingNextPage surfaces a prefetched page's error when it is consumed")
    func prefetchErrorSurfacesOnConsumption() async throws {
        let pageFetcher: PagedAsyncSequence<MockItem>.PageFetcher = { page in
            if page == 2 {
                throw TMDbError.unknown
            }
            return MockItem.mockPageableList(page: page, totalPages: 3, itemsPerPage: 2)
        }

        let sequence = PagedAsyncSequence(pageFetcher: pageFetcher).prefetchingNextPage()
        var items: [MockItem] = []
        var caughtError: Error?

        do {
            for try await item in sequence {
                items.append(item)
            }
        } catch {
            caughtError = error
        }

        #expect(items.count == 2) // page 1 fully consumed before the error surfaces
        #expect(caughtError != nil)
    }

    @Test("prefetchingNextPage cancels the in-flight prefetch when the consumer is cancelled")
    func prefetchCancellationPropagates() async throws {
        let recorder = PageFetchRecorder()
        let (started, startedContinuation) = AsyncStream<Void>.makeStream()
        let pageFetcher: PagedAsyncSequence<MockItem>.PageFetcher = { page in
            if page == 2 {
                startedContinuation.yield(())
                do {
                    try await Task.sleep(for: .seconds(5)) // block until cancelled
                } catch {
                    await recorder.recordCancellation(2) // the forwarded cancel reached the prefetch
                    throw error
                }
            }
            return MockItem.mockPageableList(page: page, totalPages: 5, itemsPerPage: 2)
        }

        let sequence = PagedAsyncSequence(pageFetcher: pageFetcher).prefetchingNextPage()

        let task = Task {
            var count = 0
            for try await _ in sequence {
                count += 1
            }
            return count
        }

        // Wait until page 2's prefetch is in flight and the consumer is awaiting it, then cancel.
        var startedIterator = started.makeAsyncIterator()
        _ = await startedIterator.next()
        for _ in 0 ..< 5 {
            await Task.yield()
        }
        task.cancel()

        await #expect(throws: CancellationError.self) {
            _ = try await task.value
        }
        // The forwarding (withTaskCancellationHandler) must have cancelled the in-flight prefetch,
        // not just thrown via the pre-await cancellation check.
        #expect(await recorder.wasCancelled(2))
    }

    @Test("default item-level sequence does not prefetch the next page")
    func defaultDoesNotPrefetch() async throws {
        let recorder = PageFetchRecorder()
        let pageFetcher: PagedAsyncSequence<MockItem>.PageFetcher = { page in
            await recorder.recordStart(page)
            return MockItem.mockPageableList(page: page, totalPages: 3, itemsPerPage: 2)
        }

        let sequence = PagedAsyncSequence(pageFetcher: pageFetcher) // no prefetch
        var iterator = sequence.makeAsyncIterator()

        _ = try await iterator.next() // item 1 — page 1 fetched
        _ = try await iterator.next() // item 2 (last of page 1) — must NOT prefetch

        await Task.yield()
        #expect(await recorder.count == 1) // only page 1 fetched
    }

}

// MARK: - Mock Types

extension PagedAsyncSequenceTests {

    struct MockItem: Codable, Identifiable, Equatable, Hashable {
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

// swiftlint:enable type_body_length
