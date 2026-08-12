//
//  ResumeOnce.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A one-shot handoff that resumes a continuation exactly once, whichever of two
/// racing producers arrives first.
///
/// Lets a single awaiter of a **shared** `Task` abandon its wait without
/// cancelling that task: the awaiter's own observer delivers the shared result,
/// a cancellation handler delivers `.cancelled`, and this box guarantees only
/// the first of them resumes the continuation.
///
/// `@unchecked Sendable` safety invariant: every mutable property is read and
/// written only inside `lock`, and `CheckedContinuation.resume(returning:)` is
/// always called **outside** it — resuming while holding a lock can re-enter the
/// awaiting code on the same thread and deadlock.
///
/// A lock rather than an `actor` because the cancellation handler passed to
/// `withTaskCancellationHandler` is a **synchronous**, nonisolated closure: it
/// cannot `await` a hop onto an actor. Hopping asynchronously instead would make
/// cancellation delivery race the shared task's completion — the difference
/// between a deterministic test and a flaky one. This mirrors `DataTaskBox` in
/// `URLSessionHTTPClientAdapter`.
///
final class ResumeOnce<Value: Sendable>: @unchecked Sendable {

    private let lock = NSLock()
    private var continuation: CheckedContinuation<Value, Never>?
    private var pendingValue: Value?
    private var hasResumed = false

    init() {}

    ///
    /// Supplies the continuation to resume.
    ///
    /// Resumes immediately when a value already arrived — which happens when the
    /// task was cancelled before the continuation was installed, so the
    /// cancellation handler ran first.
    ///
    /// - Parameter continuation: The continuation awaiting a value.
    ///
    func attach(_ continuation: CheckedContinuation<Value, Never>) {
        let value: Value? = lock.withLock {
            guard !hasResumed else {
                return nil
            }

            guard let pendingValue else {
                self.continuation = continuation
                return nil
            }

            hasResumed = true
            self.pendingValue = nil
            return pendingValue
        }

        guard let value else {
            return
        }

        continuation.resume(returning: value)
    }

    ///
    /// Delivers a value, resuming the continuation if one is attached.
    ///
    /// Every call after the first is a no-op, so racing producers are safe.
    ///
    /// - Parameter value: The value to deliver.
    ///
    func resume(_ value: Value) {
        let continuation: CheckedContinuation<Value, Never>? = lock.withLock {
            guard !hasResumed else {
                return nil
            }

            guard let continuation else {
                // Beat the continuation here; `attach` will deliver it. Latched,
                // so a second pre-attach producer cannot overwrite the first —
                // otherwise "first call wins" would silently become "last wins"
                // in exactly the window where the race is hardest to observe.
                if pendingValue == nil {
                    pendingValue = value
                }
                return nil
            }

            hasResumed = true
            self.continuation = nil
            return continuation
        }

        continuation?.resume(returning: value)
    }

}
