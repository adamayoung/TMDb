//
//  CancellationIntegrationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

///
/// Proves the *real* transport cancellation shape reaches consumers as
/// ``TMDbError/cancelled``.
///
/// Unit tests inject a Swift `URLError` or an `NSError`, which cannot show what
/// `URLSession` genuinely raises. Only a live request can.
///
/// Every test cancels **before** awaiting rather than mid-flight. A mid-flight
/// cancel races the live API — a fast response commits before the cancel lands —
/// and the weekly scheduled Integration run opens a PR on failure, so a racy
/// test here would manufacture spurious work. Cancelling first is deterministic
/// on both the Darwin `data(for:)` path and the Linux continuation path, whose
/// `if Task.isCancelled { dataTask.cancel() }` re-check exists for exactly this.
///
@Suite(
    .integrationGate,
    .serialized,
    .tags(.cancellation),
    .enabled(if: CredentialHelper.shared.hasAPIKey),
    .timeLimit(.minutes(1))
)
struct CancellationIntegrationTests {

    var client: TMDbClient!

    init() throws {
        self.client = CredentialHelper.shared.makeClient()
    }

    @Test("a cancelled request throws cancelled, not network")
    func cancelledRequestThrowsCancelled() async throws {
        let client = try #require(client)

        let task = Task { () -> TMDbError? in
            do throws(TMDbError) {
                _ = try await client.movies.details(forMovie: 550)
                return nil
            } catch {
                return error
            }
        }

        task.cancel()

        let error = try #require(await task.value)

        #expect(error == .cancelled)
    }

    @Test("a cancelled auto-pagination scan throws cancelled")
    func cancelledPaginationThrowsCancelled() async throws {
        let client = try #require(client)

        let task = Task { () -> Error? in
            do {
                for try await _ in client.movies.allTopRated() {
                    // Cancelled before the first element is ever produced.
                }
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
