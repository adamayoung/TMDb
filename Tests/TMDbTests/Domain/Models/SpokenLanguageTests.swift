//
//  SpokenLanguageTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.models))
struct SpokenLanguageTests {

    @Test("id returns language code")
    func idReturnsLanguageCode() {
        #expect(spokenLanguage.id == spokenLanguage.languageCode)
    }

    @Test("JSON decoding of SpokenLanguage", .tags(.decoding))
    func decodeReturnsSpokenLanguage() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            SpokenLanguage.self, fromResource: "spoken-language"
        )

        #expect(result.languageCode == spokenLanguage.languageCode)
        #expect(result.name == spokenLanguage.name)
    }

    private let spokenLanguage = SpokenLanguage(
        languageCode: "en",
        name: "English"
    )

}
