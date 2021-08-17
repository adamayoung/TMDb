@testable import TMDb
import XCTest

final class PosterURLProvidingTests: XCTestCase {

    var providerWithURL: TestPosterProvider!
    var providerWithNilURL: TestPosterProvider!
    var posterPath: URL!

    override func setUp() {
        super.setUp()

        posterPath = URL(string: "/some/path/to/image.jpg")
        providerWithURL = TestPosterProvider(posterPath: posterPath)
        providerWithNilURL = TestPosterProvider()
    }

    override func tearDown() {
        posterPath = nil
        providerWithURL = nil
        providerWithNilURL = nil

        super.tearDown()
    }

    func testPosterOriginalURLReturnsURL() {
        let expectedResult = URL.tmdbImageBaseURL
            .appendingPathComponent("original")
            .appendingPathComponent(posterPath.absoluteString)

        let result = providerWithURL.posterOriginalURL

        XCTAssertEqual(result, expectedResult)
    }

    func testPosterOriginalURLReturnsNil() {
        let result = providerWithNilURL.posterOriginalURL

        XCTAssertNil(result)
    }

    func testPosterLargeURLReturnsURL() {
        let expectedResult = URL.tmdbImageBaseURL
            .appendingPathComponent("w780")
            .appendingPathComponent(posterPath.absoluteString)

        let result = providerWithURL.posterLargeURL

        XCTAssertEqual(result, expectedResult)
    }

    func testPosterLargeURLReturnsNil() {
        let result = providerWithNilURL.posterLargeURL

        XCTAssertNil(result)
    }

    func testPosterMediumURLReturnsURL() {
        let expectedResult = URL.tmdbImageBaseURL
            .appendingPathComponent("w342")
            .appendingPathComponent(posterPath.absoluteString)

        let result = providerWithURL.posterMediumURL

        XCTAssertEqual(result, expectedResult)
    }

    func testPosterMediumURLReturnsNil() {
        let result = providerWithNilURL.posterMediumURL

        XCTAssertNil(result)
    }

    func testPosterSmallURLReturnsURL() {
        let expectedResult = URL.tmdbImageBaseURL
            .appendingPathComponent("w154")
            .appendingPathComponent(posterPath.absoluteString)

        let result = providerWithURL.posterSmallURL

        XCTAssertEqual(result, expectedResult)
    }

    func testPosterSmallURLReturnsNil() {
        let result = providerWithNilURL.posterSmallURL

        XCTAssertNil(result)
    }

    func testPosterAspectRatioReturnsAspectRatio() {
        let expectedResult = 100.0 / 150.0

        let result = TestPosterProvider.posterAspectRatio

        XCTAssertEqual(result, expectedResult)
    }

}

extension PosterURLProvidingTests {

    struct TestPosterProvider: PosterURLProviding {

        let posterPath: URL?

        init(posterPath: URL? = nil) {
            self.posterPath = posterPath
        }

    }

}
