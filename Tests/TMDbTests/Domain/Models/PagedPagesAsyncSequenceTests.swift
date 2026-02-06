//
//  PagedPagesAsyncSequenceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

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

}

// MARK: - Mock Types

extension PagedPagesAsyncSequenceTests {

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
