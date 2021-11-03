@testable import TMDb
import XCTest

final class ProfileURLProvidingTests: XCTestCase {

    var providerWithURL: TestProfileProvider!
    var providerWithNilURL: TestProfileProvider!
    var profilePath: URL!

    override func setUp() {
        super.setUp()

        profilePath = URL(string: "/some/path/to/image.jpg")
        providerWithURL = TestProfileProvider(profilePath: profilePath)
        providerWithNilURL = TestProfileProvider()
    }

    override func tearDown() {
        profilePath = nil
        providerWithURL = nil
        providerWithNilURL = nil

        super.tearDown()
    }

    func testProfileOriginalURLReturnsURL() {
        let expectedResult = URL.tmdbImageBaseURL
            .appendingPathComponent("original")
            .appendingPathComponent(profilePath.absoluteString)

        let result = providerWithURL.profileOriginalURL

        XCTAssertEqual(result, expectedResult)
    }

    func testProfileOriginalURLReturnsNil() {
        let result = providerWithNilURL.profileOriginalURL

        XCTAssertNil(result)
    }

    func testProfileLargeURLReturnsURL() {
        let expectedResult = URL.tmdbImageBaseURL
            .appendingPathComponent("h632")
            .appendingPathComponent(profilePath.absoluteString)

        let result = providerWithURL.profileLargeURL

        XCTAssertEqual(result, expectedResult)
    }

    func testProfileLargeURLReturnsNil() {
        let result = providerWithNilURL.profileLargeURL

        XCTAssertNil(result)
    }

    func testProfileMediumURLReturnsURL() {
        let expectedResult = URL.tmdbImageBaseURL
            .appendingPathComponent("w185")
            .appendingPathComponent(profilePath.absoluteString)

        let result = providerWithURL.profileMediumURL

        XCTAssertEqual(result, expectedResult)
    }

    func testProfileMediumURLReturnsNil() {
        let result = providerWithNilURL.profileMediumURL

        XCTAssertNil(result)
    }

    func testProfileSmallURLReturnsURL() {
        let expectedResult = URL.tmdbImageBaseURL
            .appendingPathComponent("w45")
            .appendingPathComponent(profilePath.absoluteString)

        let result = providerWithURL.profileSmallURL

        XCTAssertEqual(result, expectedResult)
    }

    func testProfileSmallURLReturnsNil() {
        let result = providerWithNilURL.profileSmallURL

        XCTAssertNil(result)
    }

    func testProfileAspectRatioReturnsAspectRatio() {
        let expectedResult = 100.0 / 150.0

        let result = TestProfileProvider.profileAspectRatio

        XCTAssertEqual(result, expectedResult)
    }

}

extension ProfileURLProvidingTests {

    struct TestProfileProvider: ProfileURLProviding {

        let profilePath: URL?

        init(profilePath: URL? = nil) {
            self.profilePath = profilePath
        }

    }

}
