@testable import TMDb
import XCTest

class MovieTests: XCTestCase {

    func testReleaseDate_whenNil_returnsNil() {
        let movie = Movie(id: 1, title: "Some title")

        XCTAssertNil(movie.releaseDate)
    }

    func testHomepageURL_whenNil_returnsNil() {
        let movie = Movie(id: 1, title: "Some title")

        XCTAssertNil(movie.homepageURL)
    }

    func testHomepageURL_whenHasURL_returnsURL() {
        let expectedResult = URL(string: "https://some.domain.com")!
        let movie = Movie(id: 1, title: "Some title", homepageURL: expectedResult)

        XCTAssertEqual(movie.homepageURL, expectedResult)
    }

    func testDecode_returnsMovie() throws {
        let data = json.data(using: .utf8)!
        let result = try JSONDecoder.theMovieDatabase.decode(Movie.self, from: data)

        XCTAssertEqual(result, movie)
    }

    // swiftlint:disable line_length
    private let json = """
    {
        "adult": false,
        "backdrop_path": "/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg",
        "belongs_to_collection": null,
        "budget": 63000000,
        "genres": [
            {
                "id": 18,
                "name": "Drama"
            }
        ],
        "homepage": null,
        "id": 550,
        "imdb_id": "tt0137523",
        "original_language": "en",
        "original_title": "Fight Club",
        "overview": "A ticking-time-bomb insomniac and a slippery soap salesman channel primal male aggression into a shocking new form of therapy. Their concept catches on, with underground \\"fight clubs\\" forming in every town, until an eccentric gets in the way and ignites an out-of-control spiral toward oblivion.",
        "popularity": 0.5,
        "poster_path": null,
        "production_companies": [
            {
                "id": 508,
                "logo_path": "/7PzJdsLGlR7oW4J0J5Xcd0pHGRg.png",
                "name": "Regency Enterprises",
                "origin_country": "US"
            }
        ],
        "production_countries": [
            {
                "iso_3166_1": "US",
                "name": "United States of America"
            }
        ],
        "release_date": "1999-10-12",
        "revenue": 100853753,
        "runtime": 139,
        "spoken_languages": [
            {
                "iso_639_1": "en",
                "name": "English"
            }
        ],
        "status": "Released",
        "tagline": "How much can you know about yourself if you've never been in a fight?",
        "title": "Fight Club",
        "video": false,
        "vote_average": 7.8,
        "vote_count": 3439
    }
    """

    private let movie = Movie(
        id: 550,
        title: "Fight Club",
        tagline: "How much can you know about yourself if you've never been in a fight?",
        originalTitle: "Fight Club",
        originalLanguage: "en",
        overview: "A ticking-time-bomb insomniac and a slippery soap salesman channel primal male aggression into a shocking new form of therapy. Their concept catches on, with underground \"fight clubs\" forming in every town, until an eccentric gets in the way and ignites an out-of-control spiral toward oblivion.",
        runtime: 139,
        genres: [
            Genre(id: 18, name: "Drama")
        ],
        releaseDate: DateFormatter.theMovieDatabase.date(from: "1999-10-12"),
        posterPath: nil,
        backdropPath: URL(string: "/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg"),
        budget: 63000000,
        revenue: 100853753,
        homepageURL: URL(string: ""),
        imdbID: "tt0137523",
        status: .released,
        productionCompanies: [
            ProductionCompany(
                id: 508,
                name: "Regency Enterprises",
                originCountry: "US",
                logoPath: URL(string: "/7PzJdsLGlR7oW4J0J5Xcd0pHGRg.png")
            )
        ],
        productionCountries: [
            ProductionCountry(
                iso31661: "US",
                name: "United States of America"
            )
        ],
        spokenLanguages: [
            SpokenLanguage(
                iso6391: "en",
                name: "English"
            )
        ],
        popularity: 0.5,
        voteAverage: 7.8,
        voteCount: 3439,
        video: false,
        adult: false
    )
    // swiftlint:enable line_length

}
