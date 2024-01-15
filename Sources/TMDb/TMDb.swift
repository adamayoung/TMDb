//
//  TMDb.swift
//  TMDb
//
//  Copyright © 2023 Adam Young.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an AS IS BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

///
/// Provides an interface to set up TMDb.
///
@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, visionOS 1.0, *)
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
