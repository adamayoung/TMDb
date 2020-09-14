import Combine
@testable import TMDb
import XCTest

class TMDbConfigurationServiceTests: XCTestCase {

    var cancellables: Set<AnyCancellable> = []
    var service: TMDbConfigurationService!
    var apiClient: MockAPIClient!

    let apiConfiguration = APIConfiguration(
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

    override func setUp() {
        super.setUp()

        apiClient = MockAPIClient()
        service = TMDbConfigurationService(apiClient: apiClient)
    }

    func testFetchAPIConfigurationReturnsAPIConfiguration() {
        apiClient.response = apiConfiguration

        let finished = XCTestExpectation(description: "finished")
        service.fetchAPIConfiguration()
            .sink(receiveCompletion: { result in
                switch result {
                case .failure:
                    XCTFail("Should not have failed")

                default:
                    break
                }
            }, receiveValue: { result in
                XCTAssertEqual(result, self.apiConfiguration)
                finished.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [finished], timeout: 1)

        XCTAssertEqual(apiClient.lastPath, ConfigurationEndpoint.api.url)
    }

}
