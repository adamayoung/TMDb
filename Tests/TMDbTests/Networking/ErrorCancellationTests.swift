//
//  ErrorCancellationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

@Suite(.tags(.networking))
struct ErrorCancellationTests {

    @Test("CancellationError is a task cancellation regardless of task state")
    func cancellationErrorIsTaskCancellation() {
        // `CancellationError` is only ever raised by the cancellation machinery,
        // so it needs no corroboration from `Task.isCancelled`.
        #expect(CancellationError().isTaskCancellation)
    }

    @Test("URLError cancelled on a cancelled task is a task cancellation")
    func urlErrorCancelledOnCancelledTaskIsTaskCancellation() async {
        let task = Task { () -> Bool in
            // Cancelled below before this is read.
            while !Task.isCancelled {
                await Task.yield()
            }

            return URLError(.cancelled).isTaskCancellation
        }

        task.cancel()

        #expect(await task.value)
    }

    @Test("URLError cancelled on a live task is NOT a task cancellation")
    func urlErrorCancelledOnLiveTaskIsNotTaskCancellation() {
        // `URLSession.invalidateAndCancel()` and app teardown also raise
        // `.cancelled` while the calling task is perfectly alive. That is a real
        // failure and must stay `.network`, not be silently swallowed.
        #expect(!URLError(.cancelled).isTaskCancellation)
    }

    @Test("NSURLErrorCancelled NSError on a cancelled task is a task cancellation")
    func nsErrorCancelledOnCancelledTaskIsTaskCancellation() async {
        // The Linux transport hands the completion handler an `NSError` in
        // `NSURLErrorDomain` that does not necessarily bridge to `URLError`, so
        // the predicate must match the domain/code rather than the Swift type.
        let task = Task { () -> Bool in
            while !Task.isCancelled {
                await Task.yield()
            }

            let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorCancelled)
            return error.isTaskCancellation
        }

        task.cancel()

        #expect(await task.value)
    }

    @Test("a non-cancellation URLError is never a task cancellation")
    func timedOutURLErrorIsNotTaskCancellation() async {
        let task = Task { () -> Bool in
            while !Task.isCancelled {
                await Task.yield()
            }

            return URLError(.timedOut).isTaskCancellation
        }

        task.cancel()

        // Cancelled task, but the error is a genuine timeout — must not match.
        #expect(await task.value == false)
    }

    @Test("an unrelated error is never a task cancellation")
    func unrelatedErrorIsNotTaskCancellation() {
        struct SomeError: Error {}

        #expect(!SomeError().isTaskCancellation)
    }

}
