@testable import TMDb
import XCTest

final class CastMemberTests: XCTestCase {

    func testDecodeReturnsCastMember() throws {
        let data = json.data(using: .utf8)!
        let result = try JSONDecoder.theMovieDatabase.decode(CastMember.self, from: data)

        XCTAssertEqual(result, castMember)
    }

    private let json = """
    {
      "cast_id": 4,
      "character": "The Narrator",
      "credit_id": "52fe4250c3a36847f80149f3",
      "gender": 2,
      "id": 819,
      "name": "Edward Norton",
      "order": 0,
      "profile_path": "/eIkFHNlfretLS1spAcIoihKUS62.jpg"
    }
    """

    private let castMember = CastMember(
        id: 819,
        castID: 4,
        creditID: "52fe4250c3a36847f80149f3",
        name: "Edward Norton",
        character: "The Narrator",
        gender: .male,
        profilePath: URL(string: "/eIkFHNlfretLS1spAcIoihKUS62.jpg"),
        order: 0
    )

}
