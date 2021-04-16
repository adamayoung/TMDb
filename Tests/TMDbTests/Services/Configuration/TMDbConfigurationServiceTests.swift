@testable import TMDb
import XCTest

#if canImport(Combine)
import Combine
#endif

class TMDbConfigurationServiceTests: XCTestCase {

    #if canImport(Combine)
    var cancellables: Set<AnyCancellable> = []
    #endif
    var service: TMDbConfigurationService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()

        apiClient = MockAPIClient()
        service = TMDbConfigurationService(apiClient: apiClient)
    }

}

#if canImport(Combine)
extension TMDbConfigurationServiceTests {

    func testAPIConfigurationPublisherReturnsAPIConfiguration() throws {
        let expectedResult = APIConfiguration(
            images: ImagesConfiguration(
                baseUrl: URL(string: "http://image.tmdb.org/t/p/")!,
                secureBaseUrl: URL(string: "https://image.tmdb.org/t/p/")!,
                backdropSizes: [
                    "w300"
                ],
                logoSizes: [
                    "w45"
                ],
                posterSizes: [
                    "w92"
                ],
                profileSizes: [
                    "w45"
                ],
                stillSizes: [
                    "w92"
                ]
            ),
            changeKeys: [
                "air_date",
                "also_known_as"
            ]
        )
        apiClient.response = expectedResult

        let result = try await(publisher: service.apiConfigurationPublisher(), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, ConfigurationEndpoint.api.url)
    }

}
#endif
