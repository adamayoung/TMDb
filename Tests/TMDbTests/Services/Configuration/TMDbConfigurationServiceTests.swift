import Combine
@testable import TMDb
import XCTest

class TMDbConfigurationServiceTests: XCTestCase {

    var cancellables: Set<AnyCancellable> = []
    var service: TMDbConfigurationService!
    var apiClient: MockAPIClient!

    override func setUp() {
        super.setUp()

        apiClient = MockAPIClient()
        service = TMDbConfigurationService(apiClient: apiClient)
    }

    func testFetchAPIConfigurationReturnsAPIConfiguration() throws {
        let expectedResult = APIConfigurationDTO(
            images: ImagesConfigurationDTO(
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

        let result = try await(publisher: service.fetchAPIConfiguration(), storeIn: &cancellables)

        XCTAssertEqual(result, expectedResult)
        XCTAssertEqual(apiClient.lastPath, ConfigurationEndpoint.api.url)
    }

}
