//
//  ToolOutputFormatter.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Renders TMDb models into compact, token-efficient text lines for a language
/// model to reason about.
///
/// Every list entry leads with a `kind` token and the TMDb `id` so the model can
/// chain tool calls — for example, take an `id` from ``mediaList(_:limit:query:)``
/// and pass it to a details or watch-providers tool. The output is plain text
/// rather than JSON to keep within the on-device model's context window.
///
/// This type references only public, platform-agnostic models, so it compiles and
/// is testable on every supported platform — including those without the
/// FoundationModels framework.
///
enum ToolOutputFormatter {

    /// The default maximum number of entries a list-producing tool returns.
    ///
    /// Deliberately small to bound the token cost of a tool result; this is not a
    /// TMDb page-size limit.
    static let defaultListLimit = 8

    /// The maximum length of an overview shown on a single list line.
    static let lineOverviewLimit = 140

    /// The maximum length of an overview shown in a details block.
    static let blockOverviewLimit = 300

    private static let utcCalendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC") ?? .gmt
        return calendar
    }()

}

// MARK: - List lines

extension ToolOutputFormatter {

    ///
    /// Formats a multi-search result list, one entity per line.
    ///
    /// Collection results are omitted: there is no tool that consumes a collection
    /// id, so a collection line would not be chainable.
    ///
    /// - Parameters:
    ///   - items: The media items to format.
    ///   - limit: The maximum number of lines to include.
    ///   - query: A description of the request, used in the empty-result message.
    ///
    /// - Returns: The formatted lines, or a "no results" message when empty.
    ///
    static func mediaList(_ items: [Media], limit: Int, query: String) -> String {
        let lines = items.compactMap(line(for:)).prefix(limit)
        guard !lines.isEmpty else {
            return "No results found for '\(sanitize(query))'."
        }

        return lines.joined(separator: "\n")
    }

    ///
    /// Formats a single media item as a list line, or `nil` for a collection.
    ///
    /// - Parameter media: The media item to format.
    ///
    /// - Returns: The formatted line, or `nil` when the item is a collection.
    ///
    static func line(for media: Media) -> String? {
        switch media {
        case .movie(let movie): line(for: movie)
        case .tvSeries(let tvSeries): line(for: tvSeries)
        case .person(let person): line(for: person)
        case .collection: nil
        }
    }

    ///
    /// Formats a movie list item as a single line.
    ///
    /// - Parameter movie: The movie list item to format.
    ///
    /// - Returns: The formatted line.
    ///
    static func line(for movie: MovieListItem) -> String {
        var line = "movie | \(movie.id) | \(titleWithYear(movie.title, movie.releaseDate))"
        if let rating = ratingToken(movie.voteAverage) {
            line += " | \(rating)"
        }
        if let overview = overviewToken(movie.overview, limit: lineOverviewLimit) {
            line += " | \(overview)"
        }

        return line
    }

    ///
    /// Formats a TV series list item as a single line.
    ///
    /// - Parameter tvSeries: The TV series list item to format.
    ///
    /// - Returns: The formatted line.
    ///
    static func line(for tvSeries: TVSeriesListItem) -> String {
        var line = "tv | \(tvSeries.id) | \(titleWithYear(tvSeries.name, tvSeries.firstAirDate))"
        if let rating = ratingToken(tvSeries.voteAverage) {
            line += " | \(rating)"
        }
        if let overview = overviewToken(tvSeries.overview, limit: lineOverviewLimit) {
            line += " | \(overview)"
        }

        return line
    }

    ///
    /// Formats a person list item as a single line.
    ///
    /// - Parameter person: The person list item to format.
    ///
    /// - Returns: The formatted line.
    ///
    static func line(for person: PersonListItem) -> String {
        var line = "person | \(person.id) | \(sanitize(person.name))"
        if let department = person.knownForDepartment, !department.isEmpty {
            line += " | \(sanitize(department))"
        }

        return line
    }

    ///
    /// Formats a person's credit (``Show``) as a single line.
    ///
    /// - Parameter show: The show to format.
    ///
    /// - Returns: The formatted line.
    ///
    static func line(for show: Show) -> String {
        switch show {
        case .movie(let movie): line(for: movie)
        case .tvSeries(let tvSeries): line(for: tvSeries)
        }
    }

}

// MARK: - Detail blocks

extension ToolOutputFormatter {

    ///
    /// Formats the full details of a movie as a compact block.
    ///
    /// - Parameter movie: The movie to format.
    ///
    /// - Returns: The formatted block.
    ///
    static func block(for movie: Movie) -> String {
        var lines = ["movie | \(movie.id) | \(titleWithYear(movie.title, movie.releaseDate))"]

        var facts: [String] = []
        if let runtime = movie.runtime, runtime > 0 {
            facts.append("\(runtime) min")
        }
        if let genres = genreNames(movie.genres) {
            facts.append("genres: \(genres)")
        }
        if let rating = ratingToken(movie.voteAverage) {
            facts.append(rating)
        }
        if let status = movie.status {
            facts.append("status: \(status.rawValue)")
        }
        if !facts.isEmpty {
            lines.append(facts.joined(separator: " | "))
        }

        if let tagline = movie.tagline, !tagline.isEmpty {
            lines.append("tagline: \(sanitize(tagline))")
        }
        if let overview = overviewToken(movie.overview, limit: blockOverviewLimit) {
            lines.append("overview: \(overview)")
        }

        return lines.joined(separator: "\n")
    }

    ///
    /// Formats the full details of a TV series as a compact block.
    ///
    /// - Parameter tvSeries: The TV series to format.
    ///
    /// - Returns: The formatted block.
    ///
    static func block(for tvSeries: TVSeries) -> String {
        var lines = ["tv | \(tvSeries.id) | \(titleWithYear(tvSeries.name, tvSeries.firstAirDate))"]

        var facts: [String] = []
        if let seasons = tvSeries.numberOfSeasons, seasons > 0 {
            facts.append("\(seasons) season\(seasons == 1 ? "" : "s")")
        }
        if let genres = genreNames(tvSeries.genres) {
            facts.append("genres: \(genres)")
        }
        if let rating = ratingToken(tvSeries.voteAverage) {
            facts.append(rating)
        }
        if let status = tvSeries.status, !status.isEmpty {
            facts.append("status: \(sanitize(status))")
        }
        if !facts.isEmpty {
            lines.append(facts.joined(separator: " | "))
        }

        if let tagline = tvSeries.tagline, !tagline.isEmpty {
            lines.append("tagline: \(sanitize(tagline))")
        }
        if let overview = overviewToken(tvSeries.overview, limit: blockOverviewLimit) {
            lines.append("overview: \(overview)")
        }

        return lines.joined(separator: "\n")
    }

    ///
    /// Formats a person header line for a filmography.
    ///
    /// - Parameter person: The person to format.
    ///
    /// - Returns: The formatted header line.
    ///
    static func header(for person: Person) -> String {
        var line = "person | \(person.id) | \(sanitize(person.name))"
        if let department = person.knownForDepartment, !department.isEmpty {
            line += " | \(sanitize(department))"
        }

        return line
    }

}

// MARK: - Watch providers

extension ToolOutputFormatter {

    ///
    /// Formats the watch providers for a title in a single country.
    ///
    /// The `flatRate` group is labelled `stream` for readability. Empty groups are
    /// omitted. Only provider names are shown — logos and links are dropped.
    ///
    /// - Parameters:
    ///   - id: The TMDb id of the movie or TV series.
    ///   - countryCode: The ISO-3166-1 country code.
    ///   - providers: The watch providers for that country.
    ///
    /// - Returns: The formatted block, or a "none" message when no providers exist.
    ///
    static func watchProviders(
        id: Int,
        countryCode: String,
        providers: ShowWatchProvider
    ) -> String {
        let groups: [(label: String, providers: [WatchProvider]?)] = [
            ("stream", providers.flatRate),
            ("free", providers.free),
            ("ads", providers.ads),
            ("rent", providers.rent),
            ("buy", providers.buy)
        ]

        var lines = ["watchProviders | \(id) | \(countryCode)"]
        for group in groups {
            guard let names = providerNames(group.providers) else { continue }
            lines.append("\(group.label): \(names)")
        }

        guard lines.count > 1 else {
            return "No watch providers listed for id \(id) in \(countryCode)."
        }

        return lines.joined(separator: "\n")
    }

}

// MARK: - Helpers

extension ToolOutputFormatter {

    /// Extracts the four-digit year from a date, in UTC, or `nil`.
    static func year(from date: Date?) -> Int? {
        date.map { utcCalendar.component(.year, from: $0) }
    }

    private static func titleWithYear(_ title: String, _ date: Date?) -> String {
        guard let year = year(from: date) else {
            return sanitize(title)
        }

        return "\(sanitize(title)) (\(year))"
    }

    private static func ratingToken(_ voteAverage: Double?) -> String? {
        guard let voteAverage, voteAverage > 0 else {
            return nil
        }

        return "⭐\(String(format: "%.1f", voteAverage))"
    }

    private static func overviewToken(_ overview: String?, limit: Int) -> String? {
        guard let overview else {
            return nil
        }

        let truncated = truncate(overview, limit: limit)
        return truncated.isEmpty ? nil : truncated
    }

    private static func genreNames(_ genres: [Genre]?) -> String? {
        guard let genres, !genres.isEmpty else {
            return nil
        }

        return genres.map { sanitize($0.name) }.joined(separator: ", ")
    }

    private static func providerNames(_ providers: [WatchProvider]?) -> String? {
        guard let providers, !providers.isEmpty else {
            return nil
        }

        return providers.map { sanitize($0.name) }.joined(separator: ", ")
    }

    /// Replaces the field delimiter and newlines so they cannot corrupt a line's
    /// `kind | id | …` structure, and collapses runs of whitespace.
    private static func sanitize(_ text: String) -> String {
        let replaced = text
            .replacingOccurrences(of: "|", with: "/")
            .replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "\r", with: " ")
            .replacingOccurrences(of: "\t", with: " ")
        let parts = replaced.split(whereSeparator: { $0 == " " })
        return parts.joined(separator: " ")
    }

    private static func truncate(_ text: String, limit: Int) -> String {
        let clean = sanitize(text)
        // `count` and `index(_:offsetBy:)` both work in grapheme clusters, matching
        // the user-visible character limit.
        guard clean.count > limit else {
            return clean
        }

        let endIndex = clean.index(clean.startIndex, offsetBy: limit)
        var prefix = String(clean[..<endIndex])
        if let lastSpace = prefix.lastIndex(of: " ") {
            prefix = String(prefix[..<lastSpace])
        }

        return "\(prefix)…"
    }

}
