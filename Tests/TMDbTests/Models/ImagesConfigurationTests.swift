@testable import TMDb
import XCTest

final class ImagesConfigurationTests: XCTestCase {

    func testDecodeReturnsImagesConfiguration() throws {
        let result = try JSONDecoder.theMovieDatabase
            .decode(ImagesConfiguration.self, fromResource: "images-configuration")

        XCTAssertEqual(result.baseURL, imagesConfiguration.baseURL)
        XCTAssertEqual(result.secureBaseURL, imagesConfiguration.secureBaseURL)
        XCTAssertEqual(result.backdropSizes, imagesConfiguration.backdropSizes)
        XCTAssertEqual(result.logoSizes, imagesConfiguration.logoSizes)
        XCTAssertEqual(result.posterSizes, imagesConfiguration.posterSizes)
        XCTAssertEqual(result.profileSizes, imagesConfiguration.profileSizes)
        XCTAssertEqual(result.stillSizes, imagesConfiguration.stillSizes)
    }

    private let imagesConfiguration = ImagesConfiguration(
        baseURL: URL(string: "http://image.tmdb.org/t/p/")!,
        secureBaseURL: URL(string: "https://image.tmdb.org/t/p/")!,
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
    )

}
