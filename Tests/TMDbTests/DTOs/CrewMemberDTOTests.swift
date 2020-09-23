@testable import TMDb
import XCTest

class CrewMemberDTOTests: XCTestCase {

    func testDecodeReturnsCrewMember() throws {
        let data = json.data(using: .utf8)!
        let result = try JSONDecoder.theMovieDatabase.decode(CrewMemberDTO.self, from: data)

        XCTAssertEqual(result, crewMember)
    }

    private let json = """
    {
        "credit_id": "52fe4250c3a36847f8014a11",
        "department": "Production",
        "gender": 0,
        "id": 1254,
        "job": "Producer",
        "name": "Art Linson",
        "profile_path": "/dEtVivCXxQBtIzmJcUNupT1AB4H.jpg"
    }
    """

    private let crewMember = CrewMemberDTO(
        id: 1254,
        creditID: "52fe4250c3a36847f8014a11",
        name: "Art Linson",
        job: "Producer",
        department: "Production",
        gender: .unknown,
        profilePath: URL(string: "/dEtVivCXxQBtIzmJcUNupT1AB4H.jpg")
    )

}
