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

    func movieCertifications() async throws -> [String: [Certification]] {
        let request = MovieCertificationsRequest()

        let certifications: Certifications
        do {
            certifications = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return certifications.certifications
    }

    func tvSeriesCertifications() async throws -> [String: [Certification]] {
        let request = TVSeriesCertificationsRequest()

        let certifications: Certifications
        do {
            certifications = try await apiClient.perform(request)
        } catch let error {
            throw TMDbError(error: error)
        }

        return certifications.certifications
    }

}
