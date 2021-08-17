@testable import TMDb
import XCTest

final class StillURLProvidingTests: XCTestCase {

    var providerWithURL: TestStillProvider!
    var providerWithNilURL: TestStillProvider!
    var stillPath: URL!

    override func setUp() {
        super.setUp()

        stillPath = URL(string: "/some/path/to/image.jpg")
        providerWithURL = TestStillProvider(stillPath: stillPath)
        providerWithNilURL = TestStillProvider()
    }

    override func tearDown() {
        stillPath = nil
        providerWithURL = nil
        providerWithNilURL = nil

        super.tearDown()
    }

    func testStillOriginalURLReturnsURL() {
        let expectedResult = URL.tmdbImageBaseURL
            .appendingPathComponent("original")
            .appendingPathComponent(stillPath.absoluteString)

        let result = providerWithURL.stillOriginalURL

        XCTAssertEqual(result, expectedResult)
    }

    func testStillOriginalURLReturnsNil() {
        let result = providerWithNilURL.stillOriginalURL

        XCTAssertNil(result)
    }

    func testStillLargeURLReturnsURL() {
        let expectedResult = URL.tmdbImageBaseURL
            .appendingPathComponent("w300")
            .appendingPathComponent(stillPath.absoluteString)

        let result = providerWithURL.stillLargeURL

        XCTAssertEqual(result, expectedResult)
    }

    func testStillLargeURLReturnsNil() {
        let result = providerWithNilURL.stillLargeURL

        XCTAssertNil(result)
    }

    func testStillMediumURLReturnsURL() {
        let expectedResult = URL.tmdbImageBaseURL
            .appendingPathComponent("w185")
            .appendingPathComponent(stillPath.absoluteString)

        let result = providerWithURL.stillMediumURL

        XCTAssertEqual(result, expectedResult)
    }

    func testStillMediumURLReturnsNil() {
        let result = providerWithNilURL.stillMediumURL

        XCTAssertNil(result)
    }

    func testStillSmallURLReturnsURL() {
        let expectedResult = URL.tmdbImageBaseURL
            .appendingPathComponent("w92")
            .appendingPathComponent(stillPath.absoluteString)

        let result = providerWithURL.stillSmallURL

        XCTAssertEqual(result, expectedResult)
    }

    func testStillSmallURLReturnsNil() {
        let result = providerWithNilURL.stillSmallURL

        XCTAssertNil(result)
    }

    func testStillAspectRatioReturnsAspectRatio() {
        let expectedResult = 500.0 / 281.0

        let result = TestStillProvider.stillAspectRatio

        XCTAssertEqual(result, expectedResult)
    }

}

extension StillURLProvidingTests {

    struct TestStillProvider: StillURLProviding {

        let stillPath: URL?

        init(stillPath: URL? = nil) {
            self.stillPath = stillPath
        }

    }

}
