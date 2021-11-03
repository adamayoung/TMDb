@testable import TMDb
import XCTest

final class ShowTests: XCTestCase {

    func testIDWhenMovieReturnsMovieID() {
        XCTAssertEqual(movieShow.id, 109091)
    }

    func testIDWhenTVShowReturnsTVShowID() {
        XCTAssertEqual(tvShowShow.id, 54)
    }

    func testPopularityWhenMovieReturnsMoviePopularity() {
        XCTAssertEqual(movieShow.popularity, 3.597124)
    }

    func testPopularityWhenTVShowReturnsTVShowPopularity() {
        XCTAssertEqual(tvShowShow.popularity, 2.883124)
    }

    func testDateWhenMovieReturnsMovieReleaseDate() {
        let expectedResult = DateFormatter.theMovieDatabase.date(from: "2013-10-25")
        XCTAssertEqual(movieShow.date, expectedResult)
    }

    func testDateWhenTVShowReturnsTVShowFirstAirDate() {
        let expectedResult = DateFormatter.theMovieDatabase.date(from: "1985-09-24")
        XCTAssertEqual(tvShowShow.date, expectedResult)
    }

    func testDecodeReturnsMovie() throws {
        let data = movieJSON.data(using: .utf8)!
        let result = try JSONDecoder.theMovieDatabase.decode(Show.self, from: data)

        XCTAssertEqual(result, movieShow)
    }

    func testDecodeReturnsTVShow() throws {
        let data = tvShowJSON.data(using: .utf8)!
        let result = try JSONDecoder.theMovieDatabase.decode(Show.self, from: data)

        XCTAssertEqual(result, tvShowShow)
    }

    func testSortWithNoDates() {
        let showOne: Show = .movie(
            .init(id: .randomID, title: .randomString)
        )
        let showTwo: Show = .tvShow(
            .init(id: .randomID, name: .randomString)
        )

        let result = showOne < showTwo

        XCTAssertFalse(result)
    }

    func testSortWithLHSDate() {
        let showOne: Show = .movie(
            .init(id: .randomID, title: .randomString, releaseDate: Date(timeIntervalSince1970: 1618840399))
        )
        let showTwo: Show = .tvShow(
            .init(id: .randomID, name: .randomString)
        )

        let result = showOne < showTwo

        XCTAssertTrue(result)
    }

    func testSortWithRHSDate() {
        let showOne: Show = .movie(
            .init(id: .randomID, title: .randomString)
        )
        let showTwo: Show = .tvShow(
            .init(id: .randomID, name: .randomString, firstAirDate: Date(timeIntervalSince1970: 1218840399))
        )

        let result = showOne < showTwo

        XCTAssertFalse(result)
    }

    func testSortWithDates() {
        let showOne: Show = .movie(
            .init(id: .randomID, title: .randomString, releaseDate: Date(timeIntervalSince1970: 1618840399))
        )
        let showTwo: Show = .tvShow(
            .init(id: .randomID, name: .randomString, firstAirDate: Date(timeIntervalSince1970: 1218840399))
        )

        let result = showOne < showTwo

        XCTAssertTrue(result)
    }

}

extension ShowTests {

    // swiftlint:disable line_length
    private var movieJSON: String {
        """
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
    }

    private var tvShowJSON: String {
        """
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
    }

    private var movieShow: Show {
        .movie(
            .init(
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
            )
        )
    }

    private var tvShowShow: Show {
        .tvShow(
            .init(
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
            )
        )
    }
    // swiftlint:enable line_length

}
