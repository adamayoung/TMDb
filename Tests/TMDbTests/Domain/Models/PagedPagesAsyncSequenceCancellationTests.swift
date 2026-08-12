//
//  PagedPagesAsyncSequenceCancellationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

///
/// Cancellation semantics of the page-level auto-pagination sequence.
///
/// Split from `PagedPagesAsyncSequenceTests` to keep both files under the
/// 400-line limit. `MockItem` is shared from there.
///
@Suite(.tags(.models))
struct PagedPagesAsyncSequenceCancellationTests {

    private typealias MockItem = PagedPagesAsyncSequenceTests.MockItem

    @Test("next throws TMDbError.cancelled when the task is cancelled")
    func nextThrowsCancelledWhenTaskIsCancelled() async throws {
        let pageFetcher: PagedPagesAsyncSequence<MockItem>.PageFetcher = { page in
            MockItem.mockPageableList(page: page, totalPages: 5, itemsPerPage: 2)
        }
        let sequence = PagedPagesAsyncSequence(pageFetcher: pageFetcher)

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

}
