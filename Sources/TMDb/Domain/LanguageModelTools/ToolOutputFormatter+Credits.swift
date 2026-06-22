//
//  ToolOutputFormatter+Credits.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

// MARK: - Credits blocks

extension ToolOutputFormatter {

    /// The maximum number of cast members shown in a credits block.
    static let creditsCastLimit = 10

    /// The maximum number of crew members shown in a credits block.
    static let creditsCrewLimit = 8

    /// The crew jobs shown in a credits block, in display-priority order.
    ///
    /// Limiting to these key creative roles keeps the block focused and within the
    /// model's context window; other crew (editors, composers, …) are omitted.
    private static let keyCrewJobs = [
        "Director",
        "Writer",
        "Screenplay",
        "Story",
        "Producer",
        "Executive Producer"
    ]

    ///
    /// Formats a movie's principal cast and crew as a compact block.
    ///
    /// Every line leads with a TMDb `id` so the model can chain calls — taking a
    /// cast or crew member's `id` and passing it to a filmography tool. The cast is
    /// the top-billed members by order; the crew is limited to the key creative
    /// roles (director, writers, producers) so the block stays within the on-device
    /// model's context window.
    ///
    /// - Parameter credits: The credits to format.
    ///
    /// - Returns: The formatted block.
    ///
    static func block(for credits: ShowCredits) -> String {
        var lines = ["credits | \(credits.id)"]
        lines.append(contentsOf: castLines(credits.cast))
        lines.append(contentsOf: crewLines(credits.crew))

        return lines.joined(separator: "\n")
    }

    private static func castLines(_ cast: [CastMember]) -> [String] {
        guard !cast.isEmpty else {
            return ["no cast listed"]
        }

        return cast
            .sorted { $0.order < $1.order }
            .prefix(creditsCastLimit)
            .map { "cast | \($0.id) | \(sanitize($0.name)) as \(sanitize($0.character))" }
    }

    private static func crewLines(_ crew: [CrewMember]) -> [String] {
        let keyCrew = crew
            .filter { keyCrewJobs.contains($0.job) }
            .sorted { jobPriority($0.job) < jobPriority($1.job) }

        var seen = Set<String>()
        let deduped = keyCrew.filter { seen.insert("\($0.id)|\($0.job)").inserted }
        let limited = deduped.prefix(creditsCrewLimit)
        guard !limited.isEmpty else {
            return ["no crew listed"]
        }

        return limited.map { "crew | \($0.id) | \(sanitize($0.name)) — \($0.job)" }
    }

    private static func jobPriority(_ job: String) -> Int {
        keyCrewJobs.firstIndex(of: job) ?? keyCrewJobs.count
    }

}
