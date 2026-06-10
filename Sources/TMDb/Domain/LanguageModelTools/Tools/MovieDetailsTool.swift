//
//  MovieDetailsTool.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

#if canImport(FoundationModels) && !os(tvOS)
    import Foundation
    import FoundationModels

    ///
    /// A language model tool that fetches full details for a movie by its TMDb id.
    ///
    @available(iOS 26, macOS 26, visionOS 26, watchOS 27, *)
    struct MovieDetailsTool: Tool {

        let name = "movieDetails"
        let description = """
        Get full details for a movie by its TMDb id, including overview, runtime, \
        genres, rating, and release year. Get the id from search.
        """

        private let movieService: any MovieService
        private let language: String?

        init(movieService: any MovieService, language: String? = nil) {
            self.movieService = movieService
            self.language = language
        }

        ///
        /// The arguments for a movie details lookup.
        ///
        @Generable
        struct Arguments {
            /// The TMDb movie id.
            @Guide(description: "The TMDb movie id, for example from search", .minimum(1))
            var movieID: Int
        }

        func call(arguments: Arguments) async throws -> String {
            do {
                let movie = try await movieService.details(
                    forMovie: arguments.movieID,
                    language: language
                )
                return ToolOutputFormatter.block(for: movie)
            } catch {
                if let message = ToolErrorMapper.message(
                    for: error,
                    entity: "movie",
                    id: arguments.movieID
                ) {
                    return message
                }
                throw error
            }
        }

    }
#endif
