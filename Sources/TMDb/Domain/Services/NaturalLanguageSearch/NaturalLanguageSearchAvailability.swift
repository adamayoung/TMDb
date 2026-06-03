//
//  NaturalLanguageSearchAvailability.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// The availability of on-device natural-language search.
///
/// Natural-language search relies on an on-device language model that is only
/// present on supported Apple platforms with Apple Intelligence enabled.
///
public enum NaturalLanguageSearchAvailability: Sendable, Equatable {

    ///
    /// A reason the on-device model is unavailable.
    ///
    public enum Reason: Sendable, Equatable {

        /// The device is not eligible to run the model.
        case deviceNotEligible

        /// Apple Intelligence is not enabled.
        case notEnabled

        /// The model is not yet downloaded or ready.
        case modelNotReady

        /// The operating system does not support the model.
        case unsupportedOS
    }

    /// The model is available for use.
    case available

    /// The model is unavailable for the associated reason.
    case unavailable(Reason)

}
