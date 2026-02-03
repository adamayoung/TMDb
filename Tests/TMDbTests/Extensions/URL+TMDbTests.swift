//
//  URL+TMDbTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite
struct URLTMDbTests {

    @Test("TMDb API base URL returns correct URL")
    func tmdbAPIBaseURLReturnsCorrectURL() throws {
        let expectedResult = try #require(URL(string: "https://api.themoviedb.org/3"))

        let result = URL.tmdbAPIBase

        #expect(result == expectedResult)
    }

    @Test("TMDb website base URL returns correct URL")
    func tmdbWebSiteBaseURLReturnsCorrectURL() throws {
        let expectedResult = try #require(URL(string: "https://www.themoviedb.org"))

        let result = URL.tmdbWebSite

        #expect(result == expectedResult)
    }

}
