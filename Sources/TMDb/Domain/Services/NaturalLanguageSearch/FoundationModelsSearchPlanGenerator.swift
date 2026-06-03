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

        private func instructions() -> String {
            let year = Calendar(identifier: .gregorian).component(.year, from: now())
            return """
            You convert a movie or TV search request into a structured plan.
            If the request is just a title or a person's name with no other instruction, \
            use the find intent and put the text in title.
            Set isInScope to false if the request is not about movies, TV series, or people.
            The current year is \(year); use datePhrase for relative time references rather than \
            computing years yourself.
            Never request adult content.
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
