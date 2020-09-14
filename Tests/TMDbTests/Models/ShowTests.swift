@testable import TMDb
import XCTest

class ShowTests: XCTestCase {

    func testID_whenMovie_returnsMovieID() {
        XCTAssertEqual(movieShow.id, 109091)
    }

    func testID_whenTVShow_returnsTVShowID() {
        XCTAssertEqual(tvShowShow.id, 54)
    }

    func testPopularity_whenMovie_returnsMoviePopularity() {
        XCTAssertEqual(movieShow.popularity, 3.597124)
    }

    func testPopularity_whenTVShow_returnsTVShowPopularity() {
        XCTAssertEqual(tvShowShow.popularity, 2.883124)
    }

    func testDate_whenMovie_returnsMovieReleaseDate() {
        let expectedResult = DateFormatter.theMovieDatabase.date(from: "2013-10-25")
        XCTAssertEqual(movieShow.date, expectedResult)
    }

    func testDate_whenTVShow_returnsTVShowFirstAirDate() {
        let expectedResult = DateFormatter.theMovieDatabase.date(from: "1985-09-24")
        XCTAssertEqual(tvShowShow.date, expectedResult)
    }

    func testDecode_returnsMovie() throws {
        let data = movieJSON.data(using: .utf8)!
        let result = try JSONDecoder.theMovieDatabase.decode(Show.self, from: data)

        XCTAssertEqual(result, movieShow)
    }

    func testDecode_returnsTVShow() throws {
        let data = tvShowJSON.data(using: .utf8)!
        let result = try JSONDecoder.theMovieDatabase.decode(Show.self, from: data)

        XCTAssertEqual(result, tvShowShow)
    }

    // swiftlint:disable line_length
    private let movieJSON = """
    {
        "id": 109091,
        "original_language": "en",
        "original_title": "The Counselor",
        "overview": "A rich and successful lawyer named Counselor is about to get married to his fiancée but soon meets up with the middle-man known as Westray who tells him his drug trafficking plan has taken a horrible twist and now he must protect himself and his soon bride-to-be lover as the truth of the drug business uncovers and targets become chosen.",
        "vote_count": 661,
        "video": false,
        "media_type": "movie",
        "credit_id": "52fe4aaac3a36847f81db47d",
        "vote_average": 5,
        "character": "Westray",
        "popularity": 3.597124,
        "release_date": "2013-10-25",
        "title": "The Counselor",
        "genre_ids": [
        80,
        18,
        53
        ],
        "adult": false,
        "backdrop_path": "/62xHmGnxMi0wV40BS3iKnDru0nO.jpg",
        "poster_path": "/uxp6rHVBzUqZCyTaUI8xzUP5sOf.jpg"
    }
    """

    private let tvShowJSON = """
    {
        "id": 54,
        "original_language": "en",
        "episode_count": 2,
        "overview": "Growing Pains is an American television sitcom about an affluent family, residing in Huntington, Long Island, New York, with a working mother and a stay-at-home psychiatrist father raising three children together, which aired on ABC from September 24, 1985, to April 25, 1992.",
        "origin_country": [
            "US"
        ],
        "original_name": "Growing Pains",
        "genre_ids": [
            35
        ],
        "name": "Growing Pains",
        "media_type": "tv",
        "poster_path": "/eKyeUFwjc0LhPSp129IHpXniJVR.jpg",
        "first_air_date": "1985-09-24",
        "vote_average": 6.2,
        "vote_count": 25,
        "character": "",
        "backdrop_path": "/xYpXcp7S8pStWihcksTQQue3jlV.jpg",
        "popularity": 2.883124,
        "credit_id": "525333fb19c295794002c720"
    }
    """

    private let movieShow: Show = .movie(Movie(
        id: 109091,
        title: "The Counselor",
        originalTitle: "The Counselor",
        originalLanguage: "en",
        overview: "A rich and successful lawyer named Counselor is about to get married to his fiancée but soon meets up with the middle-man known as Westray who tells him his drug trafficking plan has taken a horrible twist and now he must protect himself and his soon bride-to-be lover as the truth of the drug business uncovers and targets become chosen.",
        releaseDate: DateFormatter.theMovieDatabase.date(from: "2013-10-25"),
        posterPath: URL(string: "/uxp6rHVBzUqZCyTaUI8xzUP5sOf.jpg"),
        backdropPath: URL(string: "/62xHmGnxMi0wV40BS3iKnDru0nO.jpg"),
        popularity: 3.597124,
        voteAverage: 5,
        voteCount: 661,
        video: false,
        adult: false
    ))

    private let tvShowShow: Show = .tvShow(TVShow(
        id: 54,
        name: "Growing Pains",
        originalName: "Growing Pains",
        originalLanguage: "en",
        overview: "Growing Pains is an American television sitcom about an affluent family, residing in Huntington, Long Island, New York, with a working mother and a stay-at-home psychiatrist father raising three children together, which aired on ABC from September 24, 1985, to April 25, 1992.",
        firstAirDate: DateFormatter.theMovieDatabase.date(from: "1985-09-24"),
        originCountry: ["US"],
        posterPath: URL(string: "/eKyeUFwjc0LhPSp129IHpXniJVR.jpg"),
        backdropPath: URL(string: "/xYpXcp7S8pStWihcksTQQue3jlV.jpg"),
        popularity: 2.883124,
        voteAverage: 6.2,
        voteCount: 25
    ))
    // swiftlint:enable line_length

}
