//
//  MovieCreditsTool.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

#if canImport(FoundationModels) && !os(tvOS)
    import Foundation
    import FoundationModels

    ///
    /// A language model tool that fetches the principal cast and crew for a movie
    /// by its TMDb id.
    ///
    @available(iOS 26, macOS 26, visionOS 26, watchOS 27, *)
    struct MovieCreditsTool: Tool {

        let name = "movieCredits"
        let description = """
        Get the principal cast and crew (top-billed cast plus director and writers) \
        for a movie by its TMDb id. Get the id from search.
        """

        private let movieService: any MovieService
        private let language: String?

        init(movieService: any MovieService, language: String? = nil) {
            self.movieService = movieService
            self.language = language
        }

        ///
        /// The arguments for a movie credits lookup.
        ///
        @Generable
        struct Arguments {
            /// The TMDb movie id.
            @Guide(description: "The TMDb movie id, for example from search", .minimum(1))
            var movieID: Int
        }

        func call(arguments: Arguments) async throws -> String {
            do {
                let credits = try await movieService.credits(
                    forMovie: arguments.movieID,
                    language: language
                )
                return ToolOutputFormatter.block(for: credits)
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
