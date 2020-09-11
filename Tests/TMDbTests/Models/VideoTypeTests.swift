@testable import TMDb
import XCTest

class VideoTypeTests: XCTestCase {

    func testTrailerVideoType_returnsRawValue() {
        XCTAssertEqual(VideoType.trailer.rawValue, "Trailer")
    }

    func testTeaserVideoType_returnsRawValue() {
        XCTAssertEqual(VideoType.teaser.rawValue, "Teaser")
    }

    func testClipVideoType_returnsRawValue() {
        XCTAssertEqual(VideoType.clip.rawValue, "Clip")
    }

    func testOpeningCreditsVideoType_returnsRawValue() {
        XCTAssertEqual(VideoType.openingCredits.rawValue, "Opening Credits")
    }

    func testFeaturetteVideoType_returnsRawValue() {
        XCTAssertEqual(VideoType.featurette.rawValue, "Featurette")
    }

    func testBehindTheScenesVideoType_returnsRawValue() {
        XCTAssertEqual(VideoType.behindTheScenes.rawValue, "Behind the Scenes")
    }

    func testBloopersVideoType_returnsRawValue() {
        XCTAssertEqual(VideoType.bloopers.rawValue, "Bloopers")
    }

}
