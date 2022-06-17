@testable import TMDb
import XCTest

final class CertificationTests: XCTestCase {

    func testIDReturnsCode() {
        XCTAssertEqual(certification.id, certification.code)
    }

    func testDecodeReturnsCertification() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(Certification.self, fromResource: "certification")

        XCTAssertEqual(result.code, certification.code)
        XCTAssertEqual(result.meaning, certification.meaning)
        XCTAssertEqual(result.order, certification.order)
    }

    // swiftlint:disable line_length
    private let certification = Certification(
        code: "15",
        meaning: "Only those over 15 years are admitted. Nobody younger than 15 can rent or buy a 15-rated VHS, DVD, Blu-ray Disc, UMD or game, or watch a film in the cinema with this rating. Films under this category can contain adult themes, hard drugs, frequent strong language and limited use of very strong language, strong violence and strong sex references, and nudity without graphic detail. Sexual activity may be portrayed but without any strong detail. Sexual violence may be shown if discreet and justified by context.",
        order: 5
    )
    // swiftlint:enable line_length

}
