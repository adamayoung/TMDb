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
        // `self.`-qualified throughout for the same reason as `resume(_:)` below —
        // the parameter is already named `continuation`, so an unqualified
        // property access here would be ambiguous to a reader even where it is
        // unambiguous to the compiler.
        let value: Value? = lock.withLock {
            guard !self.hasResumed else {
                return nil
            }

            guard let pending = self.pendingValue else {
                self.continuation = continuation
                return nil
            }

            self.hasResumed = true
            self.pendingValue = nil
            return pending
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
        // The result is named `waiting`, not `continuation`: a local of the same
        // name as the stored property shadows it *inside its own initialiser*, so
        // `guard let continuation` below would bind the uninitialised local
        // rather than `self.continuation`. That read is undefined behaviour — it
        // happened to see `nil` on Darwin and garbage on Linux, where it
        // segfaulted in `swift_retain`. Every property access here is explicitly
        // `self.`-qualified so the binding cannot be misread again.
        let waiting: CheckedContinuation<Value, Never>? = lock.withLock {
            guard !self.hasResumed else {
                return nil
            }

            guard let attached = self.continuation else {
                // Beat the continuation here; `attach` will deliver it. Latched,
                // so a second pre-attach producer cannot overwrite the first —
                // otherwise "first call wins" would silently become "last wins"
                // in exactly the window where the race is hardest to observe.
                if self.pendingValue == nil {
                    self.pendingValue = value
                }
                return nil
            }

            self.hasResumed = true
            self.continuation = nil
            return attached
        }

        waiting?.resume(returning: value)
    }

}
