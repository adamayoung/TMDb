@testable import TMDb
import XCTest

class APIConfigurationTests: XCTestCase {

    func testDecode_returnsAPIConfiguration() throws {
        let data = json.data(using: .utf8)!
        let result = try JSONDecoder.theMovieDatabase.decode(APIConfiguration.self, from: data)

        XCTAssertEqual(result.images, apiConfiguration.images)
        XCTAssertEqual(result.changeKeys, apiConfiguration.changeKeys)
    }

    private let json = """
    {
      "images": {
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
      },
      "change_keys": [
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
    }
    """

    private let apiConfiguration = APIConfiguration(
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

}
