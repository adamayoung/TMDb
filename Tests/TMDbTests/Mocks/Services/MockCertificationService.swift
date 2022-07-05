@testable import TMDb
import XCTest

final class MockCertificationService: CertificationService {

    var movieCertifications: [String: [Certification]] = [:]
    var tvShowCertifications: [String: [Certification]] = [:]

    func movieCertifications() async throws -> [String: [Certification]] {
        try await withCheckedThrowingContinuation { continuation in
            guard !movieCertifications.isEmpty else {
                continuation.resume(throwing: MockDataMissingError())
                return
            }

            continuation.resume(returning: movieCertifications)
        }
    }

    func tvShowCertifications() async throws -> [String: [Certification]] {
        try await withCheckedThrowingContinuation { continuation in
            continuation.resume(returning: tvShowCertifications)
        }
    }

}
