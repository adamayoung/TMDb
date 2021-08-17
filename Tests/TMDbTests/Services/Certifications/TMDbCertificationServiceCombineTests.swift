#if canImport(Combine)
import Combine
@testable import TMDb
import XCTest

final class TMDbCertificationServiceCombineTests: XCTestCase {

    var cancellables: Set<AnyCancellable> = []
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

    func testMovieCertificationsPublisherReturnsMovieCertifications() throws {
        let expectedResult = Certification.mocks
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.movieCertificationsPublisher(), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, CertificationsEndpoint.movie.url)
    }

    func testTVShowCertificationsPublisherReturnsTVShowCertifications() throws {
        let expectedResult = Certification.mocks
        apiClient.response = expectedResult

        let result = try waitFor(publisher: service.tvShowCertificationsPublisher(), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, CertificationsEndpoint.tvShow.url)
    }

}
#endif
