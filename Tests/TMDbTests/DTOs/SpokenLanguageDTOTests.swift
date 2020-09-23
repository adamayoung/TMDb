@testable import TMDb
import XCTest

class SpokenLanguageDTOTests: XCTestCase {

    func testIDReturnsISO6391() {
        XCTAssertEqual(spokenLanguage.id, spokenLanguage.iso6391)
    }

    func testDecodeReturnsSpokenLanguage() throws {
        let data = json.data(using: .utf8)!
        let result = try JSONDecoder.theMovieDatabase.decode(SpokenLanguageDTO.self, from: data)

        XCTAssertEqual(result, spokenLanguage)
    }

    private let json = """
    {
        "iso_639_1": "en",
        "name": "English"
    }
    """

    private let spokenLanguage = SpokenLanguageDTO(
        iso6391: "en",
        name: "English"
    )

}
