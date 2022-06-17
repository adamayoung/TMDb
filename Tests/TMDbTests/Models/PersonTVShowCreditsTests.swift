@testable import TMDb
import XCTest

final class PersonTVShowCreditsTests: XCTestCase {

    func testDecodeReturnsPersonTVShowCredits() throws {
        let result = try JSONDecoder.theMovieDatabase
            .decode(PersonTVShowCredits.self, fromResource: "person-tv-show-credits")

        XCTAssertEqual(result.id, personTVShowCredits.id)
        XCTAssertEqual(result.cast, personTVShowCredits.cast)
        XCTAssertEqual(result.crew, personTVShowCredits.crew)
    }

    func testAllShows() {
        let tvShow1 = TVShow(id: 1, name: "TV Show 1")
        let tvShow2 = TVShow(id: 2, name: "TV Show 2")
        let credits = PersonTVShowCredits(id: 999, cast: [tvShow1, tvShow2], crew: [tvShow1])

        let expectedResult = [tvShow1, tvShow2]

        let result = credits.allShows

        XCTAssertEqual(result, expectedResult)
    }

    // swiftlint:disable line_length
    private let personTVShowCredits = PersonTVShowCredits(
        id: 287,
        cast: [
            TVShow(
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
        ],
        crew: [
            TVShow(
                id: 69061,
                name: "The OA",
                originalName: "The OA",
                originalLanguage: "en",
                overview: "Prairie Johnson, blind as a child, comes home to the community she grew up in with her sight restored. Some hail her a miracle, others a dangerous mystery, but Prairie won’t talk with the FBI or her parents about the seven years she went missing.", firstAirDate: DateFormatter.theMovieDatabase.date(from: "2016-12-16"),
                originCountry: [],
                posterPath: URL(string: "/ppSiYu2D0nw6KNF0kf5lKDxOGRR.jpg"),
                backdropPath: URL(string: "/k9kPIikcQBzl93nSyXUfqc74J9S.jpg"),
                popularity: 6.990147,
                voteAverage: 7.3,
                voteCount: 121
            )
        ]
    )
    // swiftlint:enable line_length

}
