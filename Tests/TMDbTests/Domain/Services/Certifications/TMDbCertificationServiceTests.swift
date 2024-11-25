//
//  TMDbCertificationServiceTests.swift
//  TMDb
//
//  Copyright © 2024 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
