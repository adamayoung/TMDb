//
//  TMDbToolbox.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

#if canImport(FoundationModels) && !os(tvOS)
    import Foundation
    import FoundationModels

    ///
    /// A collection of FoundationModels `Tool`s that expose TMDb to a
    /// `LanguageModelSession`, for building a conversational movie assistant.
    ///
    /// Pass ``all`` to a session to make every tool available, or compose a smaller,
    /// task-relevant subset from the individual accessors — Apple recommends keeping
    /// to three to five tools per request:
    ///
    /// ```swift
    /// let toolbox = TMDbToolbox(client: tmdbClient, region: "GB")
    /// let session = LanguageModelSession(tools: toolbox.all)
    /// let reply = try await session.respond(to: "What's a good thriller on Netflix UK?")
    /// ```
    ///
    /// Each tool returns compact text whose every line leads with the relevant TMDb
    /// `id`, so the model can chain calls — searching for a title, then fetching its
    /// details or watch providers.
    ///
    /// - Note: ``TMDbClient/languageModelTools`` is a shorthand for
    ///   `TMDbToolbox(client:).all`.
    ///
    @available(iOS 26, macOS 26, visionOS 26, watchOS 27, *)
    public struct TMDbToolbox: Sendable {

        private let movieService: any MovieService
        private let tvSeriesService: any TVSeriesService
        private let personService: any PersonService
        private let searchService: any SearchService
        private let trendingService: any TrendingService
        private let discoverService: any DiscoverService
        private let watchProviderService: any WatchProviderService
        private let language: String?
        private let region: String?

        ///
        /// Creates a toolbox backed by a TMDb client.
        ///
        /// - Parameters:
        ///   - client: The TMDb client whose services the tools call.
        ///   - language: An optional ISO 639-1 language code applied to every tool's
        ///     results. Defaults to the client's configured language when `nil`.
        ///   - region: An optional ISO-3166-1 country code used for watch-provider
        ///     and streaming-availability lookups. Defaults to `US` when `nil`.
        ///
        public init(client: TMDbClient, language: String? = nil, region: String? = nil) {
            self.init(
                movieService: client.movies,
                tvSeriesService: client.tvSeries,
                personService: client.people,
                searchService: client.search,
                trendingService: client.trending,
                discoverService: client.discover,
                watchProviderService: client.watchProviders,
                language: language,
                region: region
            )
        }

        init(
            movieService: any MovieService,
            tvSeriesService: any TVSeriesService,
            personService: any PersonService,
            searchService: any SearchService,
            trendingService: any TrendingService,
            discoverService: any DiscoverService,
            watchProviderService: any WatchProviderService,
            language: String?,
            region: String?
        ) {
            self.movieService = movieService
            self.tvSeriesService = tvSeriesService
            self.personService = personService
            self.searchService = searchService
            self.trendingService = trendingService
            self.discoverService = discoverService
            self.watchProviderService = watchProviderService
            self.language = language
            self.region = region
        }

        ///
        /// Every tool in the toolbox, ready to pass to a `LanguageModelSession`.
        ///
        /// Each access builds a new set of tool instances; store the result in a
        /// local if you need it more than once.
        ///
        public var all: [any Tool] {
            [
                search,
                movieDetails,
                movieCredits,
                tvSeriesDetails,
                personFilmography,
                trending,
                watchProviders,
                discoverMovies
            ]
        }

        ///
        /// A tool that searches TMDb for movies, TV series, and people by name.
        ///
        public var search: any Tool {
            SearchTMDbTool(searchService: searchService, language: language)
        }

        ///
        /// A tool that fetches full details for a movie by its TMDb id.
        ///
        public var movieDetails: any Tool {
            MovieDetailsTool(movieService: movieService, language: language)
        }

        ///
        /// A tool that fetches the principal cast and crew for a movie by its TMDb
        /// id.
        ///
        public var movieCredits: any Tool {
            MovieCreditsTool(movieService: movieService, language: language)
        }

        ///
        /// A tool that fetches full details for a TV series by its TMDb id.
        ///
        public var tvSeriesDetails: any Tool {
            TVSeriesDetailsTool(tvSeriesService: tvSeriesService, language: language)
        }

        ///
        /// A tool that fetches a person's profile and notable credits by their TMDb
        /// id.
        ///
        public var personFilmography: any Tool {
            PersonFilmographyTool(personService: personService, language: language)
        }

        ///
        /// A tool that lists currently trending movies, TV series, or people.
        ///
        public var trending: any Tool {
            TrendingTool(trendingService: trendingService, language: language)
        }

        ///
        /// A tool that finds where a movie or TV series can be streamed, rented, or
        /// bought.
        ///
        public var watchProviders: any Tool {
            WatchProvidersTool(
                movieService: movieService,
                tvSeriesService: tvSeriesService,
                region: region
            )
        }

        ///
        /// A tool that browses movies by genre, year, rating, and streaming provider.
        ///
        public var discoverMovies: any Tool {
            DiscoverMoviesTool(
                discoverService: discoverService,
                watchProviderService: watchProviderService,
                language: language,
                region: region
            )
        }

    }
#endif
