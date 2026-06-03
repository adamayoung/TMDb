//
//  NaturalLanguageSearchError.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// An error thrown by natural-language search.
///
public enum NaturalLanguageSearchError: Error, Equatable, Sendable {

    ///
    /// The on-device model is unavailable for the associated reason.
    ///
    case modelUnavailable(NaturalLanguageSearchAvailability.Reason)

    ///
    /// The prompt was classified as not being about movies, TV series, or
    /// people.
    ///
    case outOfScope

    ///
    /// The on-device safety guardrails blocked the prompt or the model's
    /// output. The associated value carries a recovery suggestion, if any.
    ///
    case guardrailViolation(String?)

    ///
    /// The model refused the request. The associated value carries an
    /// explanation, if one could be generated.
    ///
    case refused(String?)

    ///
    /// The prompt requested a language or locale the model does not support.
    ///
    case unsupportedLanguage

    ///
    /// The session was rate limited. The request may be retried later.
    ///
    case rateLimited

    ///
    /// Planning failed for another reason, such as malformed model output.
    ///
    case planningFailed(underlying: (any Error)?)

    public static func == (
        lhs: NaturalLanguageSearchError,
        rhs: NaturalLanguageSearchError
    ) -> Bool {
        switch (lhs, rhs) {
        case (.modelUnavailable(let lhsReason), .modelUnavailable(let rhsReason)):
            lhsReason == rhsReason
        case (.outOfScope, .outOfScope):
            true
        case (.guardrailViolation(let lhsMessage), .guardrailViolation(let rhsMessage)):
            lhsMessage == rhsMessage
        case (.refused(let lhsMessage), .refused(let rhsMessage)):
            lhsMessage == rhsMessage
        case (.unsupportedLanguage, .unsupportedLanguage):
            true
        case (.rateLimited, .rateLimited):
            true
        case (.planningFailed, .planningFailed):
            true
        default:
            false
        }
    }

}

extension NaturalLanguageSearchError: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case .modelUnavailable:
            "The on-device model is unavailable."
        case .outOfScope:
            "The request is not about movies, TV series, or people."
        case .guardrailViolation(let suggestion):
            suggestion ?? "The request was blocked by the on-device safety guardrails."
        case .refused(let explanation):
            explanation ?? "The on-device model declined the request."
        case .unsupportedLanguage:
            "The request uses a language the on-device model does not support."
        case .rateLimited:
            "The on-device model is rate limited. Try again shortly."
        case .planningFailed:
            "The request could not be interpreted."
        }
    }

}
