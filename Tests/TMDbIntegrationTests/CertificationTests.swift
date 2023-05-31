// @testable import TMDb
// import XCTest
//
// final class CertificationTests: XCTestCase {
//
//    private var tmdb: TMDbAPI!
//
//    override func setUpWithError() throws {
//        super.setUp()
//        tmdb = TMDbAPI(apiKey: "", urlSessionConfiguration: .integrationTest)
//    }
//
//    override func tearDown() {
//        tmdb = nil
//        TMDbURLProtocol.reset()
//        super.tearDown()
//    }
//
//    func testMovieCertifications() async throws {
//        TMDbURLProtocol.add("certification-movie-list", for: CertificationsEndpoint.movie)
//
//        let certifications = try await tmdb.certifications.movieCertifications()
//
//        XCTAssertTrue(!certifications.isEmpty)
//    }
//
//    func testTVShowCertifications() async throws {
//        TMDbURLProtocol.add("certification-tv-list", for: CertificationsEndpoint.tvShow)
//
//        let certifications = try await tmdb.certifications.tvShowCertifications()
//
//        XCTAssertTrue(!certifications.isEmpty)
//    }
//
// }
