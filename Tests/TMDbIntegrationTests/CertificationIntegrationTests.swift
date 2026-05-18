//
//  CertificationIntegrationTests.swift
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
    .tags(.certification),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct CertificationIntegrationTests {

    var certificationService: (any CertificationService)!

    init() {
        self.certificationService = CredentialHelper.shared.makeClient().certifications
    }

    @Test("movieCertifications")
    func testMovieCertifications() async throws {
        let certifications = try await certificationService.movieCertifications()

        let gbCertifications = try #require(certifications["GB"])

        #expect(gbCertifications.count == 7)
    }

    @Test("tvSeriesCertifications")
    func tvSeriesCertifications() async throws {
        let certifications = try await certificationService.tvSeriesCertifications()

        let gbCertifications = try #require(certifications["GB"])

        #expect(gbCertifications.count == 7)
    }

}
