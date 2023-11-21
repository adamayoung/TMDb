//
//  SpokenLanguageTests.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

@testable import TMDb
import XCTest

final class SpokenLanguageTests: XCTestCase {

    func testIDReturnsISO6391() {
        XCTAssertEqual(spokenLanguage.id, spokenLanguage.languageCode)
    }

    func testDecodeReturnsSpokenLanguage() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(SpokenLanguage.self, fromResource: "spoken-language")

        XCTAssertEqual(result.languageCode, spokenLanguage.languageCode)
        XCTAssertEqual(result.name, spokenLanguage.name)
    }

    private let spokenLanguage = SpokenLanguage(
        languageCode: "en",
        name: "English"
    )

}
