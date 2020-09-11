@testable import TMDb
import XCTest

class VideoSizeTests: XCTestCase {

    func test360VideoSize_returnsRawValue() {
        XCTAssertEqual(VideoSize.s360.rawValue, 360)
    }

    func test480VideoSize_returnsRawValue() {
        XCTAssertEqual(VideoSize.s480.rawValue, 480)
    }

    func test720VideoSize_returnsRawValue() {
        XCTAssertEqual(VideoSize.s720.rawValue, 720)
    }

    func test1080VideoSize_returnsRawValue() {
        XCTAssertEqual(VideoSize.s1080.rawValue, 1080)
    }

}
