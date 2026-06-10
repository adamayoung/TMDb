//
//  TrendingTool.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

#if canImport(FoundationModels) && !os(tvOS)
    import Foundation
    import FoundationModels

    ///
    /// A language model tool that lists currently trending movies, TV series, or
    /// people on TMDb.
    ///
    @available(iOS 26, macOS 26, visionOS 26, watchOS 27, *)
    struct TrendingTool: Tool {

        let name = "trending"
        let description = """
        List what is currently trending or popular on TMDb (daily or weekly). Only \
        for trending feeds, not for searching or browsing by attribute.
        """

        private let trendingService: any TrendingService
        private let language: String?

        init(trendingService: any TrendingService, language: String? = nil) {
            self.trendingService = trendingService
            self.language = language
        }

        ///
        /// The arguments for a trending request.
        ///
        @Generable
        struct Arguments {
            /// The media type to list.
            @Guide(description: "Which media type to list: movie, tvSeries, or person")
            var mediaType: TrendingMediaType

            /// The trending time window.
            @Guide(description: "Trending window: day or week")
            var timeWindow: TrendingWindow
        }

        func call(arguments: Arguments) async throws -> String {
            let window = arguments.timeWindow.filterType
            do {
                let media = try await fetch(arguments.mediaType, inTimeWindow: window)
                return ToolOutputFormatter.mediaList(
                    media,
                    limit: ToolOutputFormatter.defaultListLimit,
                    query: label(for: arguments.mediaType)
                )
            } catch {
                if let message = ToolErrorMapper.message(for: error) {
                    return message
                }
                throw error
            }
        }

        private func fetch(
            _ mediaType: TrendingMediaType,
            inTimeWindow window: TrendingTimeWindowFilterType
        ) async throws(TMDbError) -> [Media] {
            switch mediaType {
            case .movie:
                let list = try await trendingService.movies(
                    inTimeWindow: window,
                    page: 1,
                    language: language
                )
                return list.results.map(Media.movie)

            case .tvSeries:
                let list = try await trendingService.tvSeries(
                    inTimeWindow: window,
                    page: 1,
                    language: language
                )
                return list.results.map(Media.tvSeries)

            case .person:
                let list = try await trendingService.people(
                    inTimeWindow: window,
                    page: 1,
                    language: language
                )
                return list.results.map(Media.person)
            }
        }

        private func label(for mediaType: TrendingMediaType) -> String {
            switch mediaType {
            case .movie: "trending movies"
            case .tvSeries: "trending TV series"
            case .person: "trending people"
            }
        }

    }
#endif
