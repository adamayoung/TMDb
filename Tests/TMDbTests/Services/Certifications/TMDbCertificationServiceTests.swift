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
        let expectedResult = [
            "A": [
                Certification(code: "1", meaning: "Meaning 1", order: 1),
                Certification(code: "2", meaning: "Meaning 2", order: 2)
            ],
            "B": [
                Certification(code: "3", meaning: "Meaning 3", order: 1),
                Certification(code: "4", meaning: "Meaning 4", order: 2)
            ]
        ]
        apiClient.response = expectedResult

        let result = try await(publisher: service.movieCertificationsPublisher(), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, CertificationsEndpoint.movie.url)
    }

    func testTVShowCertificationsPublisherReturnsMovieCertifications() throws {
        let expectedResult = [
            "A": [
                Certification(code: "1", meaning: "Meaning 1", order: 1),
                Certification(code: "2", meaning: "Meaning 2", order: 2)
            ],
            "B": [
                Certification(code: "3", meaning: "Meaning 3", order: 1),
                Certification(code: "4", meaning: "Meaning 4", order: 2)
            ]
        ]
        apiClient.response = expectedResult

        let result = try await(publisher: service.tvShowCertificationsPublisher(), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, CertificationsEndpoint.tvShow.url)
    }

}
#endif
