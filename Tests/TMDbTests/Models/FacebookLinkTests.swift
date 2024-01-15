@testable import TMDb
import XCTest

final class FacebookLinkTests: XCTestCase {

    func testInitWithFacebookIDWhenIDIsNilReturnsNil() {
        XCTAssertNil(FacebookLink(facebookID: nil))
    }

    func testURL() throws {
        let facebookID = "BarbieTheMovie"
        let expectedURL = try XCTUnwrap(URL(string: "https://www.facebook.com/\(facebookID)"))

        let facebookLink = FacebookLink(facebookID: facebookID)

        XCTAssertEqual(facebookLink?.url, expectedURL)
    }

}
