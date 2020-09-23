@testable import TMDb
import XCTest

class NetworkDTOTests: XCTestCase {

    func testDecodeReturnsNetwork() throws {
        let data = json.data(using: .utf8)!
        let result = try JSONDecoder.theMovieDatabase.decode(NetworkDTO.self, from: data)

        XCTAssertEqual(result, network)
    }

    private let json = """
    {
        "name": "HBO",
        "id": 49,
        "logo_path": "/tuomPhY2UtuPTqqFnKMVHvSb724.png",
        "origin_country": "US"
    }
    """

    private let network = NetworkDTO(
        id: 49,
        name: "HBO",
        logoPath: URL(string: "/tuomPhY2UtuPTqqFnKMVHvSb724.png"),
        originCountry: "US"
    )

}
