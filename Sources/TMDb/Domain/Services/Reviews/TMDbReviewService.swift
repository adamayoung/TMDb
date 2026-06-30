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
    ) async throws(TMDbError) -> Review {
        try Self.validate(id: id)
        let request = ReviewRequest(id: id)

        return try await apiClient.perform(request)
    }

}

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
extension TMDbReviewService {

    private static func validate(id: Review.ID) throws(TMDbError) {
        try id.validateNotEmpty(message: "Review ID must not be empty")
    }

}
