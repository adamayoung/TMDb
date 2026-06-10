//
//  SearchTMDbTool.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

#if canImport(FoundationModels) && !os(tvOS)
    import Foundation
    import FoundationModels

    ///
    /// A language model tool that searches TMDb for movies, TV series, and people
    /// by name, returning the ids other tools need.
    ///
    @available(iOS 26, macOS 26, visionOS 26, watchOS 27, *)
    struct SearchTMDbTool: Tool {

        let name = "search"
        let description = """
        Find a specific movie, TV show, or person by name. Do not use for browsing by \
        genre, year, or rating (use discoverMovies) or for trending feeds (use trending).
        """

        private let searchService: any SearchService
        private let language: String?

        init(searchService: any SearchService, language: String? = nil) {
            self.searchService = searchService
            self.language = language
        }

        ///
        /// The arguments for a TMDb search.
        ///
        @Generable
        struct Arguments {
            /// The movie, TV show, or person name to search for.
            @Guide(description: "The movie, TV show, or person name to search for")
            var query: String

            /// An optional media type to limit results to.
            @Guide(description: "Optionally limit results to movie, tvSeries, or person")
            var mediaType: SearchMediaType?
        }

        func call(arguments: Arguments) async throws -> String {
            let query = arguments.query.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !query.isEmpty else {
                return "Provide a movie, TV show, or person name to search for."
            }

            do {
                let list = try await searchService.searchAll(query: query, page: 1, language: language)
                let filtered = list.results.filter { include($0, matching: arguments.mediaType) }
                return ToolOutputFormatter.mediaList(
                    filtered,
                    limit: ToolOutputFormatter.defaultListLimit,
                    query: query
                )
            } catch {
                if let message = ToolErrorMapper.message(for: error) {
                    return message
                }
                throw error
            }
        }

        private func include(_ media: Media, matching type: SearchMediaType?) -> Bool {
            switch (type, media) {
            case (nil, _),
                 (.movie?, .movie),
                 (.tvSeries?, .tvSeries),
                 (.person?, .person):
                true

            default:
                false
            }
        }

    }
#endif
