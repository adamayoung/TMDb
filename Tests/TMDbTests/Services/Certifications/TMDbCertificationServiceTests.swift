@testable import TMDb
import XCTest

#if canImport(Combine)
import Combine
#endif

class TMDbCertificationServiceTests: XCTestCase {

    #if canImport(Combine)
    var cancellables: Set<AnyCancellable> = []
    #endif
    var service: TMDbCertificationService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()

        apiClient = MockAPIClient()
        service = TMDbCertificationService(apiClient: apiClient)
    }

    override func tearDown() {
        apiClient.reset()

        super.tearDown()
    }

}

#if canImport(Combine)
extension TMDbCertificationServiceTests {

    func testMovieCertificationsPublisherReturnsMovieCertifications() throws {
        let expectedResult = Certification.mocks
        apiClient.response = expectedResult

        let result = try await(publisher: service.movieCertificationsPublisher(), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, CertificationsEndpoint.movie.url)
    }

    func testTVShowCertificationsPublisherReturnsTVShowCertifications() throws {
        let expectedResult = Certification.mocks
        apiClient.response = expectedResult

        let result = try await(publisher: service.tvShowCertificationsPublisher(), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, CertificationsEndpoint.tvShow.url)
    }

}
#endif
