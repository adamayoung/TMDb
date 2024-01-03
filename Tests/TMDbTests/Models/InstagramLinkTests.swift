@testable import TMDb
import XCTest

final class InstagramLinkTests: XCTestCase {

    func testURL() throws {
        let instagramID = "barbiethemovie"
        let expectedURL = try XCTUnwrap(URL(string: "https://www.instagram.com/\(instagramID)"))

        let instagramLink = InstagramLink(instagramID: instagramID)

        XCTAssertEqual(instagramLink?.url, expectedURL)
    }

}
