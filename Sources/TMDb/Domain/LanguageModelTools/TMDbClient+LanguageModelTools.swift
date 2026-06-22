//
//  TMDbClient+LanguageModelTools.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

#if canImport(FoundationModels) && !os(tvOS)
    import FoundationModels

    @available(iOS 26, macOS 26, visionOS 26, watchOS 27, *)
    public extension TMDbClient {

        ///
        /// FoundationModels `Tool`s that expose TMDb to a `LanguageModelSession`,
        /// for building a conversational movie assistant.
        ///
        /// ```swift
        /// let session = LanguageModelSession(tools: tmdbClient.languageModelTools)
        /// let reply = try await session.respond(to: "What's trending this week?")
        /// ```
        ///
        /// Each tool returns compact text whose every line leads with the relevant
        /// TMDb `id`, so the model can chain calls — searching for a title, then
        /// fetching its details or watch providers.
        ///
        /// - Note: This is a shorthand for `TMDbToolbox(client:).all`. To pass a
        ///   smaller, task-relevant subset of tools, combine the individual tool
        ///   properties below — for example
        ///   `[searchTool, watchProvidersTool]`. To apply a default language or
        ///   region, construct a ``TMDbToolbox`` directly. Each access builds a new
        ///   toolbox, so store the result in a local rather than accessing it twice.
        ///
        var languageModelTools: [any Tool] {
            TMDbToolbox(client: self).all
        }

        ///
        /// A FoundationModels tool that searches TMDb for movies, TV series, and
        /// people by name.
        ///
        var searchTool: any Tool {
            TMDbToolbox(client: self).search
        }

        ///
        /// A FoundationModels tool that fetches full details for a movie by its
        /// TMDb id.
        ///
        var movieDetailsTool: any Tool {
            TMDbToolbox(client: self).movieDetails
        }

        ///
        /// A FoundationModels tool that fetches the principal cast and crew for a
        /// movie by its TMDb id.
        ///
        var movieCreditsTool: any Tool {
            TMDbToolbox(client: self).movieCredits
        }

        ///
        /// A FoundationModels tool that fetches full details for a TV series by its
        /// TMDb id.
        ///
        var tvSeriesDetailsTool: any Tool {
            TMDbToolbox(client: self).tvSeriesDetails
        }

        ///
        /// A FoundationModels tool that fetches a person's profile and notable
        /// credits by their TMDb id.
        ///
        var personFilmographyTool: any Tool {
            TMDbToolbox(client: self).personFilmography
        }

        ///
        /// A FoundationModels tool that lists currently trending movies, TV series,
        /// or people.
        ///
        var trendingTool: any Tool {
            TMDbToolbox(client: self).trending
        }

        ///
        /// A FoundationModels tool that finds where a movie or TV series can be
        /// streamed, rented, or bought.
        ///
        var watchProvidersTool: any Tool {
            TMDbToolbox(client: self).watchProviders
        }

        ///
        /// A FoundationModels tool that browses movies by genre, year, rating, and
        /// streaming provider.
        ///
        var discoverMoviesTool: any Tool {
            TMDbToolbox(client: self).discoverMovies
        }

    }
#endif
