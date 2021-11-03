@testable import TMDb
import XCTest

final class SpokenLanguageTests: XCTestCase {

    func testIDReturnsISO6391() {
        XCTAssertEqual(spokenLanguage.id, spokenLanguage.iso6391)
    }

    func testDecodeReturnsSpokenLanguage() throws {
        let data = json.data(using: .utf8)!
        let result = try JSONDecoder.theMovieDatabase.decode(SpokenLanguage.self, from: data)

        XCTAssertEqual(result, spokenLanguage)
    }

    private let json = """
    {
        "iso_639_1": "en",
        "name": "English"
    }
    """

    private let spokenLanguage = SpokenLanguage(
        iso6391: "en",
        name: "English"
    )

}
