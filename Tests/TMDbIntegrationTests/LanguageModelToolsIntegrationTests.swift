//
//  LanguageModelToolsIntegrationTests.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

// Compiles only against the macOS 26 / FoundationModels SDK; the tools validate
// their formatting against live API data without invoking Apple Intelligence.
#if canImport(FoundationModels) && os(macOS)
    import Foundation
    import Testing
    @testable import TMDb

    @Suite(
        .integrationGate,
        .serialized,
        .tags(.languageModelTools),
        .enabled(if: CredentialHelper.shared.hasAPIKey)
    )
    struct LanguageModelToolsIntegrationTests {

        // Durable TMDb anchors used elsewhere in the integration suite.
        private let fightClubID = 550
        private let breakingBadID = 1396
        private let bradPittID = 287

        private var client: TMDbClient {
            CredentialHelper.shared.makeClient()
        }

        @available(macOS 26, *)
        @Test("search resolves a title to an id-bearing line")
        func search() async throws {
            let tool = SearchTMDbTool(searchService: client.search)
            let output = try await tool.call(arguments: .init(query: "Fight Club", mediaType: .movie))

            #expect(output.contains("\(fightClubID)"))
            #expect(output.localizedCaseInsensitiveContains("Fight Club"))
        }

        @available(macOS 26, *)
        @Test("movie details returns a block for a known movie")
        func movieDetails() async throws {
            let tool = MovieDetailsTool(movieService: client.movies)
            let output = try await tool.call(arguments: .init(movieID: fightClubID))

            #expect(output.hasPrefix("movie | \(fightClubID)"))
            #expect(output.localizedCaseInsensitiveContains("Fight Club"))
        }

        @available(macOS 26, *)
        @Test("movie credits returns an id-bearing credits block for a known movie")
        func movieCredits() async throws {
            let tool = MovieCreditsTool(movieService: client.movies)
            let output = try await tool.call(arguments: .init(movieID: fightClubID))

            #expect(output.hasPrefix("credits | \(fightClubID)"))
            #expect(output.contains("cast | "))
            #expect(output.localizedCaseInsensitiveContains("Brad Pitt"))
        }

        @available(macOS 26, *)
        @Test("tv series details returns a block for a known series")
        func tvSeriesDetails() async throws {
            let tool = TVSeriesDetailsTool(tvSeriesService: client.tvSeries)
            let output = try await tool.call(arguments: .init(tvSeriesID: breakingBadID))

            #expect(output.hasPrefix("tv | \(breakingBadID)"))
            #expect(output.localizedCaseInsensitiveContains("Breaking Bad"))
        }

        @available(macOS 26, *)
        @Test("person filmography returns a header and credits")
        func personFilmography() async throws {
            let tool = PersonFilmographyTool(personService: client.people)
            let output = try await tool.call(arguments: .init(personID: bradPittID, maxCredits: 5))
            let lines = output.components(separatedBy: "\n")

            #expect(output.contains("person | \(bradPittID)"))
            #expect(output.localizedCaseInsensitiveContains("Brad Pitt"))
            #expect(lines.count > 1)
        }

        @available(macOS 26, *)
        @Test("trending returns id-bearing movie lines")
        func trending() async throws {
            let tool = TrendingTool(trendingService: client.trending)
            let output = try await tool.call(arguments: .init(mediaType: .movie, timeWindow: .week))

            #expect(output.contains("movie | "))
        }

        @available(macOS 26, *)
        @Test("watch providers returns a self-describing result")
        func watchProviders() async throws {
            let tool = WatchProvidersTool(
                movieService: client.movies,
                tvSeriesService: client.tvSeries
            )
            let output = try await tool.call(
                arguments: .init(mediaType: .movie, id: fightClubID, countryCode: "US")
            )

            #expect(output.contains("\(fightClubID)"))
        }

        @available(macOS 26, *)
        @Test("discover movies returns id-bearing movie lines for a genre")
        func discoverMovies() async throws {
            let tool = DiscoverMoviesTool(
                discoverService: client.discover,
                watchProviderService: client.watchProviders
            )
            let output = try await tool.call(
                arguments: .init(
                    genre: .thriller,
                    yearFrom: 2010,
                    yearTo: 2019,
                    minRating: 7,
                    watchProvider: nil,
                    watchRegion: nil
                )
            )

            #expect(output.contains("movie | "))
        }

    }
#endif
