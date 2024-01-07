@testable import TMDb
import XCTest

final class VideoTypeTests: XCTestCase {

    func testTrailerVideoTypeReturnsRawValue() {
        XCTAssertEqual(VideoType.trailer.rawValue, "Trailer")
    }

    func testTeaserVideoTypeReturnsRawValue() {
        XCTAssertEqual(VideoType.teaser.rawValue, "Teaser")
    }

    func testClipVideoTypeReturnsRawValue() {
        XCTAssertEqual(VideoType.clip.rawValue, "Clip")
    }

    func testOpeningCreditsVideoTypeReturnsRawValue() {
        XCTAssertEqual(VideoType.openingCredits.rawValue, "Opening Credits")
    }

    func testFeaturetteVideoTypeReturnsRawValue() {
        XCTAssertEqual(VideoType.featurette.rawValue, "Featurette")
    }

    func testBehindTheScenesVideoTypeReturnsRawValue() {
        XCTAssertEqual(VideoType.behindTheScenes.rawValue, "Behind the Scenes")
    }

    func testBloopersVideoTypeReturnsRawValue() {
        XCTAssertEqual(VideoType.bloopers.rawValue, "Bloopers")
    }

    func testDecodeWhenInvalidValueReturnsUnknown() throws {
        let data = Data("{\"videoType\": \"some-value\"}".utf8)
        let decoder = JSONDecoder()

        let result = try decoder.decode(MockObject.self, from: data).videoType

        XCTAssertEqual(result, .unknown)
    }

}

extension VideoTypeTests {

    private struct MockObject: Decodable {
        let videoType: VideoType
    }

}
