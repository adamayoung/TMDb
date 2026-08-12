//
//  CreditIntegrationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(
    .integrationGate,
    .serialized,
    .tags(.credit),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct CreditIntegrationTests {

    var creditService: (any CreditService)!

    init() {
        self.creditService = CredentialHelper.shared.makeClient().credits
    }

    @Test("details")
    func details() async throws {
        let creditID = "52542282760ee313280017f9"

        let credit = try await creditService.details(
            forCredit: creditID
        )

        #expect(credit.id == creditID)
        #expect(credit.creditType == .cast)
        #expect(credit.department == "Acting")
        #expect(credit.person.name == "Bryan Cranston")
    }

    /// Deliberately a long-released film: this covers the `CreditMedia` movie
    /// branch, which had no live coverage at all. The empty-`release_date`
    /// regression is locked by the `credit-movie-blank-release-date` fixture
    /// instead — a live credit cannot guard it, because TMDb fills the date in
    /// once the film is dated, and an unreleased title's credit ID is volatile
    /// enough to 404 a gate that runs on every PR.
    @Test("details for a movie credit")
    func detailsForMovieCredit() async throws {
        let creditID = "52fe4250c3a36847f80149f3"

        let credit = try await creditService.details(
            forCredit: creditID
        )

        #expect(credit.id == creditID)
        #expect(credit.creditType == .cast)
        #expect(credit.person.name == "Edward Norton")

        guard case .movie(let movie) = credit.media else {
            Issue.record("Expected movie media type")
            return
        }

        #expect(movie.id == 550)
        #expect(movie.title == "Fight Club")
    }

}
