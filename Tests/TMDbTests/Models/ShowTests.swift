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
        let result = try JSONDecoder.theMovieDatabase.decode(Show.self, fromResource: "show-movie")

        XCTAssertEqual(result, movieShow)
    }

    func testDecodeReturnsTVShow() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(Show.self, fromResource: "show-tv-show")

        XCTAssertEqual(result, tvShowShow)
    }

}

extension ShowTests {

    // swiftlint:disable line_length
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
                hasVideo: false,
                isAdultOnly: false
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
