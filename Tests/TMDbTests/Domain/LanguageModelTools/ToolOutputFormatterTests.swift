//
//  ToolOutputFormatterTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import Testing
@testable import TMDb

@Suite(.tags(.languageModelTools))
struct ToolOutputFormatterTests {

    // MARK: - List lines

    @Test("movie line leads with kind and id, and includes year, rating, overview")
    func movieLineStructure() throws {
        let movie = MovieListItem.mock(
            id: 27205,
            title: "Inception",
            overview: "A thief who steals corporate secrets.",
            releaseDate: Date(iso8601: "2010-07-16T00:00:00Z"),
            voteAverage: 8.4
        )

        let line = try #require(ToolOutputFormatter.line(for: Media.movie(movie)))
        let tokens = line.components(separatedBy: " | ")

        #expect(tokens[0] == "movie")
        #expect(tokens[1] == "27205")
        #expect(line.contains("Inception (2010)"))
        #expect(line.contains("⭐8.4"))
        #expect(line.contains("A thief who steals corporate secrets."))
    }

    @Test("tv line uses tv kind and first-air year")
    func tvLineStructure() throws {
        let tvSeries = TVSeriesListItem.mock(
            id: 1396,
            name: "Breaking Bad",
            firstAirDate: Date(iso8601: "2008-01-20T00:00:00Z"),
            voteAverage: 8.9
        )

        let line = try #require(ToolOutputFormatter.line(for: Media.tvSeries(tvSeries)))
        let tokens = line.components(separatedBy: " | ")

        #expect(tokens[0] == "tv")
        #expect(tokens[1] == "1396")
        #expect(line.contains("Breaking Bad (2008)"))
        #expect(line.contains("⭐8.9"))
    }

    @Test("person line uses person kind and known-for department, no rating")
    func personLineStructure() throws {
        let person = PersonListItem.mock(
            id: 287,
            name: "Brad Pitt",
            originalName: "Brad Pitt",
            knownForDepartment: "Acting"
        )

        let line = try #require(ToolOutputFormatter.line(for: Media.person(person)))
        let tokens = line.components(separatedBy: " | ")

        #expect(tokens[0] == "person")
        #expect(tokens[1] == "287")
        #expect(tokens[2] == "Brad Pitt")
        #expect(tokens[3] == "Acting")
        #expect(!line.contains("⭐"))
    }

    @Test("collection media is dropped from a line")
    func collectionLineIsNil() {
        let collection = CollectionListItem(
            id: 99,
            title: "Some Collection",
            originalTitle: "Some Collection",
            originalLanguage: "en",
            overview: ""
        )

        #expect(ToolOutputFormatter.line(for: Media.collection(collection)) == nil)
    }

    @Test("mediaList drops collections and keeps movies, tv, and people")
    func mediaListDropsCollections() {
        let items: [Media] = [
            .movie(.mock(id: 1, title: "A")),
            .collection(
                CollectionListItem(
                    id: 2,
                    title: "Coll",
                    originalTitle: "Coll",
                    originalLanguage: "en",
                    overview: ""
                )
            ),
            .person(.mock(id: 3, name: "P", originalName: "P"))
        ]

        let output = ToolOutputFormatter.mediaList(items, limit: 8, query: "a")
        let lines = output.components(separatedBy: "\n")

        #expect(lines.count == 2)
        #expect(output.contains("movie | 1"))
        #expect(output.contains("person | 3"))
        #expect(!output.contains("Coll"))
    }

    @Test("mediaList returns a no-results message when empty")
    func mediaListEmptyMessage() {
        let output = ToolOutputFormatter.mediaList([], limit: 8, query: "nothing here")
        #expect(output == "No results found for 'nothing here'.")
    }

    @Test("mediaList respects the limit")
    func mediaListRespectsLimit() {
        let items: [Media] = (1 ... 10).map { .movie(.mock(id: $0, title: "Movie \($0)")) }
        let output = ToolOutputFormatter.mediaList(items, limit: 3, query: "movies")

        #expect(output.components(separatedBy: "\n").count == 3)
    }

    @Test("rating is omitted when nil or zero")
    func ratingOmittedWhenAbsent() throws {
        let noRating = MovieListItem.mock(id: 1, title: "A", voteAverage: nil)
        let zeroRating = MovieListItem.mock(id: 2, title: "B", voteAverage: 0)

        let lineNoRating = try #require(ToolOutputFormatter.line(for: Media.movie(noRating)))
        let lineZeroRating = try #require(ToolOutputFormatter.line(for: Media.movie(zeroRating)))

        #expect(!lineNoRating.contains("⭐"))
        #expect(!lineZeroRating.contains("⭐"))
    }

    @Test("year is omitted when the release date is nil")
    func yearOmittedWhenDateAbsent() throws {
        let movie = MovieListItem.mock(id: 1, title: "No Date Movie", releaseDate: nil)
        let line = try #require(ToolOutputFormatter.line(for: Media.movie(movie)))

        #expect(line.contains("No Date Movie"))
        #expect(!line.contains("("))
    }

    @Test("pipe and newline characters in title and overview do not corrupt the line")
    func sanitizesDelimitersInText() throws {
        let movie = MovieListItem.mock(
            id: 42,
            title: "Crash | Boom",
            overview: "Line one\nLine | two",
            releaseDate: Date(iso8601: "2004-05-06T00:00:00Z"),
            voteAverage: 7
        )

        let line = try #require(ToolOutputFormatter.line(for: Media.movie(movie)))
        let tokens = line.components(separatedBy: " | ")

        #expect(tokens[0] == "movie")
        #expect(tokens[1] == "42")
        #expect(!line.contains("Crash | Boom"))
        #expect(!line.contains("\n"))
    }

    @Test("long overview is truncated with an ellipsis")
    func truncatesLongOverview() throws {
        let overview = String(repeating: "word ", count: 80)
        let movie = MovieListItem.mock(id: 1, title: "A", overview: overview)

        let line = try #require(ToolOutputFormatter.line(for: Media.movie(movie)))

        #expect(line.contains("…"))
        #expect(line.count < overview.count)
    }

    @Test("show line delegates to the underlying media kind")
    func showLine() {
        let movieShow = Show.movie(.mock(id: 11, title: "Film"))
        let tvShow = Show.tvSeries(.mock(id: 22, name: "Series"))

        #expect(ToolOutputFormatter.line(for: movieShow).hasPrefix("movie | 11"))
        #expect(ToolOutputFormatter.line(for: tvShow).hasPrefix("tv | 22"))
    }

    // MARK: - Detail blocks

    @Test("movie block includes id, genres, runtime, status and overview")
    func movieBlock() {
        let movie = Movie.mock(
            id: 27205,
            title: "Inception",
            tagline: "Your mind is the scene of the crime.",
            overview: "A thief enters dreams.",
            runtime: 148,
            genres: [Genre(id: 28, name: "Action"), Genre(id: 878, name: "Science Fiction")],
            releaseDate: Date(iso8601: "2010-07-16T00:00:00Z"),
            status: .released,
            voteAverage: 8.4
        )

        let block = ToolOutputFormatter.block(for: movie)

        #expect(block.hasPrefix("movie | 27205 | Inception (2010)"))
        #expect(block.contains("148 min"))
        #expect(block.contains("genres: Action, Science Fiction"))
        #expect(block.contains("⭐8.4"))
        #expect(block.contains("status: Released"))
        #expect(block.contains("tagline: Your mind is the scene of the crime."))
        #expect(block.contains("overview: A thief enters dreams."))
    }

    @Test("tv series block includes id, season count and status")
    func tvSeriesBlock() {
        let tvSeries = TVSeries.mock(
            id: 1396,
            name: "Breaking Bad",
            overview: "A teacher turns to crime.",
            numberOfSeasons: 5,
            genres: [Genre(id: 18, name: "Drama")],
            firstAirDate: Date(iso8601: "2008-01-20T00:00:00Z"),
            status: "Ended",
            voteAverage: 8.9
        )

        let block = ToolOutputFormatter.block(for: tvSeries)

        #expect(block.hasPrefix("tv | 1396 | Breaking Bad (2008)"))
        #expect(block.contains("5 seasons"))
        #expect(block.contains("genres: Drama"))
        #expect(block.contains("status: Ended"))
        #expect(block.contains("overview: A teacher turns to crime."))
    }

    @Test("person header includes id, name and department")
    func personHeader() {
        let person = Person.mock(id: 287, name: "Brad Pitt", knownForDepartment: "Acting")
        let header = ToolOutputFormatter.header(for: person)

        #expect(header == "person | 287 | Brad Pitt | Acting")
    }

    // MARK: - Watch providers

    @Test("watch providers groups flat-rate as stream and skips empty groups")
    func watchProvidersGrouping() {
        let providers = ShowWatchProvider.mock(
            free: nil,
            flatRate: [.netflix],
            buy: nil,
            rent: [WatchProvider.mock(id: 2, name: "Apple TV")],
            ads: nil
        )

        let output = ToolOutputFormatter.watchProviders(
            id: 27205,
            countryCode: "GB",
            providers: providers
        )

        #expect(output.hasPrefix("watchProviders | 27205 | GB"))
        #expect(output.contains("stream: Netflix"))
        #expect(output.contains("rent: Apple TV"))
        #expect(!output.contains("free:"))
        #expect(!output.contains("buy:"))
        #expect(!output.contains("ads:"))
    }

    @Test("watch providers returns a none message when all groups are empty")
    func watchProvidersNone() {
        let providers = ShowWatchProvider.mock(
            free: nil,
            flatRate: nil,
            buy: nil,
            rent: nil,
            ads: nil
        )

        let output = ToolOutputFormatter.watchProviders(
            id: 99,
            countryCode: "US",
            providers: providers
        )

        #expect(output == "No watch providers listed for id 99 in US.")
    }

    // MARK: - Helpers

    @Test("year is extracted in UTC")
    func yearExtraction() {
        let date = Date(iso8601: "1999-12-31T23:00:00Z")
        #expect(ToolOutputFormatter.year(from: date) == 1999)
        #expect(ToolOutputFormatter.year(from: nil) == nil)
    }

}
