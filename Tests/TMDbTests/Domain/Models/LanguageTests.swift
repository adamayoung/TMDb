//
//  LanguageTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing

@testable import TMDb

@Suite(.tags(.models))
struct LanguageTests {

    @Test("ID is equal to code")
    func idReturnsCode() {
        #expect(language.id == language.code)
    }

    @Test("JSON decoding of Language", .tags(.decoding))
    func decodeReturnsLanguage() throws {
        let result = try JSONDecoder.theMovieDatabase.decode(
            Language.self, fromResource: "configuration-language"
        )

        #expect(result.code == language.code)
        #expect(result.name == language.name)
        #expect(result.englishName == language.englishName)
    }

    private let language = Language(
        code: "tr",
        name: "Türkçe",
        englishName: "Turkish"
    )

}
