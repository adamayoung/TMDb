@testable import TMDb
import XCTest

final class PersonCombinedCreditsTests: XCTestCase {

    func testDecodeReturnsPersonCombinedCredits() throws {
        let data = json.data(using: .utf8)!
        let result = try JSONDecoder.theMovieDatabase.decode(PersonCombinedCredits.self, from: data)

        XCTAssertEqual(result.id, personCombinedCredits.id)
        XCTAssertEqual(result.cast, personCombinedCredits.cast)
        XCTAssertEqual(result.crew, personCombinedCredits.crew)
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
          "media_type": "tv",
          "poster_path": "/eKyeUFwjc0LhPSp129IHpXniJVR.jpg",
          "first_air_date": "1985-09-24",
          "vote_average": 6.2,
          "vote_count": 25,
          "character": "",
          "backdrop_path": "/xYpXcp7S8pStWihcksTQQue3jlV.jpg",
          "popularity": 2.883124,
          "credit_id": "525333fb19c295794002c720"
        },
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
          "media_type": "tv",
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
        },
        {
          "id": 174349,
          "department": "Production",
          "original_language": "en",
          "original_title": "Big Men",
          "job": "Executive Producer",
          "overview": "For her latest industrial exposé, Rachel Boynton (Our Brand Is Crisis) gained unprecedented access to Africa's oil companies. The result is a gripping account of the costly personal tolls levied when American corporate interests pursue oil in places like Ghana and the Niger River Delta. Executive produced by Steven Shainberg and Brad Pitt, Big Men investigates the caustic blend of ambition, corruption and greed that threatens to exacerbate Africa’s resource curse.",
          "genre_ids": [
            99
          ],
          "video": false,
          "media_type": "movie",
          "credit_id": "52fe4d49c3a36847f8258cf3",
          "poster_path": "/q5uKDMl1PXIeMoD10CTbXST7XoN.jpg",
          "popularity": 1.214663,
          "backdrop_path": "/ieWzXfEx3AU9QANrGkbqeXgLeNH.jpg",
          "vote_count": 7,
          "title": "Big Men",
          "adult": false,
          "vote_average": 6.4,
          "release_date": "2014-03-14"
        }
      ],
      "id": 287
    }
    """

    private let personCombinedCredits = PersonCombinedCredits(
        id: 287,
        cast: [
            .tvShow(TVShow(
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
            )),
            .movie(Movie(
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
        ],
        crew: [
            .tvShow(TVShow(
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
            )),
            .movie(Movie(
                id: 174349,
                title: "Big Men",
                originalTitle: "Big Men",
                originalLanguage: "en",
                overview: "For her latest industrial exposé, Rachel Boynton (Our Brand Is Crisis) gained unprecedented access to Africa's oil companies. The result is a gripping account of the costly personal tolls levied when American corporate interests pursue oil in places like Ghana and the Niger River Delta. Executive produced by Steven Shainberg and Brad Pitt, Big Men investigates the caustic blend of ambition, corruption and greed that threatens to exacerbate Africa’s resource curse.",
                releaseDate: DateFormatter.theMovieDatabase.date(from: "2014-03-14"),
                posterPath: URL(string: "/q5uKDMl1PXIeMoD10CTbXST7XoN.jpg"),
                backdropPath: URL(string: "/ieWzXfEx3AU9QANrGkbqeXgLeNH.jpg"),
                popularity: 1.214663,
                voteAverage: 6.4,
                voteCount: 7,
                video: false,
                adult: false
            ))
        ]
    )
    // swiftlint:enable line_length

}
