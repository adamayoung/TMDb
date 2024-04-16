//
//  CertificationServiceTests.swift
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

@testable import TMDb
import XCTest

final class CertificationServiceTests: XCTestCase {

    var service: CertificationService!
    var repository: CertificationStubRepository!

    override func setUp() {
        super.setUp()
        repository = CertificationStubRepository()
        service = CertificationService(repository: repository)
    }

    override func tearDown() {
        service = nil
        repository = nil
        super.tearDown()
    }

    func testMovieCertificationsWhenSuccessfulReturnsMovieCertifications() async throws {
        let expectedResult = Certifications.gbAndUS.certifications
        repository.movieCertificationsResult = .success(expectedResult)

        let result = try await service.movieCertifications()

        XCTAssertEqual(result, expectedResult)
    }

    func testMovieCertificationsWhenFailureThrowsError() async throws {
        let expectedError = TMDbError.unknown
        repository.movieCertificationsResult = .failure(expectedError)

        var error: TMDbError?
        do {
            _ = try await service.movieCertifications()
        } catch let err {
            error = err as? TMDbError
        }

        XCTAssertEqual(error, expectedError)
    }

    func testTVSeriesCertificationsWhenSuccessfulReturnsTVSeriesCertifications() async throws {
        let expectedResult = Certifications.gbAndUS.certifications
        repository.tvSeriesCertificationsResult = .success(expectedResult)

        let result = try await service.tvSeriesCertifications()

        XCTAssertEqual(result, expectedResult)
    }

    func testTVSeriesCertificationsWhenFailureThrowsError() async throws {
        let expectedError = TMDbError.unknown
        repository.tvSeriesCertificationsResult = .failure(expectedError)

        var error: TMDbError?
        do {
            _ = try await service.tvSeriesCertifications()
        } catch let err {
            error = err as? TMDbError
        }

        XCTAssertEqual(error, expectedError)
    }

}
