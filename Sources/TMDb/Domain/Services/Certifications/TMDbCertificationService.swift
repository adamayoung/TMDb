//
//  TMDbCertificationService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
final class TMDbCertificationService: CertificationService {

    private let apiClient: any APIClient

    init(apiClient: some APIClient) {
        self.apiClient = apiClient
    }

    func movieCertifications() async throws(TMDbError) -> [String: [Certification]] {
        let request = MovieCertificationsRequest()

        return try await apiClient.perform(request).certifications
    }

    func tvSeriesCertifications() async throws(TMDbError) -> [String: [Certification]] {
        let request = TVSeriesCertificationsRequest()

        return try await apiClient.perform(request).certifications
    }

}
