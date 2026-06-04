//
//  SearchPlanSlotExtractionTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite("TitleExtractor")
struct TitleExtractorTests {

    @Test("strips the lead phrase")
    func stripsLead() {
        #expect(TitleExtractor.title(from: "cast of The Matrix", strippingLeads: SearchPlanLexicon.castLeads)
            == "The Matrix")
        #expect(TitleExtractor.title(from: "who directed Jurassic Park", strippingLeads: ["who directed"])
            == "Jurassic Park")
        #expect(TitleExtractor.title(from: "movies like Inception", strippingLeads: SearchPlanLexicon.similarLeads)
            == "Inception")
    }

    @Test("strips leading media-type filler so the title is clean")
    func stripsLeadingFiller() {
        #expect(TitleExtractor.title(
            from: "actors in the show The Crown",
            strippingLeads: SearchPlanLexicon.castLeads
        ) == "The Crown")
        #expect(TitleExtractor.title(
            from: "main cast of the series Succession",
            strippingLeads: SearchPlanLexicon.castLeads
        ) == "Succession")
        #expect(TitleExtractor.title(
            from: "people in the tv show The Office",
            strippingLeads: SearchPlanLexicon.castLeads
        ) == "The Office")
        // A real title that merely starts with "The" is not over-trimmed.
        #expect(TitleExtractor.title(from: "cast of The Crown", strippingLeads: SearchPlanLexicon.castLeads)
            == "The Crown")
        // A title that starts with a bare media word ("Show", "Series") is kept —
        // only multi-word filler ("the show", "tv show") is stripped.
        #expect(TitleExtractor.title(from: "cast of Show Me a Hero", strippingLeads: SearchPlanLexicon.castLeads)
            == "Show Me a Hero")
    }

    @Test("excises a trailing slot clause before taking the title")
    func excisesTrailingSlot() {
        #expect(TitleExtractor.title(
            from: "shows like Severance under 1 hour",
            strippingLeads: SearchPlanLexicon.similarLeads
        ) == "Severance")
        #expect(TitleExtractor.title(
            from: "movies like Heat from the 90s",
            strippingLeads: SearchPlanLexicon.similarLeads
        ) == "Heat")
    }

    @Test("preserves original casing and trims punctuation")
    func preservesCasing() {
        #expect(TitleExtractor.title(from: "who's in Inception?", strippingLeads: SearchPlanLexicon.castLeads)
            == "Inception")
    }
}

@Suite("RelativeDateParser")
struct RelativeDateParserTests {

    private func parse(_ prompt: String) -> SearchPlan.RelativeDate? {
        RelativeDateParser.parse(SearchPlanLexicon.normalize(prompt))
    }

    @Test("parses decades")
    func decades() {
        #expect(parse("90s sci-fi") == .decade(1990))
        #expect(parse("movies from the 1980s") == .decade(1980))
        #expect(parse("2000s comedies") == .decade(2000))
        #expect(parse("2010s") == .decade(2010))
    }

    @Test("parses exact year, this year, recent, last N years, between")
    func others() {
        #expect(parse("movies from 2019") == .exactYear(2019))
        #expect(parse("films this year") == .thisYear)
        #expect(parse("recent thrillers") == .recent)
        #expect(parse("movies from the last 5 years") == .lastNYears(5))
        #expect(parse("between 2010 and 2019") == .between(start: 2010, end: 2019))
    }

    @Test("no date cue returns nil")
    func none() {
        #expect(parse("horror movies") == nil)
    }
}

@Suite("RuntimeRatingParser")
struct RuntimeRatingParserTests {

    private func normalize(_ prompt: String) -> String {
        SearchPlanLexicon.normalize(prompt)
    }

    @Test("parses runtime ceilings")
    func runtime() {
        #expect(RuntimeRatingParser.runtimeMaxMinutes(normalize("under 90 minutes")) == 90)
        #expect(RuntimeRatingParser.runtimeMaxMinutes(normalize("under 2 hours")) == 120)
        #expect(RuntimeRatingParser.runtimeMaxMinutes(normalize("less than 100 minutes")) == 100)
        #expect(RuntimeRatingParser.runtimeMaxMinutes(normalize("horror movies")) == nil)
    }

    @Test("parses minimum rating")
    func rating() {
        #expect(RuntimeRatingParser.minRating(normalize("highly rated documentaries")) == 7.0)
        #expect(RuntimeRatingParser.minRating(normalize("well reviewed dramas")) == 6.5)
        #expect(RuntimeRatingParser.minRating(normalize("horror movies")) == nil)
    }
}
