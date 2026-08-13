//
//  NaturalLanguageSearchAvailability.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb

///
/// The availability of on-device natural-language search.
///
/// Deterministic interpretation (Apple's Natural Language framework) is present
/// on every supported Apple platform, so this is ``available`` there. The
/// ``unavailable(_:)`` reasons describe why the optional Foundation Models
/// enhancement is absent on a given device.
///
public enum NaturalLanguageSearchAvailability: Sendable, Equatable {

    ///
    /// A reason the on-device model is unavailable.
    ///
    /// This mirrors the availability vocabulary of Apple's on-device model, which
    /// grows with the operating system. It is therefore a struct with static
    /// members rather than an enum: new reasons can be added in a **minor**
    /// release without breaking a `switch` you have already written. Match
    /// against the members you handle and cover the rest with a `default:`, and
    /// treat ``unknown`` as "a reason this build does not recognise".
    ///
    public struct Reason: Sendable, Equatable, Hashable, CustomStringConvertible {

        enum Kind: Hashable {
            case deviceNotEligible
            case notEnabled
            case modelNotReady
            case unsupportedOS
            case unknown
        }

        let kind: Kind

        private init(kind: Kind) {
            self.kind = kind
        }

        /// The device is not eligible to run the model.
        public static let deviceNotEligible = Reason(kind: .deviceNotEligible)

        /// Apple Intelligence is not enabled.
        public static let notEnabled = Reason(kind: .notEnabled)

        /// The model is not yet downloaded or ready.
        public static let modelNotReady = Reason(kind: .modelNotReady)

        /// The operating system does not support the model.
        public static let unsupportedOS = Reason(kind: .unsupportedOS)

        ///
        /// The model is unavailable for a reason this version of the library does
        /// not recognise.
        ///
        /// Apple can add availability reasons in an OS update. One that post-dates
        /// this build surfaces here rather than being reported as an unrelated
        /// reason, so a caller never acts on a misidentified cause — such as
        /// waiting for a download that is not actually pending.
        ///
        public static let unknown = Reason(kind: .unknown)

        /// A textual representation of the reason.
        public var description: String {
            switch kind {
            case .deviceNotEligible: "deviceNotEligible"
            case .notEnabled: "notEnabled"
            case .modelNotReady: "modelNotReady"
            case .unsupportedOS: "unsupportedOS"
            case .unknown: "unknown"
            }
        }

    }

    /// The model is available for use.
    case available

    /// The model is unavailable for the associated reason.
    case unavailable(Reason)

}
