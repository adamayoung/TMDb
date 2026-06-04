//
//  SearchPlanLexicon.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Deterministic phrase vocabulary and matchers for interpreting prompts.
///
/// All matching is pure string work (no model, no network), so it is fast,
/// cross-platform, and fully testable. Phrases are matched on word boundaries.
///
enum SearchPlanLexicon {

    // MARK: - Normalization

    /// Lowercases, folds separators to spaces, and collapses whitespace so
    /// "Sci-Fi", "rom-com", and "top‑rated" match their phrase forms.
    static func normalize(_ prompt: String) -> String {
        let lowered = prompt.lowercased()
            .replacingOccurrences(of: "’", with: "'")
        let folded = String(lowered.map { "-_/".contains($0) ? " " : $0 })
        let collapsed = folded.split(whereSeparator: { $0 == " " || $0 == "\t" || $0 == "\n" })
        return collapsed.joined(separator: " ")
    }

    /// Whole-word / whole-phrase containment (space-padded boundaries).
    static func contains(_ text: String, _ phrase: String) -> Bool {
        " \(text) ".contains(" \(phrase) ")
    }

    static func contains(_ text: String, anyOf phrases: [String]) -> Bool {
        phrases.contains { contains(text, $0) }
    }

    // MARK: - List

    private static let listKinds: [(phrases: [String], kind: SearchPlan.ListKind)] = [
        (["trending"], .trending),
        (["now playing", "in cinemas", "in theaters", "in theatres", "new releases", "out now"], .nowPlaying),
        (["upcoming", "coming soon"], .upcoming),
        (["airing today", "on tv today", "on air today"], .airingToday),
        (["top rated", "highly rated", "best rated"], .topRated),
        (["popular", "most popular"], .popular)
    ]

    static func listKind(in text: String) -> SearchPlan.ListKind? {
        listKinds.first { contains(text, anyOf: $0.phrases) }?.kind
    }

    static func mediaType(in text: String) -> SearchPlan.MediaType? {
        if contains(text, anyOf: ["actor", "actors", "actress", "actresses", "people", "directors"]) {
            return .person
        }
        if contains(text, anyOf: ["show", "shows", "series", "tv", "television", "sitcom", "sitcoms"]) {
            return .tv
        }
        if contains(text, anyOf: ["movie", "movies", "film", "films", "cinema"]) {
            return .movie
        }
        return nil
    }

    // MARK: - Similar

    static let similarLeads = [
        "movies like", "movie like", "films like", "film like", "shows like", "show like",
        "tv shows like", "tv series like", "series like", "something like", "stuff like",
        "similar to", "in the vein of", "reminds me of", "recommendations based on"
    ]

    static func isSimilar(_ text: String) -> Bool {
        similarLeads.contains { text.contains($0) }
    }

    // MARK: - Cast

    static let castLeads = [
        "cast of", "the cast of", "cast members of", "cast member of", "cast list for",
        "cast list of", "full cast of", "main cast of", "who is in", "who's in", "whos in",
        "actors in", "actors from", "the actors in", "stars of", "people in",
        "who appears in", "who acted in", "who played in", "who plays in", "lead actors in",
        "who starred in", "who stars in"
    ]

    static func isCastOf(_ text: String) -> Bool {
        castLeads.contains { text.contains($0) }
    }

    // MARK: - Crew role

    static let crewRoleLeads: [(lead: String, job: String)] = [
        // Longer phrases first: `crewRoleJob` returns the first match, and the
        // matched lead is stripped to recover the title, so "who composed the
        // music for Dune" must match the full clause, not just "who composed".
        ("who composed the music for", "Original Music Composer"),
        ("who composed the music of", "Original Music Composer"),
        ("who composed the score for", "Original Music Composer"),
        ("director of", "Director"), ("who directed", "Director"),
        ("who wrote", "Writer"), ("writer of", "Writer"), ("screenwriter of", "Writer"),
        ("composer of", "Original Music Composer"), ("who composed", "Original Music Composer"),
        ("music by", "Original Music Composer"),
        ("cinematographer of", "Director of Photography"),
        ("producer of", "Producer"), ("who produced", "Producer"),
        ("editor of", "Editor")
    ]

    static func crewRoleJob(in text: String) -> (lead: String, job: String)? {
        crewRoleLeads.first { text.contains($0.lead) }
    }

    // MARK: - By person

    static let byPersonPrefixes = [
        "movies with ", "movie with ", "films with ", "film with ", "shows with ", "show with ",
        "tv shows with ", "tv series with ", "series with ",
        "movies starring ", "films starring ", "movie starring ",
        "shows starring ", "show starring ", "tv shows starring ", "tv series starring ", "series starring ",
        "movies featuring ", "films featuring ",
        "shows featuring ", "tv shows featuring ", "tv series featuring ", "series featuring ",
        "movies by ", "films by ", "movie by ", "film by ",
        "films directed by ", "movies directed by ", "starring ", "directed by ", "featuring "
    ]

    /// Longer phrases first so "X tv shows" trims to "X", not "X tv".
    static let byPersonSuffixes = [
        " movies", " films", " movie", " film",
        " tv shows", " tv series", " tv show", " shows", " series"
    ]

    /// Filmography questions ("what has Tom Hanks been in") — the named person is
    /// recovered by the planner's entity extraction.
    static let filmographyLeads = ["been in"]

    static func isByPerson(_ text: String) -> Bool {
        if byPersonPrefixes.contains(where: { text.hasPrefix($0) }) {
            return true
        }
        if filmographyLeads.contains(where: { text.contains($0) }) {
            return true
        }
        // Trim a trailing date/runtime/rating clause so "Tom Hanks movies from the
        // 90s" still presents the "X movies" shape (genres are NOT trimmed, so
        // "horror movies" stays a browse query).
        let core = trimmingTrailingSlots(text)
        for suffix in byPersonSuffixes where core.hasSuffix(suffix) {
            let candidate = String(core.dropLast(suffix.count)).trimmingCharacters(in: .whitespaces)
            if !candidate.isEmpty,
               listKind(in: candidate) == nil,
               !hasDiscoverCue(candidate) {
                return true
            }
        }
        return false
    }

    /// A crew role implied by a `byPerson` lead ("films directed by X" → Director),
    /// so the executor can filter the discover query by crew rather than cast.
    static func crewRoleForByPerson(_ text: String) -> String? {
        if contains(text, "directed by") {
            return "Director"
        }
        if contains(text, "written by") {
            return "Writer"
        }
        if contains(text, anyOf: ["composed by", "music by", "scored by"]) {
            return "Original Music Composer"
        }
        return nil
    }

    /// Removes a trailing date / runtime / rating clause (not genres) from a
    /// normalized string, used to recover the "X movies" shape for classification.
    static func trimmingTrailingSlots(_ text: String) -> String {
        let markers: Set = ["under", "over", "rated", "from", "in", "released", "since",
                            "before", "after", "during", "between"]
        let words = text.split(separator: " ").map(String.init)
        for (index, word) in words.enumerated() {
            let yearish = (word.hasSuffix("s") && word.dropLast().allSatisfy(\.isNumber)
                && word.count >= 3)
                || (word.count == 4 && word.allSatisfy(\.isNumber)
                    && (word.hasPrefix("19") || word.hasPrefix("20")))
            if yearish || markers.contains(word) {
                return words[0 ..< index].joined(separator: " ")
            }
        }
        return text
    }

    // MARK: - Genres

    /// Genre vocabulary used to detect a discover/browse cue. A prompt naming a
    /// genre is deferred to the language-model fallback (which resolves genres),
    /// so only presence is needed here, not a canonical mapping.
    static let genreTerms: [[String]] = [
        ["sci fi", "scifi", "science fiction"],
        ["rom com", "romantic comedy"],
        ["action"], ["adventure"], ["animation", "animated"], ["comedy", "comedies"],
        ["crime"], ["documentary", "documentaries", "docs"], ["drama", "dramas"],
        ["family"], ["fantasy"], ["history", "historical"], ["horror"],
        ["musical", "musicals"], ["mystery"], ["romance", "romantic"],
        ["thriller", "thrillers"], ["war"], ["western", "westerns"],
        ["superhero", "super hero", "comic book"]
    ]

    static func hasGenre(_ text: String) -> Bool {
        genreTerms.contains { contains(text, anyOf: $0) }
    }

    // MARK: - Mood

    static let moodTerms = [
        "feel good", "cozy", "cosy", "scary", "uplifting", "tearjerker", "heartwarming",
        "comfort", "comforting", "wholesome", "funny", "light hearted", "lighthearted",
        "hidden gem", "hidden gems", "underrated", "comfort watch", "chill", "relaxing",
        "mind bending", "mindbending"
    ]

    static func hasMood(_ text: String) -> Bool {
        contains(text, anyOf: moodTerms)
    }

    // MARK: - Date / runtime / rating cues

    static func hasDateCue(_ text: String) -> Bool {
        if contains(text, anyOf: ["decade", "recent", "this year", "last year", "classic"]) {
            return true
        }
        for token in text.split(separator: " ") {
            let word = String(token)
            // "90s", "1990s", "2000s"
            if word.hasSuffix("s"), word.dropLast().allSatisfy(\.isNumber), word.count >= 3 {
                return true
            }
            // bare 4-digit year 19xx / 20xx
            if word.count == 4, word.allSatisfy(\.isNumber),
               word.hasPrefix("19") || word.hasPrefix("20") {
                return true
            }
        }
        return false
    }

    static func hasRuntimeCue(_ text: String) -> Bool {
        if contains(text, anyOf: ["minute", "minutes", "runtime", "feature length", "short film"]) {
            return true
        }
        if contains(text, "hour") || contains(text, "hours"), text.contains(where: \.isNumber) {
            return true
        }
        return contains(text, anyOf: ["under two hours", "over two hours", "less than"])
    }

    static func hasRatingCue(_ text: String) -> Bool {
        contains(text, anyOf: [
            "highly rated", "top rated", "well rated", "acclaimed", "critically acclaimed",
            "best rated", "high rating", "good ratings", "well reviewed"
        ])
    }

    static func hasDiscoverCue(_ text: String) -> Bool {
        hasGenre(text) || hasMood(text) || hasDateCue(text) || hasRuntimeCue(text) || hasRatingCue(text)
    }

}
