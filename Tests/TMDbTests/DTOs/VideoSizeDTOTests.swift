@testable import TMDb
import XCTest

class VideoSizeDTOTests: XCTestCase {

    func test360VideoSizeReturnsRawValue() {
        XCTAssertEqual(VideoSizeDTO.s360.rawValue, 360)
    }

    func test480VideoSizeReturnsRawValue() {
        XCTAssertEqual(VideoSizeDTO.s480.rawValue, 480)
    }

    func test720VideoSizeReturnsRawValue() {
        XCTAssertEqual(VideoSizeDTO.s720.rawValue, 720)
    }

    func test1080VideoSizeReturnsRawValue() {
        XCTAssertEqual(VideoSizeDTO.s1080.rawValue, 1080)
    }

}
