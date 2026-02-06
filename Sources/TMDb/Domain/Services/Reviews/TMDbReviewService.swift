//
//  TMDbReviewService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
final class TMDbReviewService: ReviewService {

    private let apiClient: any APIClient

    init(apiClient: some APIClient) {
        self.apiClient = apiClient
    }

    func details(
        forReview id: Review.ID
    ) async throws -> Review {
        let request = ReviewRequest(id: id)

        let review: Review
        do {
            review = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return review
    }

}
