//
//  TMDb.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//

import Foundation

///
/// Provides an interface to set up TMDb.
///
@available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, *)
public final class TMDb {

    private(set) static var configuration = TMDbConfiguration(
        apiKey: {
            preconditionFailure("Configuration must first be set by calling TMDb.configure(_:).")
        },
        httpClient: {
            preconditionFailure("Configuration must first be set by calling TMDb.configure(_:).")
        }
    )

    private init() {}

    ///
    /// Sets the configuration to be used with TMDb services.
    ///
    /// - Parameters:
    ///    - configuration: A TMDb configuration object.
    ///
    public static func configure(_ configuration: TMDbConfiguration) {
        Self.configuration = configuration
    }

}
