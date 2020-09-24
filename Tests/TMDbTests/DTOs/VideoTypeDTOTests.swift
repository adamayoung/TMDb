@testable import TMDb
import XCTest

class VideoTypeDTOTests: XCTestCase {

    func testTrailerVideoTypeReturnsRawValue() {
        XCTAssertEqual(VideoTypeDTO.trailer.rawValue, "Trailer")
    }

    func testTeaserVideoTypeReturnsRawValue() {
        XCTAssertEqual(VideoTypeDTO.teaser.rawValue, "Teaser")
    }

    func testClipVideoTypeReturnsRawValue() {
        XCTAssertEqual(VideoTypeDTO.clip.rawValue, "Clip")
    }

    func testOpeningCreditsVideoTypeReturnsRawValue() {
        XCTAssertEqual(VideoTypeDTO.openingCredits.rawValue, "Opening Credits")
    }

    func testFeaturetteVideoTypeReturnsRawValue() {
        XCTAssertEqual(VideoTypeDTO.featurette.rawValue, "Featurette")
    }

    func testBehindTheScenesVideoTypeReturnsRawValue() {
        XCTAssertEqual(VideoTypeDTO.behindTheScenes.rawValue, "Behind the Scenes")
    }

    func testBloopersVideoTypeReturnsRawValue() {
        XCTAssertEqual(VideoTypeDTO.bloopers.rawValue, "Bloopers")
    }

}
