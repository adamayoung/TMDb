@testable import TMDb
import XCTest

final class TwitterLinkTests: XCTestCase {

    func testURL() throws {
        let twitterID = "barbiethemovie"
        let expectedURL = try XCTUnwrap(URL(string: "https://www.twitter.com/\(twitterID)"))

        let twitterLink = TwitterLink(twitterID: twitterID)

        XCTAssertEqual(twitterLink?.url, expectedURL)
    }

}
