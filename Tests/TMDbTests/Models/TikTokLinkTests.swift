@testable import TMDb
import XCTest

final class TikTokLinkTests: XCTestCase {

    func testInitWithTikTokIDWhenIDIsNilReturnsNil() {
        XCTAssertNil(TikTokLink(tikTokID: nil))
    }

    func testURL() throws {
        let tikTokID = "jasonstatham"
        let expectedURL = try XCTUnwrap(URL(string: "https://www.tiktok.com/@\(tikTokID)"))

        let tikTokLink = TikTokLink(tikTokID: tikTokID)

        XCTAssertEqual(tikTokLink?.url, expectedURL)
    }

}
