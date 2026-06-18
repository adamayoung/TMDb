//
//  PagedPagesAsyncSequenceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

// swiftlint:disable type_body_length

@Suite(.tags(.models))
struct PagedPagesAsyncSequenceTests {

    @Test("iterates through multiple pages correctly")
    func iteratesThroughMultiplePagesCorrectly() async throws {
        let pageFetcher: PagedPagesAsyncSequence<MockItem>.PageFetcher = { page in
            MockItem.mockPageableList(page: page, totalPages: 3, itemsPerPage: 2)
        }

        let sequence = PagedPagesAsyncSequence(pageFetcher: pageFetcher)
        var pages: [PageableListResult<MockItem>] = []

        for try await page in sequence {
            pages.append(page)
        }

        #expect(pages.count == 3)
        #expect(pages[0].page == 1)
        #expect(pages[1].page == 2)
        #expect(pages[2].page == 3)
    }

    @Test("stops after last page based on totalPages")
    func stopsAfterLastPageBasedOnTotalPages() async throws {
        let pageFetcher: PagedPagesAsyncSequence<MockItem>.PageFetcher = { page in
            MockItem.mockPageableList(page: page, totalPages: 2, itemsPerPage: 3)
        }

        let sequence = PagedPagesAsyncSequence(pageFetcher: pageFetcher)
        var pages: [PageableListResult<MockItem>] = []

        for try await page in sequence {
            pages.append(page)
        }

        #expect(pages.count == 2)
    }

    @Test("handles empty first page")
    func handlesEmptyFirstPage() async throws {
        let pageFetcher: PagedPagesAsyncSequence<MockItem>.PageFetcher = { _ in
            MockItem.mockPageableList(page: 1, totalPages: 1, itemsPerPage: 0)
        }

        let sequence = PagedPagesAsyncSequence(pageFetcher: pageFetcher)
        var pages: [PageableListResult<MockItem>] = []

        for try await page in sequence {
            pages.append(page)
        }

        #expect(pages.isEmpty)
    }

    @Test("handles nil totalPages by continuing until empty page")
    func handlesNilTotalPagesByContinuingUntilEmptyPage() async throws {
        let pageFetcher: PagedPagesAsyncSequence<MockItem>.PageFetcher = { page in
            if page <= 2 {
                MockItem.mockPageableList(page: page, totalPages: nil, itemsPerPage: 2)
            } else {
                MockItem.mockPageableList(page: page, totalPages: nil, itemsPerPage: 0)
            }
        }

        let sequence = PagedPagesAsyncSequence(pageFetcher: pageFetcher)
        var pages: [PageableListResult<MockItem>] = []

        for try await page in sequence {
            pages.append(page)
        }

        #expect(pages.count == 2) // Only non-empty pages
    }

    @Test("propagates errors immediately and stops iteration")
    func propagatesErrorsImmediatelyAndStopsIteration() async throws {
        let pageFetcher: PagedPagesAsyncSequence<MockItem>.PageFetcher = { page in
            if page == 2 {
                throw TMDbError.unknown
            }
            return MockItem.mockPageableList(page: page, totalPages: 3, itemsPerPage: 2)
        }

        let sequence = PagedPagesAsyncSequence(pageFetcher: pageFetcher)
        var pages: [PageableListResult<MockItem>] = []
        var caughtError: Error?

        do {
            for try await page in sequence {
                pages.append(page)
            }
        } catch {
            caughtError = error
        }

        #expect(pages.count == 1) // Only first page
        #expect(caughtError != nil)
    }

    @Test("respects task cancellation")
    func respectsTaskCancellation() async throws {
        let pageFetcher: PagedPagesAsyncSequence<MockItem>.PageFetcher = { page in
            try Task.checkCancellation()
            return MockItem.mockPageableList(page: page, totalPages: 5, itemsPerPage: 2)
        }

        let sequence = PagedPagesAsyncSequence(pageFetcher: pageFetcher)

        let task = Task {
            var pages: [PageableListResult<MockItem>] = []
            do {
                for try await page in sequence {
                    pages.append(page)
                    if pages.count == 2 {
                        throw CancellationError()
                    }
                }
            } catch is CancellationError {
                return pages.count
            }
            return pages.count
        }

        let count = try await task.value
        #expect(count == 2)
    }

    @Test("early break stops fetching additional pages")
    func earlyBreakStopsFetchingAdditionalPages() async throws {
        let pageFetcher: PagedPagesAsyncSequence<MockItem>.PageFetcher = { page in
            MockItem.mockPageableList(page: page, totalPages: 5, itemsPerPage: 2)
        }

        let sequence = PagedPagesAsyncSequence(pageFetcher: pageFetcher)
        var pages: [PageableListResult<MockItem>] = []

        for try await page in sequence {
            pages.append(page)
            if pages.count >= 3 {
                break
            }
        }

        #expect(pages.count == 3)
        // Verify we fetched pages 1-3 and stopped
        let page1 = try #require(pages.first)
        let page3 = try #require(pages.last)
        #expect(page1.page == 1)
        #expect(page3.page == 3)
    }

    @Test("yields page metadata correctly")
    func yieldsPageMetadataCorrectly() async throws {
        let pageFetcher: PagedPagesAsyncSequence<MockItem>.PageFetcher = { page in
            MockItem.mockPageableList(page: page, totalPages: 2, itemsPerPage: 3)
        }

        let sequence = PagedPagesAsyncSequence(pageFetcher: pageFetcher)
        var pages: [PageableListResult<MockItem>] = []

        for try await page in sequence {
            pages.append(page)
        }

        let firstPage = try #require(pages.first)
        #expect(firstPage.page == 1)
        #expect(firstPage.totalPages == 2)
        #expect(firstPage.totalResults == 6)
        #expect(firstPage.results.count == 3)
    }

    // MARK: - Prefetch

    @Test("prefetchingNextPage yields the same pages as the serial sequence")
    func prefetchYieldsSamePagesAsSerial() async throws {
        let pageFetcher: PagedPagesAsyncSequence<MockItem>.PageFetcher = { page in
            MockItem.mockPageableList(page: page, totalPages: 3, itemsPerPage: 2)
        }

        let sequence = PagedPagesAsyncSequence(pageFetcher: pageFetcher).prefetchingNextPage()
        var pages: [PageableListResult<MockItem>] = []

        for try await page in sequence {
            pages.append(page)
        }

        #expect(pages.map(\.page) == [1, 2, 3])
    }

    @Test("prefetchingNextPage fetches the next page as the current page is yielded")
    func prefetchFetchesNextPageEarly() async throws {
        let (stream, continuation) = AsyncStream<Int>.makeStream()
        let pageFetcher: PagedPagesAsyncSequence<MockItem>.PageFetcher = { page in
            continuation.yield(page)
            return MockItem.mockPageableList(page: page, totalPages: 3, itemsPerPage: 2)
        }

        let sequence = PagedPagesAsyncSequence(pageFetcher: pageFetcher).prefetchingNextPage()
        var iterator = sequence.makeAsyncIterator()

        _ = try await iterator.next() // page 1 yielded — triggers prefetch of page 2

        // Page 2 must have started fetching after a single `next()`.
        var fetched: [Int] = []
        var streamIterator = stream.makeAsyncIterator()
        try fetched.append(#require(await streamIterator.next()))
        try fetched.append(#require(await streamIterator.next()))

        #expect(fetched == [1, 2])
    }

    @Test("prefetchingNextPage overshoots an early break by at most one page")
    func prefetchEarlyBreakOvershootsByAtMostOnePage() async throws {
        let recorder = PageFetchRecorder()
        let pageFetcher: PagedPagesAsyncSequence<MockItem>.PageFetcher = { page in
            await recorder.recordStart(page)
            return MockItem.mockPageableList(page: page, totalPages: 5, itemsPerPage: 2)
        }

        let sequence = PagedPagesAsyncSequence(pageFetcher: pageFetcher).prefetchingNextPage()
        var pages: [PageableListResult<MockItem>] = []

        for try await page in sequence {
            pages.append(page)
            if pages.count == 1 {
                break
            }
        }

        await Task.yield()
        let fetchCount = await recorder.count
        #expect(fetchCount >= 1)
        #expect(fetchCount <= 2)
    }

    @Test("default page-level sequence does not prefetch the next page")
    func defaultDoesNotPrefetch() async throws {
        let recorder = PageFetchRecorder()
        let pageFetcher: PagedPagesAsyncSequence<MockItem>.PageFetcher = { page in
            await recorder.recordStart(page)
            return MockItem.mockPageableList(page: page, totalPages: 3, itemsPerPage: 2)
        }

        let sequence = PagedPagesAsyncSequence(pageFetcher: pageFetcher) // no prefetch
        var iterator = sequence.makeAsyncIterator()

        _ = try await iterator.next() // page 1 — must NOT prefetch page 2

        await Task.yield()
        #expect(await recorder.count == 1)
    }

    @Test("prefetchingNextPage does not fetch past the terminating empty page (unknown total)")
    func prefetchStopsAtEmptyPageWithUnknownTotal() async throws {
        let recorder = PageFetchRecorder()
        let pageFetcher: PagedPagesAsyncSequence<MockItem>.PageFetcher = { page in
            await recorder.recordStart(page)
            if page <= 2 {
                return MockItem.mockPageableList(page: page, totalPages: nil, itemsPerPage: 2)
            }
            return MockItem.mockPageableList(page: page, totalPages: nil, itemsPerPage: 0)
        }

        let sequence = PagedPagesAsyncSequence(pageFetcher: pageFetcher).prefetchingNextPage()
        var pages: [PageableListResult<MockItem>] = []

        for try await page in sequence {
            pages.append(page)
        }

        #expect(pages.count == 2) // pages 1-2 are non-empty
        #expect(await recorder.count == 3) // pages 1, 2, 3 (empty terminator) — never page 4
        #expect(await recorder.startedPages.sorted() == [1, 2, 3])
    }

    @Test("prefetchingNextPage surfaces a prefetched page's error when it is consumed")
    func prefetchErrorSurfacesOnConsumption() async throws {
        let pageFetcher: PagedPagesAsyncSequence<MockItem>.PageFetcher = { page in
            if page == 2 {
                throw TMDbError.unknown
            }
            return MockItem.mockPageableList(page: page, totalPages: 3, itemsPerPage: 2)
        }

        let sequence = PagedPagesAsyncSequence(pageFetcher: pageFetcher).prefetchingNextPage()
        var pages: [PageableListResult<MockItem>] = []
        var caughtError: Error?

        do {
            for try await page in sequence {
                pages.append(page)
            }
        } catch {
            caughtError = error
        }

        #expect(pages.count == 1) // page 1 yielded before the prefetched error surfaces
        #expect(caughtError != nil)
    }

    @Test("prefetchingNextPage cancels the in-flight prefetch when the consumer is cancelled")
    func prefetchCancellationPropagates() async throws {
        let recorder = PageFetchRecorder()
        let (started, startedContinuation) = AsyncStream<Void>.makeStream()
        let pageFetcher: PagedPagesAsyncSequence<MockItem>.PageFetcher = { page in
            if page == 2 {
                startedContinuation.yield(())
                do {
                    try await Task.sleep(for: .seconds(5)) // block until cancelled
                } catch {
                    await recorder.recordCancellation(2)
                    throw error
                }
            }
            return MockItem.mockPageableList(page: page, totalPages: 5, itemsPerPage: 2)
        }

        let sequence = PagedPagesAsyncSequence(pageFetcher: pageFetcher).prefetchingNextPage()

        let task = Task {
            var count = 0
            for try await _ in sequence {
                count += 1
            }
            return count
        }

        var startedIterator = started.makeAsyncIterator()
        _ = await startedIterator.next()
        for _ in 0 ..< 5 {
            await Task.yield()
        }
        task.cancel()

        await #expect(throws: CancellationError.self) {
            _ = try await task.value
        }
        #expect(await recorder.wasCancelled(2))
    }

}

// MARK: - Mock Types

extension PagedPagesAsyncSequenceTests {

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
