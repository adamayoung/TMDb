import Combine
@testable import TMDb
import XCTest

class TMDbAPIConifgurationTests: TMDbAPITestCase {

    func testAPIConfigurationPublisherReturnsAPIConfiguration() throws {
        let expectedResult = APIConfigurationDTO(
            images: ImagesConfigurationDTO(
                baseUrl: URL(string: "https://some.domain.com/api")!,
                secureBaseUrl: URL(string: "https://images.domain.com/i")!,
                backdropSizes: ["w100", "w200", "w300"],
                logoSizes: ["w50", "w150", "w250"],
                posterSizes: ["w1000", "w2000", "w3000"],
                profileSizes: ["w1500", "w2500", "w3500"],
                stillSizes: ["w123", "w234", "w345"]
            ),
            changeKeys: ["key1", "key2", "key3"]
        )
        configurationService.apiConfiguration = expectedResult

        let result = try await(publisher: tmdb.apiConfigurationPublisher(), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
    }

}
