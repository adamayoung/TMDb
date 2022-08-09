@testable import TMDb
import XCTest

final class CertificationIntegrationTests: XCTestCase {

    private var certificationService: CertificationService!

    override func setUpWithError() throws {
        super.setUp()
        let tmdb = TMDbAPI(apiKey: "", urlSessionConfiguration: .integrationTest)
        certificationService = tmdb.certifications
    }

    override func tearDown() {
        certificationService = nil
        TMDbURLProtocol.reset()
        super.tearDown()
    }

    func testMovieCertifications() async throws {
        TMDbURLProtocol.add("certification-movie-list", for: CertificationsEndpoint.movie)

        let certifications = try await certificationService.movieCertifications()

        XCTAssertTrue(!certifications.isEmpty)
    }

    func testTVShowCertifications() async throws {
        TMDbURLProtocol.add("certification-tv-list", for: CertificationsEndpoint.tvShow)

        let certifications = try await certificationService.tvShowCertifications()

        XCTAssertTrue(!certifications.isEmpty)
    }

}
