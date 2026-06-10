//
//  DiscoverMoviesTool.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

#if canImport(FoundationModels) && !os(tvOS)
    import Foundation
    import FoundationModels

    ///
    /// A language model tool that browses movies by attributes — genre, release
    /// year, minimum rating, and streaming provider — when no specific title is
    /// named.
    ///
    @available(iOS 26, macOS 26, visionOS 26, watchOS 27, *)
    struct DiscoverMoviesTool: Tool {

        let name = "discoverMovies"
        let description = """
        Browse movies by attributes such as genre, year range, minimum rating, or \
        streaming provider, when no specific title is named.
        """

        private static let defaultWatchRegion = "US"

        private let discoverService: any DiscoverService
        private let watchProviderService: any WatchProviderService
        private let language: String?
        private let region: String?

        init(
            discoverService: any DiscoverService,
            watchProviderService: any WatchProviderService,
            language: String? = nil,
            region: String? = nil
        ) {
            self.discoverService = discoverService
            self.watchProviderService = watchProviderService
            self.language = language
            self.region = region
        }

        ///
        /// The arguments for a movie discovery request.
        ///
        @Generable
        struct Arguments {
            /// A genre to filter by.
            @Guide(description: "Genre to filter by")
            var genre: MovieGenre?

            /// The earliest release year.
            @Guide(description: "Earliest release year, for example 1990")
            var yearFrom: Int?

            /// The latest release year.
            @Guide(description: "Latest release year, for example 1999")
            var yearTo: Int?

            /// The minimum average rating, from 0 to 10.
            @Guide(description: "Minimum average rating from 0 to 10")
            var minRating: Double?

            /// A streaming provider name to filter by.
            @Guide(description: "Streaming provider name such as Netflix")
            var watchProvider: String?

            /// The ISO-3166-1 country code for the streaming provider.
            @Guide(description: "Two-letter ISO country code for the provider, such as GB")
            var watchRegion: String?
        }

        func call(arguments: Arguments) async throws -> String {
            let watchRegion = resolvedRegion(arguments.watchRegion)
            do {
                let providerIDs = try await resolveProviderIDs(
                    named: arguments.watchProvider,
                    in: watchRegion
                )
                if case .failure(let message) = providerIDs {
                    return message
                }

                let resolvedProviderIDs = providerIDs.value
                let filter = DiscoverMovieFilter(
                    genres: arguments.genre.map { [$0.genreID] },
                    primaryReleaseYear: yearFilter(from: arguments.yearFrom, to: arguments.yearTo),
                    voteAverageMin: arguments.minRating.map { min(max($0, 0), 10) },
                    watchProviders: resolvedProviderIDs,
                    watchRegion: resolvedProviderIDs == nil
                        ? nil
                        : (watchRegion ?? Self.defaultWatchRegion)
                )

                let list = try await discoverService.movies(
                    filter: filter,
                    sortedBy: .popularity(descending: true),
                    page: 1,
                    language: language
                )

                return ToolOutputFormatter.mediaList(
                    list.results.map(Media.movie),
                    limit: ToolOutputFormatter.defaultListLimit,
                    query: "those filters"
                )
            } catch {
                if let message = ToolErrorMapper.message(for: error) {
                    return message
                }
                throw error
            }
        }

        /// The outcome of resolving a provider name to its identifiers.
        private enum ProviderResolution {
            case none
            case resolved([WatchProvider.ID])
            case failure(String)

            var value: [WatchProvider.ID]? {
                switch self {
                case .resolved(let ids): ids
                case .none, .failure: nil
                }
            }
        }

        private func resolveProviderIDs(
            named name: String?,
            in watchRegion: String?
        ) async throws(TMDbError) -> ProviderResolution {
            guard let providerName = trimmedNonEmpty(name) else {
                return .none
            }

            let providers = try await watchProviderService.movieWatchProviders(
                filter: WatchProviderFilter(country: watchRegion ?? Self.defaultWatchRegion),
                language: language
            )
            guard let match = providers.first(
                where: { $0.name.localizedCaseInsensitiveContains(providerName) }
            )
            else {
                return .failure(
                    "Unknown streaming provider '\(providerName)'. Try a name like Netflix, "
                        + "Disney Plus, or Amazon Prime Video."
                )
            }

            return .resolved([match.id])
        }

        private func yearFilter(
            from lower: Int?,
            to upper: Int?
        ) -> DiscoverMovieFilter.PrimaryReleaseYearFilter? {
            switch (lower, upper) {
            case (nil, nil):
                return nil

            case (let lower?, nil):
                return .from(lower)

            case (nil, let upper?):
                return .upTo(upper)

            case (let lower?, let upper?):
                if lower == upper {
                    return .on(lower)
                }

                // Tolerate an inverted range from the model rather than submitting
                // a bound that always returns zero results.
                return .between(start: min(lower, upper), end: max(lower, upper))
            }
        }

        private func resolvedRegion(_ argument: String?) -> String? {
            if let argument = trimmedNonEmpty(argument) {
                return argument.uppercased()
            }
            if let region, !region.isEmpty {
                return region.uppercased()
            }

            return nil
        }

        private func trimmedNonEmpty(_ value: String?) -> String? {
            guard let trimmed = value?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !trimmed.isEmpty
            else {
                return nil
            }

            return trimmed
        }

    }
#endif
