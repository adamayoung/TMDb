import TMDb
import XCTest

final class CertificationIntegrationTests: XCTestCase {

    var certificationService: CertificationService!

    override func setUp() {
        super.setUp()
        TMDb.configure(TMDbConfiguration(apiKey: tmdbAPIKey))
        certificationService = CertificationService()
    }

    override func tearDown() {
        certificationService = nil
        super.tearDown()
    }

    func testMovieCertifications() async throws {
        let certifications = try await certificationService.movieCertifications()

        let gbCertifications = try XCTUnwrap(certifications["GB"])

        XCTAssertEqual(gbCertifications.count, 7)
    }

    func testTVShowCertifications() async throws {
        let certifications = try await certificationService.tvShowCertifications()

        let gbCertifications = try XCTUnwrap(certifications["GB"])

        XCTAssertEqual(gbCertifications.count, 7)
    }

}
