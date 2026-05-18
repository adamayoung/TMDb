//
//  IntegrationGateTrait.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Testing

/// A trait that runs at most one decorated test at a time across the whole
/// test run.
///
/// Applied to every integration suite so that calls to the live, rate-limited
/// TMDb API never exceed one in-flight request, regardless of how the runner
/// schedules suites in parallel.
struct IntegrationGateTrait: TestTrait, SuiteTrait, TestScoping {

    func provideScope(
        for _: Test,
        testCase _: Test.Case?,
        performing function: @Sendable () async throws -> Void
    ) async throws {
        await IntegrationGate.shared.acquire()
        defer { Task { await IntegrationGate.shared.release() } }
        try await function()
    }

}

extension Trait where Self == IntegrationGateTrait {

    /// Serialises every annotated test across the entire test run.
    static var integrationGate: Self {
        IntegrationGateTrait()
    }

}

actor IntegrationGate {

    static let shared = IntegrationGate()

    private var busy = false
    private var waiters: [CheckedContinuation<Void, Never>] = []

    func acquire() async {
        if !busy {
            busy = true
            return
        }
        await withCheckedContinuation { continuation in
            waiters.append(continuation)
        }
    }

    func release() {
        if waiters.isEmpty {
            busy = false
            return
        }
        let next = waiters.removeFirst()
        next.resume()
    }

}
