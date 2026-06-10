//
//  PersonFilmographyTool.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

#if canImport(FoundationModels) && !os(tvOS)
    import Foundation
    import FoundationModels

    ///
    /// A language model tool that fetches a person's profile and most notable
    /// movie and TV credits by their TMDb id.
    ///
    @available(iOS 26, macOS 26, visionOS 26, watchOS 27, *)
    struct PersonFilmographyTool: Tool {

        let name = "personFilmography"
        let description = """
        Get a person's profile and notable movie and TV credits by their TMDb id. \
        Get the id from search.
        """

        private static let defaultMaxCredits = 12

        private let personService: any PersonService
        private let language: String?

        init(personService: any PersonService, language: String? = nil) {
            self.personService = personService
            self.language = language
        }

        ///
        /// The arguments for a person filmography lookup.
        ///
        @Generable
        struct Arguments {
            /// The TMDb person id.
            @Guide(description: "The TMDb person id, for example from search", .minimum(1))
            var personID: Int

            /// The maximum number of credits to list.
            @Guide(description: "Maximum number of credits to list, from 1 to 20")
            var maxCredits: Int?
        }

        func call(arguments: Arguments) async throws -> String {
            do {
                let person = try await personService.details(
                    forPerson: arguments.personID,
                    language: language
                )
                let credits = try await personService.combinedCredits(
                    forPerson: arguments.personID,
                    language: language
                )

                let limit = arguments.maxCredits ?? Self.defaultMaxCredits
                let shows = credits.allShows
                    .sorted(by: isMoreNotable)
                    .prefix(limit)

                var lines = [ToolOutputFormatter.header(for: person)]
                if shows.isEmpty {
                    lines.append("No notable credits found.")
                } else {
                    lines.append(contentsOf: shows.map(ToolOutputFormatter.line(for:)))
                }

                return lines.joined(separator: "\n")
            } catch {
                if let message = ToolErrorMapper.message(
                    for: error,
                    entity: "person",
                    id: arguments.personID
                ) {
                    return message
                }
                throw error
            }
        }

        private func isMoreNotable(_ lhs: Show, _ rhs: Show) -> Bool {
            let lhsPopularity = popularity(of: lhs)
            let rhsPopularity = popularity(of: rhs)
            if lhsPopularity != rhsPopularity {
                return lhsPopularity > rhsPopularity
            }

            return lhs.id < rhs.id
        }

        private func popularity(of show: Show) -> Double {
            switch show {
            case .movie(let movie): movie.popularity ?? 0
            case .tvSeries(let tvSeries): tvSeries.popularity ?? 0
            }
        }

    }
#endif
