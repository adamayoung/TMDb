@testable import TMDb
import XCTest

class PersonTVShowCreditsTests: XCTestCase {

    func testDecodeReturnsPersonTVShowCredits() throws {
        let data = json.data(using: .utf8)!
        let result = try JSONDecoder.theMovieDatabase.decode(PersonTVShowCredits.self, from: data)

        XCTAssertEqual(result.id, personTVShowCredits.id)
        XCTAssertEqual(result.cast, personTVShowCredits.cast)
        XCTAssertEqual(result.crew, personTVShowCredits.crew)
    }

    // swiftlint:disable line_length
    private let json = """
    {
      "cast": [
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
          "poster_path": "/eKyeUFwjc0LhPSp129IHpXniJVR.jpg",
          "first_air_date": "1985-09-24",
          "vote_average": 6.2,
          "vote_count": 25,
          "character": "",
          "backdrop_path": "/xYpXcp7S8pStWihcksTQQue3jlV.jpg",
          "popularity": 2.883124,
          "credit_id": "525333fb19c295794002c720"
        }
      ],
      "crew": [
        {
          "id": 69061,
          "department": "Production",
          "original_language": "en",
          "episode_count": 8,
          "job": "Executive Producer",
          "overview": "Prairie Johnson, blind as a child, comes home to the community she grew up in with her sight restored. Some hail her a miracle, others a dangerous mystery, but Prairie won’t talk with the FBI or her parents about the seven years she went missing.",
          "origin_country": [],
          "original_name": "The OA",
          "vote_count": 121,
          "name": "The OA",
          "popularity": 6.990147,
          "credit_id": "58cf92ae9251415a7d0339c3",
          "backdrop_path": "/k9kPIikcQBzl93nSyXUfqc74J9S.jpg",
          "first_air_date": "2016-12-16",
          "vote_average": 7.3,
          "genre_ids": [
            18,
            9648,
            10765
          ],
          "poster_path": "/ppSiYu2D0nw6KNF0kf5lKDxOGRR.jpg"
        }
      ],
      "id": 287
    }
    """

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
