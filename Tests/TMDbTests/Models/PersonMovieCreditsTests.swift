@testable import TMDb
import XCTest

final class PersonMovieCreditsTests: XCTestCase {

    func testDecodeReturnsPersonMovieCredits() throws {
        let data = json.data(using: .utf8)!
        let result = try JSONDecoder.theMovieDatabase.decode(PersonMovieCredits.self, from: data)

        XCTAssertEqual(result.id, personMovieCredits.id)
        XCTAssertEqual(result.cast, personMovieCredits.cast)
        XCTAssertEqual(result.crew, personMovieCredits.crew)
    }

    // swiftlint:disable line_length
    private let json = """
    {
      "cast": [
        {
          "id": 109091,
          "original_language": "en",
          "original_title": "The Counselor",
          "overview": "A rich and successful lawyer named Counselor is about to get married to his fiancée but soon meets up with the middle-man known as Westray who tells him his drug trafficking plan has taken a horrible twist and now he must protect himself and his soon bride-to-be lover as the truth of the drug business uncovers and targets become chosen.",
          "vote_count": 661,
          "video": false,
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

    private let personMovieCredits = PersonMovieCredits(
        id: 287,
        cast: [
            Movie(
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
        ],
        crew: [
            Movie(
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
            )
        ]
    )
    // swiftlint:enable line_length

}
