import TMDb
import XCTest

final class CertificationIntegrationTests: XCTestCase {

    var certificationService: CertificationService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        try configureTMDb()
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

    func testTVSeriesCertifications() async throws {
        let certifications = try await certificationService.tvSeriesCertifications()

        let gbCertifications = try XCTUnwrap(certifications["GB"])

        XCTAssertEqual(gbCertifications.count, 7)
    }

}
