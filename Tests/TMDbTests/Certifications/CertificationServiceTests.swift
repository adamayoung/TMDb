@testable import TMDb
import XCTest

final class CertificationServiceTests: XCTestCase {

    var service: CertificationService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        service = CertificationService(apiClient: apiClient)
    }

    override func tearDown() {
        apiClient = nil
        service = nil
        super.tearDown()
    }

    func testMovieCertificationsReturnsMovieCertifications() async throws {
        let certifications = Certifications.gbAndUS
        let expectedResult = certifications.certifications

        apiClient.result = .success(certifications)

        let result = try await service.movieCertifications()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, CertificationsEndpoint.movie.path)
    }

    func testTVSeriesCertificationsReturnsTVSeriesCertifications() async throws {
        let certifications = Certifications.gbAndUS
        let expectedResult = certifications.certifications

        apiClient.result = .success(certifications)

        let result = try await service.tvSeriesCertifications()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, CertificationsEndpoint.tvSeries.path)
    }

}
