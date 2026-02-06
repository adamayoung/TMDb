//
//  CreditType.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a credit type.
///
public enum CreditType: String, Codable, Equatable, Hashable, Sendable {

    ///
    /// Cast credit type.
    ///
    case cast

    ///
    /// Crew credit type.
    ///
    case crew

}
