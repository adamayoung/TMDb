//
//  ToolOutputFormatterCreditsTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.languageModelTools))
struct ToolOutputFormatterCreditsTests {

    @Test("credits block leads with the credits id header")
    func creditsBlockHeader() {
        let credits = ShowCredits.mock(
            id: 27205,
            cast: [.mock(id: 6193, name: "Leonardo DiCaprio", character: "Cobb", order: 0)],
            crew: [.mock(id: 525, name: "Christopher Nolan", job: "Director")]
        )

        let block = ToolOutputFormatter.block(for: credits)

        #expect(block.hasPrefix("credits | 27205"))
    }

    @Test("credits cast lines lead with the person id and pair name with character")
    func creditsCastLines() {
        let credits = ShowCredits.mock(
            id: 1,
            cast: [
                .mock(id: 819, name: "Edward Norton", character: "The Narrator", order: 0),
                .mock(id: 287, name: "Brad Pitt", character: "Tyler Durden", order: 1)
            ],
            crew: []
        )

        let block = ToolOutputFormatter.block(for: credits)

        #expect(block.contains("cast | 819 | Edward Norton as The Narrator"))
        #expect(block.contains("cast | 287 | Brad Pitt as Tyler Durden"))
    }

    @Test("credits cast is sorted by billing order")
    func creditsCastSortedByOrder() {
        let credits = ShowCredits.mock(
            id: 1,
            cast: [
                .mock(id: 2, name: "Second Billed", character: "B", order: 1),
                .mock(id: 1, name: "Top Billed", character: "A", order: 0)
            ],
            crew: []
        )

        let lines = ToolOutputFormatter.block(for: credits).components(separatedBy: "\n")
        let castLines = lines.filter { $0.hasPrefix("cast |") }

        #expect(castLines.first == "cast | 1 | Top Billed as A")
        #expect(castLines.last == "cast | 2 | Second Billed as B")
    }

    @Test("credits cast is capped at ten members")
    func creditsCastCapped() {
        let cast = (0 ..< 15).map {
            CastMember.mock(id: $0, name: "Actor \($0)", character: "Role \($0)", order: $0)
        }
        let credits = ShowCredits.mock(id: 1, cast: cast, crew: [])

        let castLines = ToolOutputFormatter.block(for: credits)
            .components(separatedBy: "\n")
            .filter { $0.hasPrefix("cast |") }

        #expect(castLines.count == 10)
    }

    @Test("credits crew keeps only key jobs, in priority order")
    func creditsCrewKeyJobs() {
        let credits = ShowCredits.mock(
            id: 1,
            cast: [],
            crew: [
                .mock(id: 10, name: "An Editor", job: "Editor"),
                .mock(id: 20, name: "A Writer", job: "Writer"),
                .mock(id: 30, name: "A Director", job: "Director")
            ]
        )

        let lines = ToolOutputFormatter.block(for: credits).components(separatedBy: "\n")
        let crewLines = lines.filter { $0.hasPrefix("crew |") }

        #expect(crewLines.contains("crew | 30 | A Director — Director"))
        #expect(crewLines.contains("crew | 20 | A Writer — Writer"))
        #expect(!lines.contains { $0.contains("Editor") })
        // Director outranks Writer in the key-job priority order.
        #expect(crewLines.first == "crew | 30 | A Director — Director")
    }

    @Test("credits crew is deduplicated by person and job")
    func creditsCrewDeduplicated() {
        let credits = ShowCredits.mock(
            id: 1,
            cast: [],
            crew: [
                .mock(id: 30, creditID: "a", name: "A Director", job: "Director"),
                .mock(id: 30, creditID: "b", name: "A Director", job: "Director")
            ]
        )

        let crewLines = ToolOutputFormatter.block(for: credits)
            .components(separatedBy: "\n")
            .filter { $0.hasPrefix("crew |") }

        #expect(crewLines == ["crew | 30 | A Director — Director"])
    }

    @Test("credits block reports gracefully when cast and crew are empty")
    func creditsBlockEmpty() {
        let credits = ShowCredits.mock(id: 7, cast: [], crew: [])

        let block = ToolOutputFormatter.block(for: credits)

        #expect(block.hasPrefix("credits | 7"))
        #expect(block.contains("no cast listed"))
        #expect(block.contains("no crew listed"))
    }

    @Test("credits sanitizes pipe and newline characters in names and characters")
    func creditsSanitizesDelimiters() {
        let credits = ShowCredits.mock(
            id: 1,
            cast: [.mock(id: 5, name: "A | B", character: "Hero\nVillain", order: 0)],
            crew: []
        )

        let block = ToolOutputFormatter.block(for: credits)

        #expect(!block.contains("A | B"))
        #expect(!block.contains("\nVillain"))
        #expect(block.contains("cast | 5 | A / B as Hero Villain"))
    }

    @Test("credits sanitizes pipe characters in a crew name so they cannot corrupt a line")
    func creditsSanitizesCrewName() throws {
        let credits = ShowCredits.mock(
            id: 1,
            cast: [],
            crew: [.mock(id: 9, name: "Nolan | Jr", job: "Director")]
        )

        let crewLine = try #require(
            ToolOutputFormatter.block(for: credits)
                .components(separatedBy: "\n")
                .first { $0.hasPrefix("crew |") }
        )

        #expect(crewLine == "crew | 9 | Nolan / Jr — Director")
    }

}
