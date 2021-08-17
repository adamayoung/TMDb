@testable import TMDb
import XCTest

final class LogoURLProvidingTests: XCTestCase {

    var providerWithURL: TestLogoProvider!
    var providerWithNilURL: TestLogoProvider!
    var logoPath: URL!

    override func setUp() {
        super.setUp()

        logoPath = URL(string: "/some/path/to/image.jpg")
        providerWithURL = TestLogoProvider(logoPath: logoPath)
        providerWithNilURL = TestLogoProvider()
    }

    override func tearDown() {
        logoPath = nil
        providerWithURL = nil
        providerWithNilURL = nil

        super.tearDown()
    }

    func testLogoOriginalURLReturnsURL() {
        let expectedResult = URL.tmdbImageBaseURL
            .appendingPathComponent("original")
            .appendingPathComponent(logoPath.absoluteString)

        let result = providerWithURL.logoOriginalURL

        XCTAssertEqual(result, expectedResult)
    }

    func testLogoOriginalURLReturnsNil() {
        let result = providerWithNilURL.logoOriginalURL

        XCTAssertNil(result)
    }

    func testLogoLargeURLReturnsURL() {
        let expectedResult = URL.tmdbImageBaseURL
            .appendingPathComponent("w500")
            .appendingPathComponent(logoPath.absoluteString)

        let result = providerWithURL.logoLargeURL

        XCTAssertEqual(result, expectedResult)
    }

    func testLogoLargeURLReturnsNil() {
        let result = providerWithNilURL.logoLargeURL

        XCTAssertNil(result)
    }

    func testLogoMediumURLReturnsURL() {
        let expectedResult = URL.tmdbImageBaseURL
            .appendingPathComponent("w185")
            .appendingPathComponent(logoPath.absoluteString)

        let result = providerWithURL.logoMediumURL

        XCTAssertEqual(result, expectedResult)
    }

    func testLogoMediumURLReturnsNil() {
        let result = providerWithNilURL.logoMediumURL

        XCTAssertNil(result)
    }

    func testLogoSmallURLReturnsURL() {
        let expectedResult = URL.tmdbImageBaseURL
            .appendingPathComponent("w92")
            .appendingPathComponent(logoPath.absoluteString)

        let result = providerWithURL.logoSmallURL

        XCTAssertEqual(result, expectedResult)
    }

    func testLogoSmallURLReturnsNil() {
        let result = providerWithNilURL.logoSmallURL

        XCTAssertNil(result)
    }

}

extension LogoURLProvidingTests {

    struct TestLogoProvider: LogoURLProviding {

        let logoPath: URL?

        init(logoPath: URL? = nil) {
            self.logoPath = logoPath
        }

    }

}
