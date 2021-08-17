@testable import TMDb
import XCTest

final class VideoSizeTests: XCTestCase {

    func test360VideoSizeReturnsRawValue() {
        XCTAssertEqual(VideoSize.s360.rawValue, 360)
    }

    func test480VideoSizeReturnsRawValue() {
        XCTAssertEqual(VideoSize.s480.rawValue, 480)
    }

    func test720VideoSizeReturnsRawValue() {
        XCTAssertEqual(VideoSize.s720.rawValue, 720)
    }

    func test1080VideoSizeReturnsRawValue() {
        XCTAssertEqual(VideoSize.s1080.rawValue, 1080)
    }

}
