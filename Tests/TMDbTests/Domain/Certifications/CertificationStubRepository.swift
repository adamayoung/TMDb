//
//  CertificationStubRepository.swift
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
@testable import TMDb

final class CertificationStubRepository: CertificationRepository {

    var movieCertificationsResult: Result<[String: [Certification]], TMDbError>?

    var tvSeriesCertificationsResult: Result<[String: [Certification]], TMDbError>?

    init() {}

    func movieCertifications() async throws -> [String: [Certification]] {
        guard let certifications = try movieCertificationsResult?.get() else {
            preconditionFailure("movieCertificationsResult not set")
        }

        return certifications
    }

    func tvSeriesCertifications() async throws -> [String: [Certification]] {
        guard let certifications = try tvSeriesCertificationsResult?.get() else {
            preconditionFailure("tvSeriesCertificationsResult not set")
        }

        return certifications
    }

}
