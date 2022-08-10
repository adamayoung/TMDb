@testable import TMDb
import XCTest

final class TMDbCertificationServiceTests: XCTestCase {

    var service: TMDbCertificationService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()
        apiClient = MockAPIClient()
        service = TMDbCertificationService(apiClient: apiClient)
    }

    override func tearDown() {
        apiClient = nil
        service = nil
        super.tearDown()
    }

    func testMovieCertificationsReturnsMovieCertifications() async throws {
        let expectedResult = Certification.mocks
        let certifications = Certifications(certifications: expectedResult)

        apiClient.result = .success(certifications)

        let result = try await service.movieCertifications()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, CertificationsEndpoint.movie.path)
    }

    func testTVShowCertificationsReturnsTVShowCertifications() async throws {
        let expectedResult = Certification.mocks
        let certifications = Certifications(certifications: expectedResult)

        apiClient.result = .success(certifications)

        let result = try await service.tvShowCertifications()

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, CertificationsEndpoint.tvShow.path)
    }

}
