//
//  PagedAsyncSequenceCancellationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

///
/// Cancellation semantics of the item-level auto-pagination sequence.
///
/// Split from `PagedAsyncSequenceTests` to keep both files under the 400-line
/// limit. `MockItem` is shared from there.
///
@Suite(.tags(.models))
struct PagedAsyncSequenceCancellationTests {

    private typealias MockItem = PagedAsyncSequenceTests.MockItem

    @Test("next throws TMDbError.cancelled when the task is cancelled")
    func nextThrowsCancelledWhenTaskIsCancelled() async throws {
        let pageFetcher: PagedAsyncSequence<MockItem>.PageFetcher = { page in
            MockItem.mockPageableList(page: page, totalPages: 5, itemsPerPage: 2)
        }
        let sequence = PagedAsyncSequence(pageFetcher: pageFetcher)

        let task = Task { () -> Error? in
            while !Task.isCancelled {
                await Task.yield()
            }

            do {
                var iterator = sequence.makeAsyncIterator()
                _ = try await iterator.next()
                return nil
            } catch {
                return error
            }
        }

        task.cancel()

        let error = try #require(await task.value)

        #expect(error as? TMDbError == .cancelled)
    }

    @Test("a cancelled consumer stops receiving buffered items")
    func cancelledConsumerStopsReceivingBufferedItems() async throws {
        // The cancellation check used to sit *after* the buffer fast path, so a
        // cancelled consumer kept being handed up to a full page of already
        // fetched items before it learned anything was wrong.
        let pageFetcher: PagedAsyncSequence<MockItem>.PageFetcher = { page in
            MockItem.mockPageableList(page: page, totalPages: 5, itemsPerPage: 10)
        }
        let sequence = PagedAsyncSequence(pageFetcher: pageFetcher)

        var iterator = sequence.makeAsyncIterator()

        // Fill the buffer with page 1 (10 items) by taking the first.
        _ = try await iterator.next()

        let task = Task { [iterator] () -> Error? in
            var iterator = iterator
            while !Task.isCancelled {
                await Task.yield()
            }

            do {
                _ = try await iterator.next()
                return nil
            } catch {
                return error
            }
        }

        task.cancel()

        let error = try #require(await task.value)

        #expect(error as? TMDbError == .cancelled)
    }

}
