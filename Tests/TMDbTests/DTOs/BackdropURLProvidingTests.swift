@testable import TMDb
import XCTest

class BackdropURLProvidingTests: XCTestCase {

    var providerWithURL: TestBackdropProvider!
    var providerWithNilURL: TestBackdropProvider!
    var backdropPath: URL!

    override func setUp() {
        super.setUp()

        backdropPath = URL(string: "/some/path/to/image.jpg")
        providerWithURL = TestBackdropProvider(backdropPath: backdropPath)
        providerWithNilURL = TestBackdropProvider()
    }

    override func tearDown() {
        backdropPath = nil
        providerWithURL = nil
        providerWithNilURL = nil

        super.tearDown()
    }

    func testBackdropOriginalURLReturnsURL() {
        let expectedResult = URL.tmdbImageBaseURL
            .appendingPathComponent("original")
            .appendingPathComponent(backdropPath.absoluteString)

        let result = providerWithURL.backdropOriginalURL

        XCTAssertEqual(result, expectedResult)
    }

    func testBackdropOriginalURLReturnsNil() {
        let result = providerWithNilURL.backdropOriginalURL

        XCTAssertNil(result)
    }

    func testBackdropLargeURLReturnsURL() {
        let expectedResult = URL.tmdbImageBaseURL
            .appendingPathComponent("w1280")
            .appendingPathComponent(backdropPath.absoluteString)

        let result = providerWithURL.backdropLargeURL

        XCTAssertEqual(result, expectedResult)
    }

    func testBackdropLargeURLReturnsNil() {
        let result = providerWithNilURL.backdropLargeURL

        XCTAssertNil(result)
    }

    func testBackdropMediumURLReturnsURL() {
        let expectedResult = URL.tmdbImageBaseURL
            .appendingPathComponent("w780")
            .appendingPathComponent(backdropPath.absoluteString)

        let result = providerWithURL.backdropMediumURL

        XCTAssertEqual(result, expectedResult)
    }

    func testBackdropMediumURLReturnsNil() {
        let result = providerWithNilURL.backdropMediumURL

        XCTAssertNil(result)
    }

    func testBackdropSmallURLReturnsURL() {
        let expectedResult = URL.tmdbImageBaseURL
            .appendingPathComponent("w300")
            .appendingPathComponent(backdropPath.absoluteString)

        let result = providerWithURL.backdropSmallURL

        XCTAssertEqual(result, expectedResult)
    }

    func testBackdropSmallURLReturnsNil() {
        let result = providerWithNilURL.backdropSmallURL

        XCTAssertNil(result)
    }

    func testBackdropAspectRatioReturnsAspectRatio() {
        let expectedResult: Float = 500 / 281

        let result = TestBackdropProvider.backdropAspectRatio

        XCTAssertEqual(result, expectedResult)
    }

}

extension BackdropURLProvidingTests {

    struct TestBackdropProvider: BackdropURLProviding {

        let backdropPath: URL?

        init(backdropPath: URL? = nil) {
            self.backdropPath = backdropPath
        }

    }

}
