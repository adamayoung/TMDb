import Combine
@testable import TMDb
import XCTest

class TMDbAPICertificationTests: TMDbAPITestCase {

    func testMovieCertificationsPublisherReturnsCertifications() throws {
        let expectedResult = [
            "GB": [
                Certification(code: "A", meaning: "AA", order: 0),
                Certification(code: "B", meaning: "BB", order: 1),
                Certification(code: "C", meaning: "CC", order: 2)
            ],
            "US": [
                Certification(code: "D", meaning: "DD", order: 0),
                Certification(code: "E", meaning: "EE", order: 1),
                Certification(code: "F", meaning: "FF", order: 2)
            ]
        ]
        certificationService.movieCertifications = expectedResult

        let result = try await(publisher: tmdb.movieCertificationsPublisher(), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
    }

    func testTVShowCertificationsPublisherReturnsCertifications() throws {
        let expectedResult = [
            "GB": [
                Certification(code: "A", meaning: "AA", order: 0),
                Certification(code: "B", meaning: "BB", order: 1),
                Certification(code: "C", meaning: "CC", order: 2)
            ],
            "US": [
                Certification(code: "D", meaning: "DD", order: 0),
                Certification(code: "E", meaning: "EE", order: 1),
                Certification(code: "F", meaning: "FF", order: 2)
            ]
        ]
        certificationService.tvShowCertifications = expectedResult

        let result = try await(publisher: tmdb.tvShowCertificationsPublisher(), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
    }

}
