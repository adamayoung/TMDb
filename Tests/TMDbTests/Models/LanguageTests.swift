@testable import TMDb
import XCTest

final class LanguageTests: XCTestCase {

    func testIDReturnsCode() {
        XCTAssertEqual(language.id, language.code)
    }

    func testDecodeReturnsCertification() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(Language.self, fromResource: "configuration-language")

        XCTAssertEqual(result.code, language.code)
        XCTAssertEqual(result.name, language.name)
        XCTAssertEqual(result.englishName, language.englishName)
    }

    private let language = Language(
        code: "tr",
        name: "Türkçe",
        englishName: "Turkish"
    )

}
