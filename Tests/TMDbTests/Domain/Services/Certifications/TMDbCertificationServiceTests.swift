//
//  TMDbCertificationServiceTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.services, .certification))
struct TMDbCertificationServiceTests {

    var service: TMDbCertificationService!
    var apiClient: MockAPIClient!

    init() {
        self.apiClient = MockAPIClient()
        self.service = TMDbCertificationService(apiClient: apiClient)
    }

    @Test("movieCertifications returns movie certifications")
    func movieCertificationsReturnsMovieCertifications() async throws {
        let certifications = Certifications.gbAndUS
        let expectedResult = certifications.certifications
        let expectedRequest = MovieCertificationsRequest()

        apiClient.addResponse(.success(certifications))

        let result = try await service.movieCertifications()

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? MovieCertificationsRequest == expectedRequest)
    }

    @Test("movieCertifications when errors throw error")
    func movieCertificationsWhenErrosThrowError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.movieCertifications()
        }
    }

    @Test("tvSeriesCertifications returns TV series certifications")
    func tvSeriesCertificationsReturnsTVSeriesCertifications() async throws {
        let certifications = Certifications.gbAndUS
        let expectedResult = certifications.certifications
        let expectedRequest = TVSeriesCertificationsRequest()

        apiClient.addResponse(.success(certifications))

        let result = try await service.tvSeriesCertifications()

        #expect(result == expectedResult)
        #expect(apiClient.lastRequest as? TVSeriesCertificationsRequest == expectedRequest)
    }

    @Test("tvSeriesCertifications when errors throw error")
    func tvSeriesCertificationsWhenErrorsThrowsError() async throws {
        apiClient.addResponse(.failure(.unknown))

        await #expect(throws: TMDbError.unknown) {
            _ = try await service.tvSeriesCertifications()
        }
    }

}
