//
//  WatchProvidersTool.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

#if canImport(FoundationModels) && !os(tvOS)
    import Foundation
    import FoundationModels

    ///
    /// A language model tool that finds where a specific movie or TV series can be
    /// streamed, rented, or bought in a country.
    ///
    @available(iOS 26, macOS 26, visionOS 26, watchOS 27, *)
    struct WatchProvidersTool: Tool {

        let name = "watchProviders"
        let description = """
        Find where a specific movie or TV series can be streamed, rented, or bought \
        in a country, by its TMDb id. To browse what is on a provider, use \
        discoverMovies instead.
        """

        private static let defaultCountryCode = "US"

        private let movieService: any MovieService
        private let tvSeriesService: any TVSeriesService
        private let region: String?

        init(
            movieService: any MovieService,
            tvSeriesService: any TVSeriesService,
            region: String? = nil
        ) {
            self.movieService = movieService
            self.tvSeriesService = tvSeriesService
            self.region = region
        }

        ///
        /// The arguments for a watch providers lookup.
        ///
        @Generable
        struct Arguments {
            /// Whether the id is a movie or TV series.
            @Guide(description: "Whether the id is for a movie or tvSeries")
            var mediaType: WatchMediaType

            /// The TMDb id of the movie or TV series.
            @Guide(description: "The TMDb id of the movie or TV series", .minimum(1))
            var id: Int

            /// The ISO-3166-1 country code to look up providers for.
            @Guide(description: "Two-letter ISO country code such as GB or US")
            var countryCode: String?
        }

        func call(arguments: Arguments) async throws -> String {
            let country = resolvedCountryCode(arguments.countryCode)
            do {
                let byCountry = try await fetch(arguments.mediaType, id: arguments.id)
                guard let match = byCountry.first(
                    where: { $0.countryCode.caseInsensitiveCompare(country) == .orderedSame }
                )
                else {
                    return "No watch providers found for id \(arguments.id) in \(country)."
                }

                return ToolOutputFormatter.watchProviders(
                    id: arguments.id,
                    countryCode: country,
                    providers: match.watchProviders
                )
            } catch {
                if let message = ToolErrorMapper.message(
                    for: error,
                    entity: entity(for: arguments.mediaType),
                    id: arguments.id
                ) {
                    return message
                }
                throw error
            }
        }

        private func fetch(
            _ mediaType: WatchMediaType,
            id: Int
        ) async throws(TMDbError) -> [ShowWatchProvidersByCountry] {
            switch mediaType {
            case .movie:
                try await movieService.watchProviders(forMovie: id)
            case .tvSeries:
                try await tvSeriesService.watchProviders(forTVSeries: id)
            }
        }

        private func resolvedCountryCode(_ argument: String?) -> String {
            let candidate = argument?.trimmingCharacters(in: .whitespacesAndNewlines)
            if let candidate, !candidate.isEmpty {
                return candidate.uppercased()
            }
            if let region, !region.isEmpty {
                return region.uppercased()
            }

            return Self.defaultCountryCode
        }

        private func entity(for mediaType: WatchMediaType) -> String {
            switch mediaType {
            case .movie: "movie"
            case .tvSeries: "TV series"
            }
        }

    }
#endif
