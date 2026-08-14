//
//  SequencingHTTPMockClient.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
@testable import TMDb

final class SequencingHTTPMockClient: HTTPClient, @unchecked Sendable {

    private struct QueuedResult {
        let result: Result<HTTPResponse, Error>
        let gate: FetchGate?
    }

    private var results: [QueuedResult] = []
    private var index = 0
    private let lock = NSLock()
    private var performCountStorage = 0
    private var allRequestsStorage: [HTTPRequest] = []

    /// The number of times ``perform(request:)`` has been called.
    ///
    /// Read under the lock rather than directly: a gated result can hold one
    /// request suspended inside `perform` while another runs, so this is read
    /// while a request is in flight.
    var performCount: Int {
        lock.withLock { performCountStorage }
    }

    /// Every request passed to ``perform(request:)``, in arrival order.
    var allRequests: [HTTPRequest] {
        lock.withLock { allRequestsStorage }
    }

    ///
    /// Appends a result to the queue. Results are handed out in arrival order,
    /// one per `perform` call, regardless of which request arrives.
    ///
    /// - Parameters:
    ///   - result: The result returned to the request that dequeues this slot.
    ///   - gate: When non-`nil`, the request taking this slot parks on the gate —
    ///     after being counted and dequeued — until the gate is opened. That
    ///     holds the request *inside* the transport, which is the only way to
    ///     observe behaviour that depends on a response still being in flight.
    ///
    func enqueue(_ result: Result<HTTPResponse, Error>, gate: FetchGate? = nil) {
        lock.withLock {
            results.append(QueuedResult(result: result, gate: gate))
        }
    }

    func perform(request: HTTPRequest) async throws -> HTTPResponse {
        let next: QueuedResult = lock.withLock {
            performCountStorage += 1
            allRequestsStorage.append(request)
            guard index < results.count else {
                preconditionFailure(
                    "No more results enqueued."
                        + " performCount: \(performCountStorage),"
                        + " results.count: \(results.count),"
                        + " index: \(index)"
                )
            }
            let queued = results[index]
            index += 1
            return queued
        }

        // Parked outside the lock — an `NSLock` must never be held across an
        // `await`, and the whole point of the gate is to suspend here.
        await next.gate?.wait()

        return try next.result.get()
    }

}
