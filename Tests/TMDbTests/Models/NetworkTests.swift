@testable import TMDb
import XCTest

final class NetworkTests: XCTestCase {

    func testDecodeReturnsNetwork() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(Network.self, fromResource: "network")

        XCTAssertEqual(result.id, network.id)
        XCTAssertEqual(result.name, network.name)
        XCTAssertEqual(result.logoPath, network.logoPath)
        XCTAssertEqual(result.originCountry, network.originCountry)
    }

    private let network = Network(
        id: 49,
        name: "HBO",
        logoPath: URL(string: "/tuomPhY2UtuPTqqFnKMVHvSb724.png"),
        originCountry: "US"
    )

}
