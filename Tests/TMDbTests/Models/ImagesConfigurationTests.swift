@testable import TMDb
import XCTest

class ImagesConfigurationTests: XCTestCase {

    func testDecode_returnsImagesConfiguration() throws {
        let data = json.data(using: .utf8)!
        let result = try JSONDecoder.theMovieDatabase.decode(ImagesConfiguration.self, from: data)

        XCTAssertEqual(result, imagesConfiguration)
    }

    private let json = """
    {
        "base_url": "http://image.tmdb.org/t/p/",
        "secure_base_url": "https://image.tmdb.org/t/p/",
        "backdrop_sizes": [
          "w300",
          "w780",
          "w1280",
          "original"
        ],
        "logo_sizes": [
          "w45",
          "w92",
          "w154",
          "w185",
          "w300",
          "w500",
          "original"
        ],
        "poster_sizes": [
          "w92",
          "w154",
          "w185",
          "w342",
          "w500",
          "w780",
          "original"
        ],
        "profile_sizes": [
          "w45",
          "w185",
          "h632",
          "original"
        ],
        "still_sizes": [
          "w92",
          "w185",
          "w300",
          "original"
        ]
      }
    """

    private let imagesConfiguration = ImagesConfiguration(
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
    )

}
