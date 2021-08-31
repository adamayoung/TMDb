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

    func testFetchMovieCertificationsReturnsMovieCertifications() {
        let expectedResult = Certification.mocks
        apiClient.result = .success(expectedResult)

        let expectation = XCTestExpectation(description: "await")
        service.fetchMovieCertifications { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, CertificationsEndpoint.movie.url)
    }

    func testFetchTVShowCertificationsReturnsTVShowCertifications() {
        let expectedResult = Certification.mocks
        apiClient.result = .success(expectedResult)

        let expectation = XCTestExpectation(description: "await")
        service.fetchTVShowCertifications { result in
            XCTAssertEqual(try? result.get(), expectedResult)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, CertificationsEndpoint.tvShow.url)
    }

}
