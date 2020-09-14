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
                "w300",
                "w780",
                "w1280",
                "original"
            ],
            logoSizes: [
                "w45",
                "w92",
                "w154",
                "w185",
                "w300",
                "w500",
                "original"
            ],
            posterSizes: [
                "w92",
                "w154",
                "w185",
                "w342",
                "w500",
                "w780",
                "original"
            ],
            profileSizes: [
                "w45",
                "w185",
                "h632",
                "original"
            ],
            stillSizes: [
                "w92",
                "w185",
                "w300",
                "original"
            ]
        ),
        changeKeys: [
            "adult",
            "air_date",
            "also_known_as",
            "alternative_titles",
            "biography",
            "birthday",
            "budget",
            "cast",
            "certifications",
            "character_names",
            "created_by",
            "crew",
            "deathday",
            "episode",
            "episode_number",
            "episode_run_time",
            "freebase_id",
            "freebase_mid",
            "general",
            "genres",
            "guest_stars",
            "homepage",
            "images",
            "imdb_id",
            "languages",
            "name",
            "network",
            "origin_country",
            "original_name",
            "original_title",
            "overview",
            "parts",
            "place_of_birth",
            "plot_keywords",
            "production_code",
            "production_companies",
            "production_countries",
            "releases",
            "revenue",
            "runtime",
            "season",
            "season_number",
            "season_regular",
            "spoken_languages",
            "status",
            "tagline",
            "title",
            "translations",
            "tvdb_id",
            "tvrage_id",
            "type",
            "video",
            "videos"
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
