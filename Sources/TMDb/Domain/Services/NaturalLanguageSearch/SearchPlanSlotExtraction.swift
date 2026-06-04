//
//  SearchPlanSlotExtraction.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Extracts a title from a prompt by removing trailing slot phrases (date /
/// runtime / rating) and then stripping the leading intent phrase. The residual
/// is the title, in its original casing (for searching).
///
enum TitleExtractor {

    private static let trailingMarkers = ["under", "over", "rated", "from", "in", "released"]

    /// Media-type filler a user adds to disambiguate ("cast of the show The Crown"),
    /// stripped from the front of the residual so it doesn't pollute the title.
    /// Only multi-word forms: bare "show "/"series " are too close to real titles
    /// (e.g. "Show Me a Hero"). Longer phrases first.
    private static let leadingFiller = [
        "the tv show ", "the tv series ", "the show ", "the series ",
        "tv show ", "tv series "
    ]

    static func title(from prompt: String, strippingLeads leads: [String]) -> String {
        // 1. Find the earliest matching lead phrase; the title is what follows it.
        var afterLead = prompt
        var earliest: Range<String.Index>?
        for lead in leads {
            guard let range = prompt.range(of: lead, options: [.caseInsensitive]) else { continue }
            if let current = earliest, current.lowerBound <= range.lowerBound { continue }
            earliest = range
        }
        if let earliest {
            afterLead = String(prompt[earliest.upperBound...])
        }

        // 2. Excise a trailing slot clause — but not if it would empty the title
        //    (e.g. the film "1917", whose whole title looks like a year).
        let excised = exciseTrailingSlots(afterLead)
        let kept = excised.trimmingCharacters(in: .whitespaces).isEmpty ? afterLead : excised

        // 3. Strip leading media-type filler ("the show", "the series", …).
        let unfilled = strippingLeadingFiller(kept)

        // 4. Trim whitespace and surrounding punctuation/quotes.
        return unfilled.trimmingCharacters(in: CharacterSet(charactersIn: " \t\n\"'.,?!"))
    }

    private static func strippingLeadingFiller(_ text: String) -> String {
        let leading = text.drop { $0 == " " }
        for filler in leadingFiller where leading.lowercased().hasPrefix(filler) {
            return String(leading.dropFirst(filler.count))
        }
        return text
    }

    private static func exciseTrailingSlots(_ text: String) -> String {
        let words = text.split(separator: " ").map(String.init)
        for (index, word) in words.enumerated() {
            let lower = word.lowercased()
            let isYearish = (lower.hasSuffix("s") && lower.dropLast().allSatisfy(\.isNumber)
                && lower.count >= 3)
                || (lower.count == 4 && lower.allSatisfy(\.isNumber)
                    && (lower.hasPrefix("19") || lower.hasPrefix("20")))
            if isYearish || trailingMarkers.contains(lower) {
                return words[0 ..< index].joined(separator: " ")
            }
        }
        return text
    }

}

///
/// Parses a symbolic ``SearchPlan/RelativeDate`` from a normalized prompt.
///
enum RelativeDateParser {

    static func parse(_ normalized: String) -> SearchPlan.RelativeDate? {
        if let range = between(normalized) {
            return range
        }
        if let years = lastNYears(normalized) {
            return .lastNYears(years)
        }
        if let decade = decade(normalized) {
            return .decade(decade)
        }
        if let year = exactYear(normalized) {
            return .exactYear(year)
        }
        if SearchPlanLexicon.contains(normalized, "this year") {
            return .thisYear
        }
        if SearchPlanLexicon.contains(normalized, anyOf: ["recent", "recently"]) {
            return .recent
        }
        return nil
    }

    private static func between(_ text: String) -> SearchPlan.RelativeDate? {
        let words = text.split(separator: " ").map(String.init)
        guard let andIndex = words.firstIndex(of: "and"), andIndex > 0, andIndex < words.count - 1 else {
            return nil
        }
        guard let start = year(words[andIndex - 1]), let end = year(words[andIndex + 1]) else {
            return nil
        }
        return .between(start: min(start, end), end: max(start, end))
    }

    private static func lastNYears(_ text: String) -> Int? {
        let words = text.split(separator: " ").map(String.init)
        // Need a 3-word window: "last" <count> "year(s)".
        guard let lastIndex = words.firstIndex(of: "last"), lastIndex + 2 < words.count else {
            return nil
        }
        guard let count = Int(words[lastIndex + 1]) else {
            return nil
        }
        guard words[lastIndex + 2].hasPrefix("year") else {
            return nil
        }
        return count
    }

    private static func decade(_ text: String) -> Int? {
        for word in text.split(separator: " ") {
            let lower = word.lowercased()
            guard lower.hasSuffix("s") else { continue }
            let digits = String(lower.dropLast())
            guard digits.allSatisfy(\.isNumber), !digits.isEmpty else { continue }
            if digits.count == 4, let value = Int(digits) {
                return value
            }
            if digits.count == 2, let two = Int(digits) {
                return two <= 20 ? 2000 + two : 1900 + two
            }
        }
        return nil
    }

    private static func exactYear(_ text: String) -> Int? {
        for word in text.split(separator: " ") {
            if let year = year(String(word)) {
                return year
            }
        }
        return nil
    }

    private static func year(_ word: String) -> Int? {
        guard word.count == 4, word.allSatisfy(\.isNumber),
              word.hasPrefix("19") || word.hasPrefix("20"), let value = Int(word)
        else {
            return nil
        }
        return value
    }

}

///
/// Parses runtime ceiling and minimum-rating slots from a normalized prompt.
///
enum RuntimeRatingParser {

    private static let wordNumbers = ["one": 1, "two": 2, "three": 3, "an": 1, "a": 1]

    static func runtimeMaxMinutes(_ normalized: String) -> Int? {
        let words = normalized.split(separator: " ").map(String.init)
        for (index, word) in words.enumerated() where word == "under" || word == "less" {
            // value is the next number-ish token
            let valueIndex = (word == "less" && index + 1 < words.count && words[index + 1] == "than")
                ? index + 2 : index + 1
            guard valueIndex < words.count else { continue }
            let value = Int(words[valueIndex]) ?? wordNumbers[words[valueIndex]]
            guard let value, valueIndex + 1 < words.count else { continue }
            let unit = words[valueIndex + 1]
            if unit.hasPrefix("hour") {
                return value * 60
            }
            if unit.hasPrefix("min") {
                return value
            }
        }
        return nil
    }

    static func minRating(_ normalized: String) -> Double? {
        if SearchPlanLexicon.contains(normalized, anyOf: [
            "highly rated", "top rated", "best rated", "acclaimed", "critically acclaimed"
        ]) {
            return 7.0
        }
        if SearchPlanLexicon.hasRatingCue(normalized) {
            return 6.5
        }
        return nil
    }

}
