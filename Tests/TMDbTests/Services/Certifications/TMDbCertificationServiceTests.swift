import Combine
@testable import TMDb
import XCTest

class TMDbCertificationServiceTests: XCTestCase {

    var cancellables: Set<AnyCancellable> = []
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

    func testFetchMovieCertifications_returnsMovieCertifications() {
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

        let finished = XCTestExpectation(description: "finished")
        service.fetchMovieCertifications()
            .sink(receiveCompletion: { _ in
            }, receiveValue: { result in
                XCTAssertEqual(result, expectedResult)
                finished.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [finished], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, CertificationsEndpoint.movie.url)
    }

    func testFetchTVShowCertifications_returnsMovieCertifications() {
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

        let finished = XCTestExpectation(description: "finished")
        service.fetchTVShowCertifications()
            .sink(receiveCompletion: { _ in
            }, receiveValue: { result in
                XCTAssertEqual(result, expectedResult)
                finished.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [finished], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, CertificationsEndpoint.tvShow.url)
    }

}
