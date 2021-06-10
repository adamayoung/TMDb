import Foundation

#if swift(>=5.5)
@available(macOS 12, iOS 15.0, tvOS 15.0, watchOS 8.0, *)
public extension CertificationService {

    /// Returns the officially supported movie certifications on TMDb.
    ///
    /// [TMDb API - Movie Certifications](https://developers.themoviedb.org/3/certifications/get-movie-certifications)
    ///
    /// - Returns: A dictionary of movie certifications.
    func movieCertifications() async throws -> [String: [Certification]] {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchMovieCertifications(completion: continuation.resume(with:))
        }
    }

    /// Returns the officially supported TV show certifications on TMDb.
    ///
    /// [TMDb API - TV show Certifications](https://developers.themoviedb.org/3/certifications/get-tv-certifications)
    ///
    /// - Returns: A dictionary of TV show certifications.
    func tvShowCertifications() async throws -> [String: [Certification]] {
        try await withCheckedThrowingContinuation { continuation in
            self.fetchTVShowCertifications(completion: continuation.resume(with:))
        }
    }

}
#endif
