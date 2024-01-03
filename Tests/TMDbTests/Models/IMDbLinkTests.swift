@testable import TMDb
import XCTest

final class IMDbLinkTests: XCTestCase {

    func testShowURL() throws {
        let imdbID = "tt1517268"
        let expectedURL = try XCTUnwrap(URL(string: "https://www.imdb.com/title/\(imdbID)/"))

        let imdbLink = IMDbLink(imdbTitleID: imdbID)

        XCTAssertEqual(imdbLink?.url, expectedURL)
    }

    func testPersonURL() throws {
        let imdbID = "nm3592338"
        let expectedURL = try XCTUnwrap(URL(string: "https://www.imdb.com/name/\(imdbID)/"))

        let imdbLink = IMDbLink(imdbNameID: imdbID)

        XCTAssertEqual(imdbLink?.url, expectedURL)
    }

}
