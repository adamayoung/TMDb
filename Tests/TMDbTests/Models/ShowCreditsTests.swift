@testable import TMDb
import XCTest

class ShowCreditsTests: XCTestCase {

    func testDecodeReturnsShowCredits() throws {
        let data = json.data(using: .utf8)!
        let result = try JSONDecoder.theMovieDatabase.decode(ShowCredits.self, from: data)

        XCTAssertEqual(result.id, showCredits.id)
        XCTAssertEqual(result.cast, showCredits.cast)
        XCTAssertEqual(result.crew, showCredits.crew)
    }

    private let json = """
    {
      "id": 550,
      "cast": [
        {
          "cast_id": 4,
          "character": "The Narrator",
          "credit_id": "52fe4250c3a36847f80149f3",
          "gender": 2,
          "id": 819,
          "name": "Edward Norton",
          "order": 0,
          "profile_path": "/eIkFHNlfretLS1spAcIoihKUS62.jpg"
        },
        {
          "cast_id": 5,
          "character": "Tyler Durden",
          "credit_id": "52fe4250c3a36847f80149f7",
          "gender": 2,
          "id": 287,
          "name": "Brad Pitt",
          "order": 1,
          "profile_path": "/kc3M04QQAuZ9woUvH3Ju5T7ZqG5.jpg"
        },
        {
          "cast_id": 7,
          "character": "Robert 'Bob' Paulson",
          "credit_id": "52fe4250c3a36847f80149ff",
          "gender": 2,
          "id": 7470,
          "name": "Meat Loaf",
          "order": 2,
          "profile_path": "/43nyfW3TxD3PxDqYB8tyqaKpDBH.jpg"
        }
      ],
      "crew": [
        {
          "credit_id": "56380f0cc3a3681b5c0200be",
          "department": "Writing",
          "gender": 0,
          "id": 7469,
          "job": "Screenplay",
          "name": "Jim Uhls",
          "profile_path": null
        },
        {
          "credit_id": "52fe4250c3a36847f8014a05",
          "department": "Production",
          "gender": 0,
          "id": 7474,
          "job": "Producer",
          "name": "Ross Grayson Bell",
          "profile_path": null
        }
      ]
    }
    """

    private let showCredits = ShowCredits(
        id: 550,
        cast: [
            CastMember(
                id: 819,
                castID: 4,
                creditID: "52fe4250c3a36847f80149f3",
                name: "Edward Norton",
                character: "The Narrator",
                gender: .male,
                profilePath: URL(string: "/eIkFHNlfretLS1spAcIoihKUS62.jpg"),
                order: 0
            ),
            CastMember(
                id: 287,
                castID: 5,
                creditID: "52fe4250c3a36847f80149f7",
                name: "Brad Pitt",
                character: "Tyler Durden",
                gender: .male,
                profilePath: URL(string: "/kc3M04QQAuZ9woUvH3Ju5T7ZqG5.jpg"),
                order: 1
            ),
            CastMember(
                id: 7470,
                castID: 7,
                creditID: "52fe4250c3a36847f80149ff",
                name: "Meat Loaf",
                character: "Robert 'Bob' Paulson",
                gender: .male,
                profilePath: URL(string: "/43nyfW3TxD3PxDqYB8tyqaKpDBH.jpg"),
                order: 2
            )
        ],
        crew: [
            CrewMember(
                id: 7469,
                creditID: "56380f0cc3a3681b5c0200be",
                name: "Jim Uhls",
                job: "Screenplay",
                department: "Writing",
                gender: .unknown,
                profilePath: nil
            ),
            CrewMember(
                id: 7474,
                creditID: "52fe4250c3a36847f8014a05",
                name: "Ross Grayson Bell",
                job: "Producer",
                department: "Production",
                gender: .unknown,
                profilePath: nil
            )
        ]
    )

}
