//
//  ReviewIntegrationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(
    .tags(.review),
    .enabled(if: CredentialHelper.shared.hasAPIKey)
)
struct ReviewIntegrationTests {

    var reviewService: (any ReviewService)!

    init() {
        let apiKey = CredentialHelper.shared.tmdbAPIKey
        self.reviewService = TMDbClient(
            apiKey: apiKey
        ).reviews
    }

    @Test("details")
    func details() async throws {
        let reviewID = "5488c29bc3a3686f4a00004a"

        let review = try await reviewService.details(
            forReview: reviewID
        )

        #expect(review.id == reviewID)
        #expect(review.author == "Travis Bell")
        #expect(review.content.isEmpty == false)
    }

}
