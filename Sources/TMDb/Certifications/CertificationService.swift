//
//  CertificationService.swift
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

///
/// Provides an interface for obtaining certification data from TMDb.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public final class CertificationService {

    private let apiClient: any APIClient

    ///
    /// Creates a certificate service object.
    ///
    public convenience init() {
        self.init(
            apiClient: TMDbFactory.apiClient
        )
    }

    init(apiClient: some APIClient) {
        self.apiClient = apiClient
    }

    ///
    /// Returns an up to date list of the officially supported movie certifications on TMDB.
    ///
    /// [TMDb API - Certifications: Movie Certifications](https://developer.themoviedb.org/reference/certification-movie-list)
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A dictionary of movie certifications.
    ///
    public func movieCertifications() async throws -> [String: [Certification]] {
        let certifications: Certifications
        do {
            certifications = try await apiClient.get(endpoint: CertificationsEndpoint.movie)
        } catch let error {
            throw TMDbError(error: error)
        }

        return certifications.certifications
    }

    ///
    /// Returns an up to date list of the officially supported TV certifications on TMDB.
    ///
    /// [TMDb API - Certifications: TV Certifications](https://developer.themoviedb.org/reference/certifications-tv-list)
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A dictionary of TV series certifications.
    ///
    public func tvSeriesCertifications() async throws -> [String: [Certification]] {
        let certifications: Certifications
        do {
            certifications = try await apiClient.get(endpoint: CertificationsEndpoint.tvSeries)
        } catch let error {
            throw TMDbError(error: error)
        }

        return certifications.certifications
    }

}
