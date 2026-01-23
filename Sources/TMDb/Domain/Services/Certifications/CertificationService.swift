//
//  CertificationService.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Provides an interface for obtaining certification data from TMDb.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
public protocol CertificationService: Sendable {

    ///
    /// Returns an up to date list of the officially supported movie certifications on TMDB.
    ///
    /// [TMDb API - Certifications: Movie
    /// Certifications](https://developer.themoviedb.org/reference/certification-movie-list)
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A dictionary of movie certifications.
    ///
    func movieCertifications() async throws -> [String: [Certification]]

    ///
    /// Returns an up to date list of the officially supported TV certifications on TMDB.
    ///
    /// [TMDb API - Certifications: TV
    /// Certifications](https://developer.themoviedb.org/reference/certifications-tv-list)
    ///
    /// - Throws: TMDb error ``TMDbError``.
    ///
    /// - Returns: A dictionary of TV series certifications.
    ///
    func tvSeriesCertifications() async throws -> [String: [Certification]]

}
