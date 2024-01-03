@testable import TMDb
import XCTest

final class WikiDataLinkTests: XCTestCase {

    func testURL() throws {
        let wikiDataID = "Q55436290"
        let expectedURL = try XCTUnwrap(URL(string: "https://www.wikidata.org/wiki/\(wikiDataID)"))

        let wikiDataLink = WikiDataLink(wikiDataID: wikiDataID)

        XCTAssertEqual(wikiDataLink?.url, expectedURL)
    }

}
