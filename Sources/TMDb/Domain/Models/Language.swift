//
//  Language.swift
//  TMDb
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// A model representing a language.
///
public struct Language: Identifiable, Codable, Equatable, Hashable, Sendable {

    ///
    /// Language code.
    ///
    public var id: String {
        code
    }

    ///
    /// The ISO 639-1 language code.
    ///
    public let code: String

    ///
    /// Language name.
    ///
    public let name: String

    ///
    /// English name.
    ///
    public let englishName: String

    ///
    /// Creates a language object.
    ///
    /// - Parameters:
    ///    - code: ISO 639-1 language code.
    ///    - name: Language name.
    ///    - englishName: English name.
    ///
    public init(code: String, name: String, englishName: String) {
        self.code = code
        self.name = name
        self.englishName = englishName
    }

}

extension Language {

    private enum CodingKeys: String, CodingKey {
        case code = "iso6391"
        case name
        case englishName
    }

}
