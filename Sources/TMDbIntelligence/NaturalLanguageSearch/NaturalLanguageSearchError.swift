//
//  NaturalLanguageSearchError.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

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
    /// The on-device model's session was rate limited. The request may be retried
    /// later.
    ///
    /// This is the **on-device model's** own limit, not TMDb's. A TMDb HTTP 429
    /// arrives as ``searchFailed(_:)`` carrying `TMDbError.tooManyRequests`,
    /// whose context carries any `Retry-After` delay. The two have different
    /// remedies, so a caller that retries should branch on which it received.
    ///
    case rateLimited

    ///
    /// Planning failed for another reason, such as malformed model output.
    ///
    case planningFailed(underlying: (any Error)?)

    ///
    /// A request to TMDb failed while the search was being carried out.
    ///
    /// Covers both plan execution and the literal-search fallback. It is distinct
    /// from the planning cases because the prompt was understood — it was the
    /// TMDb request that failed — so ``planningFailed(underlying:)``'s "could not
    /// be interpreted" would misreport the cause and hide a retryable condition
    /// such as a rate limit.
    ///
    /// - Note: When the literal-search fallback is what failed, the planning
    ///   error that triggered the fallback is not carried here. The TMDb failure
    ///   is the actionable one: had planning succeeded, execution would have
    ///   issued the same request and hit the same failure.
    ///
    case searchFailed(TMDbError)

    ///
    /// The task performing the search was cancelled.
    ///
    /// Distinct from ``planningFailed(underlying:)`` because the search did not
    /// fail — the caller withdrew it. It is never eligible for the literal-search
    /// fallback, so a cancelled search issues no further requests.
    ///
    case cancelled

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
            // The underlying error is not `Equatable`, so any two `.planningFailed`
            // values compare equal regardless of their wrapped cause.
            true
        case (.searchFailed(let lhsError), .searchFailed(let rhsError)):
            // `TMDbError` *is* `Equatable`, so unlike `.planningFailed` this
            // discriminates by cause. Omitting this arm would fall through to
            // `default: false` below and silently make a value unequal to itself.
            lhsError == rhsError
        case (.cancelled, .cancelled):
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
        case .searchFailed(let error):
            error.errorDescription ?? "The search request to TMDb failed."
        case .cancelled:
            "The search was cancelled."
        }
    }

}
