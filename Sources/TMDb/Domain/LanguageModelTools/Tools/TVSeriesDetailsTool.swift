//
//  TVSeriesDetailsTool.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

#if canImport(FoundationModels) && !os(tvOS)
    import Foundation
    import FoundationModels

    ///
    /// A language model tool that fetches full details for a TV series by its TMDb
    /// id.
    ///
    @available(iOS 26, macOS 26, visionOS 26, watchOS 27, *)
    struct TVSeriesDetailsTool: Tool {

        let name = "tvSeriesDetails"
        let description = """
        Get full details for a TV series by its TMDb id, including overview, genres, \
        rating, status, and first-air year. Get the id from search.
        """

        private let tvSeriesService: any TVSeriesService
        private let language: String?

        init(tvSeriesService: any TVSeriesService, language: String? = nil) {
            self.tvSeriesService = tvSeriesService
            self.language = language
        }

        ///
        /// The arguments for a TV series details lookup.
        ///
        @Generable
        struct Arguments {
            /// The TMDb TV series id.
            @Guide(description: "The TMDb TV series id, for example from search", .minimum(1))
            var tvSeriesID: Int
        }

        func call(arguments: Arguments) async throws -> String {
            do {
                let tvSeries = try await tvSeriesService.details(
                    forTVSeries: arguments.tvSeriesID,
                    language: language
                )
                return ToolOutputFormatter.block(for: tvSeries)
            } catch {
                if let message = ToolErrorMapper.message(
                    for: error,
                    entity: "TV series",
                    id: arguments.tvSeriesID
                ) {
                    return message
                }
                throw error
            }
        }

    }
#endif
