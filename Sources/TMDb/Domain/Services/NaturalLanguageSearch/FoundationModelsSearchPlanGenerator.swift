//
//  FoundationModelsSearchPlanGenerator.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

#if canImport(FoundationModels)
    import Foundation
    import FoundationModels

    ///
    /// A ``SearchPlanGenerating`` backed by the on-device Foundation Models model.
    ///
    /// A fresh ``LanguageModelSession`` is created for each request, so the session
    /// never needs to be stored or shared across isolation boundaries.
    ///
    @available(iOS 26, macOS 26, visionOS 26, *)
    struct FoundationModelsSearchPlanGenerator: SearchPlanGenerating {

        private let model: SystemLanguageModel
        private let now: @Sendable () -> Date

        init(
            model: SystemLanguageModel = .default,
            now: @escaping @Sendable () -> Date = { Date() }
        ) {
            self.model = model
            self.now = now
        }

        var availability: NaturalLanguageSearchAvailability {
            switch model.availability {
            case .available:
                .available
            case .unavailable(let reason):
                .unavailable(Self.mapReason(reason))
            @unknown default:
                .unavailable(.unsupportedOS)
            }
        }

        func plan(for prompt: String) async throws -> SearchPlan {
            do {
                return try await generatePlan(for: prompt)
            } catch let error as LanguageModelSession.GenerationError {
                // One bounded retry, with a fresh session, for a malformed
                // (decoding) failure before giving up.
                if case .decodingFailure = error {
                    return try await retryAfterDecodingFailure(for: prompt)
                }
                throw await Self.mapError(error)
            } catch {
                throw NaturalLanguageSearchError.planningFailed(underlying: error)
            }
        }

        private func generatePlan(for prompt: String) async throws -> SearchPlan {
            let session = LanguageModelSession(instructions: instructions())
            let response = try await session.respond(
                to: prompt,
                generating: GeneratedSearchPlan.self
            )
            return SearchPlanMapper.map(response.content)
        }

        private func retryAfterDecodingFailure(for prompt: String) async throws -> SearchPlan {
            do {
                return try await generatePlan(for: prompt)
            } catch let error as LanguageModelSession.GenerationError {
                throw await Self.mapError(error)
            } catch {
                throw NaturalLanguageSearchError.planningFailed(underlying: error)
            }
        }

    }

    @available(iOS 26, macOS 26, visionOS 26, *)
    extension FoundationModelsSearchPlanGenerator {

        // swiftlint:disable:next function_body_length
        private func instructions() -> String {
            let year = Calendar(identifier: .gregorian).component(.year, from: now())
            return """
            You convert a movie or TV search request into a structured plan that is run against a \
            database. Only copy words the user actually typed into title, people, genres, or \
            companies. You MAY use your knowledge to decide whether a name the user wrote is a \
            PERSON or a TITLE, but never ADD entities the user did not write. In particular, put a \
            name in people ONLY if the user literally typed that name; NEVER fill people with the \
            cast or actors of a title (e.g. "Fight Club" has empty people).

            Pick exactly ONE intent. Check these rules in order and use the first that matches:
            1. list — a request for a feed with words like trending, popular, top rated, best, \
            new releases, now playing, in cinemas, in theaters, upcoming, coming soon, airing \
            today. Also set the list field.
            2. similar — words like "like", "similar to", "in the vein of", "reminds me of", or \
            "recommendations based on" a named title. Put that title in title.
            3. castOf — asks for the cast, actors, stars, "who's in", "who stars in", or "people \
            in" a named title. Put the title in title.
            4. crewRole — asks who did a job ("director of", "who directed", "who wrote", \
            "composer of") for a named title. Put the title in title and the job in crewRole.
            5. filmography — match by PHRASING, not by recognising the name. If the request fits any \
            of these shapes where NAME is a capitalised person name, use filmography and put NAME in \
            people (leave title empty): "movies/films/shows with NAME", "movies/films starring \
            NAME", "movies/films featuring NAME", "NAME movies", "NAME films", "movies/films by \
            NAME", "directed by NAME". This holds even if you do not recognise NAME. Never send \
            these to find or browse.
            6. mood — a subjective vibe word like feel-good, cozy, scary, uplifting. Set moodTerm.
            7. browse — describes only attributes: genre, decade, year, country, language, \
            runtime, or rating (e.g. "90s sci-fi", "Korean horror", "highly rated documentaries").
            8. find — LAST RESORT: only when the request is a single title with no other words. If \
            the request pairs a person with movie/film/show words, use filmography, not find.

            If the request is not about movies, TV series, or people at all (books, food, weather, \
            directions, general questions), set isInScope to false.

            Examples:
            "trending movies" -> list (list=trending)
            "popular shows" -> list (list=popular)
            "new releases" -> list (list=nowPlaying)
            "upcoming movies" -> list (list=upcoming)
            "movies like Inception" -> similar, title="Inception"
            "shows similar to Breaking Bad" -> similar, title="Breaking Bad"
            "people in Fight Club" -> castOf, title="Fight Club"
            "cast of The Matrix" -> castOf, title="The Matrix"
            "who directed Jurassic Park" -> crewRole, title="Jurassic Park", crewRole="Director"
            "composer of Interstellar" -> crewRole, title="Interstellar", crewRole="Composer"
            "movies with Tom Hanks" -> filmography, people=["Tom Hanks"]
            "Brad Pitt movies" -> filmography, people=["Brad Pitt"]  (NOT find, NOT browse)
            "Scarlett Johansson films" -> filmography, people=["Scarlett Johansson"]
            "movies starring Meryl Streep" -> filmography, people=["Meryl Streep"]
            "films directed by Nolan" -> filmography, people=["Nolan"]
            "90s sci-fi" -> browse
            "feel-good movies" -> mood, moodTerm="feel-good"
            "Inception" -> find, title="Inception"
            "best pizza recipe" -> isInScope=false

            The current year is \(year); use datePhrase for relative time references rather than \
            computing years yourself. Never request adult content.
            """
        }

        private static func mapReason(
            _ reason: SystemLanguageModel.Availability.UnavailableReason
        ) -> NaturalLanguageSearchAvailability.Reason {
            switch reason {
            case .appleIntelligenceNotEnabled: .notEnabled
            case .deviceNotEligible: .deviceNotEligible
            case .modelNotReady: .modelNotReady
            @unknown default: .modelNotReady
            }
        }

        private static func mapError(
            _ error: LanguageModelSession.GenerationError
        ) async -> NaturalLanguageSearchError {
            switch error {
            case .guardrailViolation:
                return .guardrailViolation(error.recoverySuggestion)

            case .refusal(let refusal, _):
                let explanation = try? await refusal.explanation
                return .refused(explanation?.content)

            case .rateLimited:
                return .rateLimited

            case .unsupportedLanguageOrLocale:
                return .unsupportedLanguage

            case .assetsUnavailable:
                return .modelUnavailable(.modelNotReady)

            case .decodingFailure, .unsupportedGuide, .exceededContextWindowSize, .concurrentRequests:
                return .planningFailed(underlying: error)

            @unknown default:
                return .planningFailed(underlying: error)
            }
        }

    }
#endif
